package handler

import (
	"context"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/gorilla/websocket"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/lapki/backend/internal/config"
	"github.com/lapki/backend/internal/model"
	"github.com/lapki/backend/internal/repository"
)

type ChatHandler struct {
	pool  *pgxpool.Pool
	notif repository.NotificationRepo
	cfg   *config.Config
}

func NewChatHandler(pool *pgxpool.Pool, notif repository.NotificationRepo, cfg *config.Config) *ChatHandler {
	return &ChatHandler{pool: pool, notif: notif, cfg: cfg}
}

func (h *ChatHandler) ListChats(c *gin.Context) {
	userID := c.GetString("user_id")

	rows, err := h.pool.Query(c.Request.Context(), `
		WITH ranked AS (
			SELECT
				m.*,
				ROW_NUMBER() OVER (
					PARTITION BY m.pet_id,
					             LEAST(m.sender_id, m.recipient_id), GREATEST(m.sender_id, m.recipient_id)
					ORDER BY m.created_at DESC
				) AS rn
			FROM messages m
			WHERE m.sender_id = $1 OR m.recipient_id = $1
		)
		SELECT
			r.pet_id,
			r.sighting_id,
			p.name AS pet_name,
			COALESCE(p.image_urls[1], '') AS pet_image_url,
			CASE WHEN r.sender_id = $1 THEN r.recipient_id ELSE r.sender_id END AS other_user_id,
			COALESCE(u.name, 'Аноним') AS other_user_name,
			COALESCE(u.avatar_url, '') AS other_user_avatar,
			r.text AS last_message,
			r.created_at AS last_message_at,
			(
				SELECT COUNT(*) FROM messages m2
				WHERE m2.pet_id = r.pet_id
				  AND m2.recipient_id = $1
				  AND NOT m2.is_read
				  AND m2.sender_id = CASE WHEN r.sender_id = $1 THEN r.recipient_id ELSE r.sender_id END
			) AS unread_count
		FROM ranked r
		JOIN pets p ON p.id = r.pet_id
		JOIN users u ON u.id = CASE WHEN r.sender_id = $1 THEN r.recipient_id ELSE r.sender_id END
		WHERE r.rn = 1
		ORDER BY r.created_at DESC
	`, userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка сервера"})
		return
	}
	defer rows.Close()

	var threads []model.ChatThread
	for rows.Next() {
		var t model.ChatThread
		if err := rows.Scan(
			&t.PetID, &t.SightingID, &t.PetName, &t.PetImageURL,
			&t.OtherUserID, &t.OtherUserName, &t.OtherUserAvatar,
			&t.LastMessage, &t.LastMessageAt, &t.UnreadCount,
		); err != nil {
			continue
		}
		threads = append(threads, t)
	}

	if threads == nil {
		threads = []model.ChatThread{}
	}
	c.JSON(http.StatusOK, threads)
}

type GetMessagesRequest struct {
	OtherUserID string `form:"other_user_id" binding:"required"`
	SightingID  string `form:"sighting_id"`
	Limit       int    `form:"limit"`
	Offset      int    `form:"offset"`
}

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

	var rows interface {
		Next() bool
		Scan(...any) error
		Close()
	}
	var err error

	if req.SightingID != "" {
		rows, err = h.pool.Query(c.Request.Context(),
			`SELECT id, pet_id, sighting_id, sender_id, recipient_id, text, is_read, created_at
			 FROM messages
			 WHERE pet_id = $1 AND sighting_id = $2
			 AND ((sender_id = $3 AND recipient_id = $4) OR (sender_id = $4 AND recipient_id = $3))
			 ORDER BY created_at DESC LIMIT $5 OFFSET $6`,
			petID, req.SightingID, userID, req.OtherUserID, req.Limit, req.Offset,
		)
	} else {
		rows, err = h.pool.Query(c.Request.Context(),
			`SELECT id, pet_id, sighting_id, sender_id, recipient_id, text, is_read, created_at
			 FROM messages
			 WHERE pet_id = $1 AND sighting_id IS NULL
			 AND ((sender_id = $2 AND recipient_id = $3) OR (sender_id = $3 AND recipient_id = $2))
			 ORDER BY created_at DESC LIMIT $4 OFFSET $5`,
			petID, userID, req.OtherUserID, req.Limit, req.Offset,
		)
	}
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка сервера"})
		return
	}
	defer rows.Close()

	var messages []model.Message
	for rows.Next() {
		var m model.Message
		if err := rows.Scan(&m.ID, &m.PetID, &m.SightingID, &m.SenderID, &m.RecipientID, &m.Text, &m.IsRead, &m.CreatedAt); err != nil {
			continue
		}
		messages = append(messages, m)
	}

	c.JSON(http.StatusOK, messages)
}

func (h *ChatHandler) MarkMessagesRead(c *gin.Context) {
	userID := c.GetString("user_id")
	petID := c.Param("petID")

	otherUserID := c.Query("other_user_id")
	if otherUserID == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "other_user_id обязателен"})
		return
	}

	_, err := h.pool.Exec(c.Request.Context(),
		`UPDATE messages SET is_read = true
		 WHERE pet_id = $1 AND recipient_id = $2 AND sender_id = $3 AND NOT is_read`,
		petID, userID, otherUserID,
	)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка сервера"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"ok": true})
}

type SendMessageRequest struct {
	RecipientID string  `json:"recipient_id" binding:"required"`
	Text        string  `json:"text" binding:"required"`
	SightingID  *string `json:"sighting_id"`
}

func (h *ChatHandler) SendMessage(c *gin.Context) {
	userID := c.GetString("user_id")
	petID := c.Param("petID")

	var req SendMessageRequest
	if err := c.BindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Неверный формат данных"})
		return
	}

	messageID := uuid.New().String()
	now := time.Now()

	_, err := h.pool.Exec(c.Request.Context(),
		`INSERT INTO messages (id, pet_id, sighting_id, sender_id, recipient_id, text, is_read, created_at)
		 VALUES ($1, $2, $3, $4, $5, $6, $7, $8)`,
		messageID, petID, req.SightingID, userID, req.RecipientID, req.Text, false, now,
	)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка при отправке сообщения"})
		return
	}

	notif := h.notif
	petIDCopy := petID
	textCopy := req.Text
	go func() {
		_ = notif.Create(context.Background(), req.RecipientID, "message", petIDCopy, "Новое сообщение", textCopy)
	}()

	c.JSON(http.StatusCreated, gin.H{"id": messageID, "createdAt": now})
}

var upgrader = websocket.Upgrader{
	ReadBufferSize:  1024,
	WriteBufferSize: 1024,
	CheckOrigin:     func(r *http.Request) bool { return true },
}

type wsMessage struct {
	Type      string    `json:"type"`
	Text      string    `json:"text,omitempty"`
	SenderID  string    `json:"sender_id,omitempty"`
	Timestamp time.Time `json:"timestamp,omitempty"`
}

func (h *ChatHandler) WebSocket(c *gin.Context) {
	ws, err := upgrader.Upgrade(c.Writer, c.Request, nil)
	if err != nil {
		return
	}
	defer ws.Close()

	for {
		var msg wsMessage
		if err := ws.ReadJSON(&msg); err != nil {
			break
		}
		_ = msg
	}
}
