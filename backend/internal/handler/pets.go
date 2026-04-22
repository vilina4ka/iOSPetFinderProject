package handler

import (
	"context"
	"fmt"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5"
	"github.com/lapki/backend/internal/config"
	"github.com/lapki/backend/internal/model"
	"github.com/lapki/backend/internal/repository"
)

type PetsHandler struct {
	pets  repository.PetRepo
	notif repository.NotificationRepo
	subs  repository.SubscriptionRepo
	cfg   *config.Config
}

func NewPetsHandler(pets repository.PetRepo, notif repository.NotificationRepo, subs repository.SubscriptionRepo, cfg *config.Config) *PetsHandler {
	return &PetsHandler{pets: pets, notif: notif, subs: subs, cfg: cfg}
}

func (h *PetsHandler) ListPets(c *gin.Context) {
	var req model.ListPetsRequest
	if err := c.BindQuery(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Неверные параметры"})
		return
	}

	pets, err := h.pets.ListInRadius(c.Request.Context(), req.Latitude, req.Longitude, req.Radius, req.SearchText)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка сервера"})
		return
	}

	if req.PetType != "" {
		filtered := pets[:0]
		for _, p := range pets {
			if p.Type == req.PetType {
				filtered = append(filtered, p)
			}
		}
		pets = filtered
	}

	if req.LostFrom != "" {
		from, err := time.Parse("2006-01-02", req.LostFrom)
		if err == nil {
			filtered := pets[:0]
			for _, p := range pets {
				if p.LostDate != nil && !p.LostDate.Before(from) {
					filtered = append(filtered, p)
				}
			}
			pets = filtered
		}
	}

	if req.LostTo != "" {
		to, err := time.Parse("2006-01-02", req.LostTo)
		if err == nil {
			to = to.Add(24*time.Hour - time.Second)
			filtered := pets[:0]
			for _, p := range pets {
				if p.LostDate != nil && !p.LostDate.After(to) {
					filtered = append(filtered, p)
				}
			}
			pets = filtered
		}
	}

	if req.Breed != "" {
		filtered := pets[:0]
		for _, p := range pets {
			if p.Breed == req.Breed {
				filtered = append(filtered, p)
			}
		}
		pets = filtered
	}

	c.JSON(http.StatusOK, pets)
}

func (h *PetsHandler) GetPet(c *gin.Context) {
	pet, err := h.pets.GetByID(c.Request.Context(), c.Param("id"))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка сервера"})
		return
	}
	if pet == nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Питомец не найден"})
		return
	}
	c.JSON(http.StatusOK, pet)
}

func (h *PetsHandler) CreatePet(c *gin.Context) {
	userID := c.GetString("user_id")
	if userID == "" {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Не авторизован"})
		return
	}

	var req model.CreatePetRequest
	if err := c.BindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Sprintf("Неверный формат данных: %v", err)})
		return
	}

	petID, err := h.pets.Create(c.Request.Context(), userID, req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка при создании питомца"})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"id": petID, "message": "Питомец добавлен"})
}

func (h *PetsHandler) UpdatePet(c *gin.Context) {
	userID := c.GetString("user_id")
	petID := c.Param("id")

	ownerID, err := h.pets.GetOwnerID(c.Request.Context(), petID)
	if err == pgx.ErrNoRows {
		c.JSON(http.StatusNotFound, gin.H{"error": "Питомец не найден"})
		return
	}
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка сервера"})
		return
	}
	if ownerID != userID {
		c.JSON(http.StatusForbidden, gin.H{"error": "У вас нет прав редактировать этого питомца"})
		return
	}

	var req struct {
		Name          string     `json:"name"`
		Type          string     `json:"type"`
		Breed         string     `json:"breed"`
		Age           *int       `json:"age"`
		Description   string     `json:"description"`
		ExternalSigns string     `json:"external_signs"`
		ContactPhone  string     `json:"contact_phone"`
		ContactName   string     `json:"contact_name"`
		ImageURLs     []string   `json:"image_urls"`
		Address       string     `json:"address"`
		Latitude      *float64   `json:"latitude"`
		Longitude     *float64   `json:"longitude"`
		LostDate      *time.Time `json:"lost_date"`
	}
	if err := c.BindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Sprintf("Неверный формат данных: %v", err)})
		return
	}

	if err := h.pets.Update(c.Request.Context(), petID, repository.PetUpdateParams{
		Name: req.Name, Type: req.Type, Breed: req.Breed, Age: req.Age,
		Description: req.Description, ExternalSigns: req.ExternalSigns,
		ContactPhone: req.ContactPhone, ContactName: req.ContactName,
		ImageURLs: req.ImageURLs, Address: req.Address,
		Latitude: req.Latitude, Longitude: req.Longitude, LostDate: req.LostDate,
	}); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка при обновлении"})
		return
	}

	subs := h.subs
	notif := h.notif
	go func() {
		subscribers, err := subs.ListSubscribers(context.Background(), petID)
		if err != nil {
			return
		}
		for _, subscriberID := range subscribers {
			if subscriberID == userID {
				continue
			}
			_ = notif.Create(context.Background(), subscriberID, "update", petID,
				fmt.Sprintf("Обновлена анкета: %s", req.Name),
				"Владелец обновил информацию о питомце",
			)
		}
	}()

	c.JSON(http.StatusOK, gin.H{"message": "Питомец обновлен"})
}

func (h *PetsHandler) PatchPetStatus(c *gin.Context) {
	userID := c.GetString("user_id")
	petID := c.Param("id")

	ownerID, err := h.pets.GetOwnerID(c.Request.Context(), petID)
	if err == pgx.ErrNoRows {
		c.JSON(http.StatusNotFound, gin.H{"error": "Питомец не найден"})
		return
	}
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка сервера"})
		return
	}
	if ownerID != userID {
		c.JSON(http.StatusForbidden, gin.H{"error": "Нет прав"})
		return
	}

	var req struct {
		Status string `json:"status" binding:"required"`
	}
	if err := c.BindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Укажите status"})
		return
	}

	if err := h.pets.PatchStatus(c.Request.Context(), petID, req.Status); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка при обновлении"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Статус обновлён"})
}

func (h *PetsHandler) DeletePet(c *gin.Context) {
	userID := c.GetString("user_id")
	petID := c.Param("id")

	ownerID, err := h.pets.GetOwnerID(c.Request.Context(), petID)
	if err == pgx.ErrNoRows {
		c.JSON(http.StatusNotFound, gin.H{"error": "Питомец не найден"})
		return
	}
	if ownerID != userID {
		c.JSON(http.StatusForbidden, gin.H{"error": "У вас нет прав удалять этого питомца"})
		return
	}

	if err := h.pets.Delete(c.Request.Context(), petID); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка при удалении"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Питомец удален"})
}

func (h *PetsHandler) AddSighting(c *gin.Context) {
	userID := c.GetString("user_id")
	petID := c.Param("id")

	var req struct {
		Latitude  float64  `json:"latitude" binding:"required"`
		Longitude float64  `json:"longitude" binding:"required"`
		Address   string   `json:"address"`
		Comment   string   `json:"comment"`
		ImageURLs []string `json:"image_urls"`
	}
	if err := c.BindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Неверный формат данных"})
		return
	}

	sightingID, ownerID, petName, err := h.pets.AddSighting(c.Request.Context(), petID, userID, repository.SightingParams{
		Latitude: req.Latitude, Longitude: req.Longitude,
		Address: req.Address, Comment: req.Comment, ImageURLs: req.ImageURLs,
	})
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка при добавлении наблюдения"})
		return
	}

	if ownerID != "" && ownerID != userID {
		notif := h.notif
		address := req.Address
		go func() {
			_ = notif.Create(context.Background(), ownerID, "sighting", petID,
				fmt.Sprintf("Возможно видели %s", petName),
				address,
			)
		}()
	}

	c.JSON(http.StatusCreated, gin.H{"id": sightingID, "message": "Спасибо за информацию!"})
}

func (h *PetsHandler) PatchSightingStatus(c *gin.Context) {
	userID := c.GetString("user_id")
	petID := c.Param("id")
	sightingID := c.Param("sightingId")

	ownerID, err := h.pets.GetOwnerID(c.Request.Context(), petID)
	if err == pgx.ErrNoRows {
		c.JSON(http.StatusNotFound, gin.H{"error": "Питомец не найден"})
		return
	}
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка сервера"})
		return
	}
	if ownerID != userID {
		c.JSON(http.StatusForbidden, gin.H{"error": "Нет прав"})
		return
	}

	var req struct {
		Status string `json:"status" binding:"required"`
	}
	if err := c.BindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Укажите status"})
		return
	}
	if req.Status != "confirmed" && req.Status != "rejected" && req.Status != "pending" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Допустимые значения: confirmed, rejected, pending"})
		return
	}

	if err := h.pets.PatchSightingStatus(c.Request.Context(), sightingID, req.Status); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка сервера"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Статус обновлён"})
}

func (h *PetsHandler) GetSightings(c *gin.Context) {
	sightings, err := h.pets.GetSightings(c.Request.Context(), c.Param("id"))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка сервера"})
		return
	}
	c.JSON(http.StatusOK, sightings)
}

func (h *PetsHandler) ListMyPets(c *gin.Context) {
	pets, err := h.pets.ListByOwner(c.Request.Context(), c.GetString("user_id"))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка сервера"})
		return
	}
	if pets == nil {
		pets = []model.Pet{}
	}
	c.JSON(http.StatusOK, pets)
}
