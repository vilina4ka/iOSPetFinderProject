package handler

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/lapki/backend/internal/config"
	"github.com/lapki/backend/internal/repository"
)

type NotificationsHandler struct {
	notif repository.NotificationRepo
	cfg   *config.Config
}

func NewNotificationsHandler(notif repository.NotificationRepo, cfg *config.Config) *NotificationsHandler {
	return &NotificationsHandler{notif: notif, cfg: cfg}
}

func (h *NotificationsHandler) ListNotifications(c *gin.Context) {
	userID := c.GetString("user_id")
	if userID == "" {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Не авторизован"})
		return
	}

	notifications, err := h.notif.ListByUser(c.Request.Context(), userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка сервера"})
		return
	}

	c.JSON(http.StatusOK, notifications)
}

func (h *NotificationsHandler) UnreadCount(c *gin.Context) {
	userID := c.GetString("user_id")
	if userID == "" {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Не авторизован"})
		return
	}

	count, err := h.notif.UnreadCount(c.Request.Context(), userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка сервера"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"count": count})
}

func (h *NotificationsHandler) MarkRead(c *gin.Context) {
	userID := c.GetString("user_id")
	if userID == "" {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Не авторизован"})
		return
	}

	notifID := c.Param("id")
	if notifID == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "ID уведомления обязателен"})
		return
	}

	if err := h.notif.MarkRead(c.Request.Context(), userID, notifID); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка сервера"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"ok": true})
}

func (h *NotificationsHandler) MarkAllRead(c *gin.Context) {
	userID := c.GetString("user_id")
	if userID == "" {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Не авторизован"})
		return
	}

	if err := h.notif.MarkAllRead(c.Request.Context(), userID); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка сервера"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"ok": true})
}
