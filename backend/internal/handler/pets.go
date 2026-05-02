package handler

import (
	"errors"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/lapki/backend/internal/model"
	"github.com/lapki/backend/internal/repository"
	"github.com/lapki/backend/internal/service"
)

type PetsHandler struct {
	service *service.PetService
}

func NewPetsHandler(svc *service.PetService) *PetsHandler {
	return &PetsHandler{service: svc}
}

// @Summary     Список объявлений
// @Description Геопоиск потерявшихся питомцев в заданном радиусе
// @Tags        pets
// @Produce     json
// @Security    BearerAuth
// @Param       lat       query number true  "Широта"
// @Param       lon       query number true  "Долгота"
// @Param       radius_km query number false "Радиус поиска в км (по умолчанию 5)"
// @Param       search    query string false "Текстовый поиск"
// @Param       pet_type  query string false "Тип животного (cat/dog)"
// @Success     200 {array}  model.Pet
// @Failure     500 {object} map[string]string
// @Router      /pets [get]
func (h *PetsHandler) ListPets(c *gin.Context) {
	var req model.ListPetsRequest
	if err := c.BindQuery(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Неверные параметры"})
		return
	}
	pets, err := h.service.ListPets(c.Request.Context(), req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка сервера"})
		return
	}
	c.JSON(http.StatusOK, pets)
}

// @Summary     Карточка питомца
// @Description Возвращает полную информацию об объявлении
// @Tags        pets
// @Produce     json
// @Security    BearerAuth
// @Param       id path string true "Pet ID"
// @Success     200 {object} model.Pet
// @Failure     404 {object} map[string]string
// @Router      /pets/{id} [get]
func (h *PetsHandler) GetPet(c *gin.Context) {
	pet, err := h.service.GetPet(c.Request.Context(), c.Param("id"))
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

// @Summary     Создать объявление
// @Description Создаёт новое объявление о пропавшем питомце
// @Tags        pets
// @Accept      json
// @Produce     json
// @Security    BearerAuth
// @Param       body body model.CreatePetRequest true "Данные питомца"
// @Success     201 {object} map[string]string
// @Failure     400 {object} map[string]string
// @Router      /pets [post]
func (h *PetsHandler) CreatePet(c *gin.Context) {
	userID := c.GetString("user_id")
	if userID == "" {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Не авторизован"})
		return
	}
	var req model.CreatePetRequest
	if err := c.BindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Неверный формат данных"})
		return
	}
	petID, err := h.service.CreatePet(c.Request.Context(), userID, req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка при создании питомца"})
		return
	}
	c.JSON(http.StatusCreated, gin.H{"id": petID, "message": "Питомец добавлен"})
}

// @Summary     Обновить объявление
// @Description Редактирует данные питомца (только владелец)
// @Tags        pets
// @Accept      json
// @Produce     json
// @Security    BearerAuth
// @Param       id   path string true "Pet ID"
// @Param       body body object true "Обновлённые данные"
// @Success     200 {object} map[string]string
// @Failure     403 {object} map[string]string
// @Failure     404 {object} map[string]string
// @Router      /pets/{id} [put]
func (h *PetsHandler) UpdatePet(c *gin.Context) {
	userID := c.GetString("user_id")
	petID := c.Param("id")

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
		c.JSON(http.StatusBadRequest, gin.H{"error": "Неверный формат данных"})
		return
	}

	params := repository.PetUpdateParams{
		Name: req.Name, Type: req.Type, Breed: req.Breed, Age: req.Age,
		Description: req.Description, ExternalSigns: req.ExternalSigns,
		ContactPhone: req.ContactPhone, ContactName: req.ContactName,
		ImageURLs: req.ImageURLs, Address: req.Address,
		Latitude: req.Latitude, Longitude: req.Longitude, LostDate: req.LostDate,
	}

	if err := h.service.UpdatePet(c.Request.Context(), petID, userID, params); err != nil {
		switch {
		case errors.Is(err, service.ErrNotFound):
			c.JSON(http.StatusNotFound, gin.H{"error": "Питомец не найден"})
		case errors.Is(err, service.ErrForbidden):
			c.JSON(http.StatusForbidden, gin.H{"error": "У вас нет прав редактировать этого питомца"})
		default:
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка при обновлении"})
		}
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Питомец обновлен"})
}

// @Summary     Сменить статус питомца
// @Description Отмечает питомца как найденного (status: found)
// @Tags        pets
// @Accept      json
// @Produce     json
// @Security    BearerAuth
// @Param       id   path string true "Pet ID"
// @Param       body body object true "{\"status\": \"found\"}"
// @Success     200 {object} map[string]string
// @Failure     403 {object} map[string]string
// @Router      /pets/{id}/status [patch]
func (h *PetsHandler) PatchPetStatus(c *gin.Context) {
	userID := c.GetString("user_id")
	petID := c.Param("id")

	var req struct {
		Status string `json:"status" binding:"required"`
	}
	if err := c.BindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Укажите status"})
		return
	}

	if err := h.service.PatchPetStatus(c.Request.Context(), petID, userID, req.Status); err != nil {
		switch {
		case errors.Is(err, service.ErrNotFound):
			c.JSON(http.StatusNotFound, gin.H{"error": "Питомец не найден"})
		case errors.Is(err, service.ErrForbidden):
			c.JSON(http.StatusForbidden, gin.H{"error": "Нет прав"})
		default:
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка при обновлении"})
		}
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Статус обновлён"})
}

// @Summary     Удалить объявление
// @Description Удаляет объявление и все связанные данные (только владелец)
// @Tags        pets
// @Produce     json
// @Security    BearerAuth
// @Param       id path string true "Pet ID"
// @Success     200 {object} map[string]string
// @Failure     403 {object} map[string]string
// @Router      /pets/{id} [delete]
func (h *PetsHandler) DeletePet(c *gin.Context) {
	userID := c.GetString("user_id")
	petID := c.Param("id")

	if err := h.service.DeletePet(c.Request.Context(), petID, userID); err != nil {
		switch {
		case errors.Is(err, service.ErrNotFound):
			c.JSON(http.StatusNotFound, gin.H{"error": "Питомец не найден"})
		case errors.Is(err, service.ErrForbidden):
			c.JSON(http.StatusForbidden, gin.H{"error": "У вас нет прав удалять этого питомца"})
		default:
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка при удалении"})
		}
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Питомец удален"})
}

// @Summary     Добавить наблюдение
// @Description Сообщает о месте, где видели питомца
// @Tags        sightings
// @Accept      json
// @Produce     json
// @Security    BearerAuth
// @Param       id   path string true "Pet ID"
// @Param       body body object true "Координаты и комментарий"
// @Success     201 {object} map[string]string
// @Router      /pets/{id}/sightings [post]
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

	sightingID, err := h.service.AddSighting(c.Request.Context(), petID, userID, repository.SightingParams{
		Latitude: req.Latitude, Longitude: req.Longitude,
		Address: req.Address, Comment: req.Comment, ImageURLs: req.ImageURLs,
	})
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка при добавлении наблюдения"})
		return
	}
	c.JSON(http.StatusCreated, gin.H{"id": sightingID, "message": "Спасибо за информацию!"})
}

// @Summary     Подтвердить / отклонить наблюдение
// @Description Владелец меняет статус наблюдения (confirmed / rejected)
// @Tags        sightings
// @Accept      json
// @Produce     json
// @Security    BearerAuth
// @Param       id         path string true "Pet ID"
// @Param       sightingId path string true "Sighting ID"
// @Param       body       body object true "{\"status\": \"confirmed\"}"
// @Success     200 {object} map[string]string
// @Failure     403 {object} map[string]string
// @Router      /pets/{id}/sightings/{sightingId}/status [patch]
func (h *PetsHandler) PatchSightingStatus(c *gin.Context) {
	userID := c.GetString("user_id")
	petID := c.Param("id")
	sightingID := c.Param("sightingId")

	var req struct {
		Status string `json:"status" binding:"required"`
	}
	if err := c.BindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Укажите status"})
		return
	}

	if err := h.service.PatchSightingStatus(c.Request.Context(), petID, sightingID, userID, req.Status); err != nil {
		switch {
		case errors.Is(err, service.ErrNotFound):
			c.JSON(http.StatusNotFound, gin.H{"error": "Питомец не найден"})
		case errors.Is(err, service.ErrForbidden):
			c.JSON(http.StatusForbidden, gin.H{"error": "Нет прав"})
		default:
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		}
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Статус обновлён"})
}

// @Summary     Список наблюдений
// @Description Возвращает все наблюдения по объявлению
// @Tags        sightings
// @Produce     json
// @Security    BearerAuth
// @Param       id path string true "Pet ID"
// @Success     200 {array} model.Sighting
// @Router      /pets/{id}/sightings [get]
func (h *PetsHandler) GetSightings(c *gin.Context) {
	sightings, err := h.service.GetSightings(c.Request.Context(), c.Param("id"))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка сервера"})
		return
	}
	c.JSON(http.StatusOK, sightings)
}

// @Summary     Мои объявления
// @Description Возвращает все объявления текущего пользователя
// @Tags        pets
// @Produce     json
// @Security    BearerAuth
// @Success     200 {array} model.Pet
// @Router      /me/pets [get]
func (h *PetsHandler) ListMyPets(c *gin.Context) {
	pets, err := h.service.ListMyPets(c.Request.Context(), c.GetString("user_id"))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка сервера"})
		return
	}
	if pets == nil {
		pets = []model.Pet{}
	}
	c.JSON(http.StatusOK, pets)
}
