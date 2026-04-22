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

func (h *SubscriptionsHandler) Subscribe(c *gin.Context) {
	if err := h.subs.Subscribe(c.Request.Context(), c.GetString("user_id"), c.Param("id")); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка при подписке"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"subscribed": true})
}

func (h *SubscriptionsHandler) Unsubscribe(c *gin.Context) {
	if err := h.subs.Unsubscribe(c.Request.Context(), c.GetString("user_id"), c.Param("id")); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка при отписке"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"subscribed": false})
}

func (h *SubscriptionsHandler) IsSubscribed(c *gin.Context) {
	subscribed, err := h.subs.IsSubscribed(c.Request.Context(), c.GetString("user_id"), c.Param("id"))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка сервера"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"subscribed": subscribed})
}

func (h *SubscriptionsHandler) ListSubscribed(c *gin.Context) {
	pets, err := h.subs.ListSubscribed(c.Request.Context(), c.GetString("user_id"))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка сервера"})
		return
	}
	c.JSON(http.StatusOK, pets)
}
