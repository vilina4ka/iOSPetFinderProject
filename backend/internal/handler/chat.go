package handler

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/gorilla/websocket"
	"github.com/lapki/backend/internal/service"
)

type ChatHandler struct {
	service *service.ChatService
	hub     *Hub
}

func NewChatHandler(svc *service.ChatService, hub *Hub) *ChatHandler {
	return &ChatHandler{service: svc, hub: hub}
}

// @Summary     Список чатов
// @Description Возвращает все диалоги текущего пользователя
// @Tags        chat
// @Produce     json
// @Security    BearerAuth
// @Success     200 {array}  model.ChatThread
// @Router      /chats [get]
func (h *ChatHandler) ListChats(c *gin.Context) {
	userID := c.GetString("user_id")
	threads, err := h.service.ListThreads(c.Request.Context(), userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка сервера"})
		return
	}
	c.JSON(http.StatusOK, threads)
}

type GetMessagesRequest struct {
	OtherUserID string `form:"other_user_id" binding:"required"`
	SightingID  string `form:"sighting_id"`
	Limit       int    `form:"limit"`
	Offset      int    `form:"offset"`
}

// @Summary     История сообщений
// @Description Возвращает сообщения чата по питомцу между двумя пользователями
// @Tags        chat
// @Produce     json
// @Security    BearerAuth
// @Param       petID        path  string true  "Pet ID"
// @Param       other_user_id query string true  "ID собеседника"
// @Param       limit         query int    false "Лимит (макс 100)"
// @Param       offset        query int    false "Смещение"
// @Success     200 {array}  model.Message
// @Router      /chats/{petID} [get]
func (h *ChatHandler) GetMessages(c *gin.Context) {
	userID := c.GetString("user_id")
	petID := c.Param("petID")

	var req GetMessagesRequest
	if err := c.BindQuery(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Неверные параметры"})
		return
	}
	if req.Limit == 0 {
		req.Limit = 50
	}
	if req.Limit > 100 {
		req.Limit = 100
	}

	messages, err := h.service.GetMessages(c.Request.Context(), petID, userID, req.OtherUserID, req.SightingID, req.Limit, req.Offset)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка сервера"})
		return
	}
	c.JSON(http.StatusOK, messages)
}

// @Summary     Отметить сообщения прочитанными
// @Description Помечает все сообщения в чате как прочитанные
// @Tags        chat
// @Produce     json
// @Security    BearerAuth
// @Param       petID        path  string true "Pet ID"
// @Param       other_user_id query string true "ID собеседника"
// @Success     200 {object} map[string]bool
// @Router      /chats/{petID}/read [post]
func (h *ChatHandler) MarkMessagesRead(c *gin.Context) {
	userID := c.GetString("user_id")
	petID := c.Param("petID")

	otherUserID := c.Query("other_user_id")
	if otherUserID == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "other_user_id обязателен"})
		return
	}

	if err := h.service.MarkRead(c.Request.Context(), petID, userID, otherUserID); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка сервера"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"ok": true})
}

type SendMessageRequest struct {
	RecipientID string  `json:"recipient_id" binding:"required"`
	Text        string  `json:"text"`
	SightingID  *string `json:"sighting_id"`
	ImageURL    *string `json:"image_url"`
	FileName    *string `json:"file_name"`
}

// @Summary     Отправить сообщение
// @Description Отправляет текстовое сообщение или вложение в чат
// @Tags        chat
// @Accept      json
// @Produce     json
// @Security    BearerAuth
// @Param       petID path string true "Pet ID"
// @Param       body  body SendMessageRequest true "Сообщение"
// @Success     201 {object} map[string]string
// @Router      /chats/{petID}/message [post]
func (h *ChatHandler) SendMessage(c *gin.Context) {
	userID := c.GetString("user_id")
	petID := c.Param("petID")

	var req SendMessageRequest
	if err := c.BindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Неверный формат данных"})
		return
	}

	if req.Text == "" && req.ImageURL == nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Необходимо указать текст или вложение"})
		return
	}

	id, createdAt, err := h.service.SendMessage(c.Request.Context(), petID, req.SightingID, userID, req.RecipientID, req.Text, req.ImageURL, req.FileName)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка при отправке сообщения"})
		return
	}
	c.JSON(http.StatusCreated, gin.H{"id": id, "createdAt": createdAt})
}

// @Summary     Удалить сообщение
// @Description Удаляет сообщение (только отправитель)
// @Tags        chat
// @Produce     json
// @Security    BearerAuth
// @Param       messageID path string true "Message ID"
// @Success     200 {object} map[string]bool
// @Failure     403 {object} map[string]string
// @Router      /chats/message/{messageID} [delete]
func (h *ChatHandler) DeleteMessage(c *gin.Context) {
	userID := c.GetString("user_id")
	messageID := c.Param("messageID")

	if err := h.service.DeleteMessage(c.Request.Context(), messageID, userID); err != nil {
		c.JSON(http.StatusForbidden, gin.H{"error": "Сообщение не найдено или нет прав"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"ok": true})
}

type EditMessageRequest struct {
	Text string `json:"text" binding:"required"`
}

// @Summary     Редактировать сообщение
// @Description Изменяет текст сообщения (только отправитель)
// @Tags        chat
// @Accept      json
// @Produce     json
// @Security    BearerAuth
// @Param       messageID path string true "Message ID"
// @Param       body      body EditMessageRequest true "Новый текст"
// @Success     200 {object} map[string]bool
// @Failure     403 {object} map[string]string
// @Router      /chats/message/{messageID} [patch]
func (h *ChatHandler) EditMessage(c *gin.Context) {
	userID := c.GetString("user_id")
	messageID := c.Param("messageID")

	var req EditMessageRequest
	if err := c.BindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Неверный формат данных"})
		return
	}
	if err := h.service.EditMessage(c.Request.Context(), messageID, userID, req.Text); err != nil {
		c.JSON(http.StatusForbidden, gin.H{"error": "Сообщение не найдено или нет прав"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"ok": true})
}

var upgrader = websocket.Upgrader{
	ReadBufferSize:  1024,
	WriteBufferSize: 1024,
	CheckOrigin:     func(r *http.Request) bool { return true },
}

func (h *ChatHandler) WebSocket(c *gin.Context) {
	userID := c.GetString("user_id")
	if userID == "" {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Не авторизован"})
		return
	}

	ws, err := upgrader.Upgrade(c.Writer, c.Request, nil)
	if err != nil {
		return
	}

	client := h.hub.Register(userID, ws)
	defer func() {
		h.hub.Unregister(userID)
		ws.Close()
	}()

	// Write pump: forwards messages from hub to WebSocket.
	go func() {
		for msg := range client.send {
			if err := ws.WriteMessage(websocket.TextMessage, msg); err != nil {
				return
			}
		}
	}()

	// Read pump: keeps the connection alive and handles client-side pings.
	for {
		if _, _, err := ws.ReadMessage(); err != nil {
			break
		}
	}
}
