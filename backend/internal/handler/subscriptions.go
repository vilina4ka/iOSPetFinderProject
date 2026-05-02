package handler

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/lapki/backend/internal/config"
	"github.com/lapki/backend/internal/repository"
)

type SubscriptionsHandler struct {
	subs repository.SubscriptionRepo
	cfg  *config.Config
}

func NewSubscriptionsHandler(subs repository.SubscriptionRepo, cfg *config.Config) *SubscriptionsHandler {
	return &SubscriptionsHandler{subs: subs, cfg: cfg}
}

// @Summary     Подписаться на объявление
// @Tags        subscriptions
// @Produce     json
// @Security    BearerAuth
// @Param       id path string true "Pet ID"
// @Success     200 {object} map[string]bool
// @Router      /pets/{id}/subscribe [post]
func (h *SubscriptionsHandler) Subscribe(c *gin.Context) {
	if err := h.subs.Subscribe(c.Request.Context(), c.GetString("user_id"), c.Param("id")); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка при подписке"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"subscribed": true})
}

// @Summary     Отписаться от объявления
// @Tags        subscriptions
// @Produce     json
// @Security    BearerAuth
// @Param       id path string true "Pet ID"
// @Success     200 {object} map[string]bool
// @Router      /pets/{id}/subscribe [delete]
func (h *SubscriptionsHandler) Unsubscribe(c *gin.Context) {
	if err := h.subs.Unsubscribe(c.Request.Context(), c.GetString("user_id"), c.Param("id")); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка при отписке"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"subscribed": false})
}

// @Summary     Статус подписки
// @Tags        subscriptions
// @Produce     json
// @Security    BearerAuth
// @Param       id path string true "Pet ID"
// @Success     200 {object} map[string]bool
// @Router      /pets/{id}/subscribed [get]
func (h *SubscriptionsHandler) IsSubscribed(c *gin.Context) {
	subscribed, err := h.subs.IsSubscribed(c.Request.Context(), c.GetString("user_id"), c.Param("id"))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка сервера"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"subscribed": subscribed})
}

// @Summary     Список объявлений с подпиской
// @Tags        subscriptions
// @Produce     json
// @Security    BearerAuth
// @Success     200 {array} model.Pet
// @Router      /subscriptions [get]
func (h *SubscriptionsHandler) ListSubscribed(c *gin.Context) {
	pets, err := h.subs.ListSubscribed(c.Request.Context(), c.GetString("user_id"))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка сервера"})
		return
	}
	c.JSON(http.StatusOK, pets)
}
