package service

import (
	"context"
	"encoding/json"
	"time"

	"github.com/lapki/backend/internal/model"
	"github.com/lapki/backend/internal/repository"
)

// ChatService contains the business logic for chat operations.
type ChatService struct {
	chat   repository.ChatRepo
	notif  repository.NotificationRepo
	// Notify is an optional callback to push a real-time message to a connected user.
	// Set this after construction (e.g. hub.Send).
	Notify func(userID string, msg []byte)
}

func NewChatService(chat repository.ChatRepo, notif repository.NotificationRepo) *ChatService {
	return &ChatService{chat: chat, notif: notif}
}

func (s *ChatService) ListThreads(ctx context.Context, userID string) ([]model.ChatThread, error) {
	return s.chat.ListThreads(ctx, userID)
}

func (s *ChatService) GetMessages(ctx context.Context, petID, userID, otherUserID, sightingID string, limit, offset int) ([]model.Message, error) {
	return s.chat.GetMessages(ctx, petID, userID, otherUserID, sightingID, limit, offset)
}

func (s *ChatService) SendMessage(ctx context.Context, petID string, sightingID *string, senderID, recipientID, text string, imageURL *string, fileName *string) (string, time.Time, error) {
	id, ts, err := s.chat.SendMessage(ctx, petID, sightingID, senderID, recipientID, text, imageURL, fileName)
	if err != nil {
		return "", time.Time{}, err
	}

	// Notify recipient asynchronously.
	petIDCopy := petID
	notifText := text
	if notifText == "" && imageURL != nil {
		if fileName != nil && *fileName != "" {
			notifText = "📎 " + *fileName
		} else {
			notifText = "📎 Фото"
		}
	}
	go func() {
		_ = s.notif.Create(context.Background(), recipientID, "message", petIDCopy, nil, "Новое сообщение", notifText)
	}()

	// Push real-time notification via WebSocket if recipient is connected.
	if s.Notify != nil {
		payload, _ := json.Marshal(map[string]any{
			"type":       "new_message",
			"id":         id,
			"pet_id":     petID,
			"sender_id":  senderID,
			"text":       text,
			"image_url":  imageURL,
			"file_name":  fileName,
			"sighting_id": sightingID,
			"created_at": ts,
		})
		go s.Notify(recipientID, payload)
	}

	return id, ts, nil
}

func (s *ChatService) DeleteMessage(ctx context.Context, messageID, senderID string) error {
	recipientID, petID, text, err := s.chat.DeleteMessage(ctx, messageID, senderID)
	if err != nil {
		return err
	}
	go func() {
		_ = s.notif.MarkMessageDeleted(context.Background(), recipientID, petID, text)
	}()
	return nil
}

func (s *ChatService) EditMessage(ctx context.Context, messageID, senderID, newText string) error {
	return s.chat.EditMessage(ctx, messageID, senderID, newText)
}

func (s *ChatService) MarkRead(ctx context.Context, petID, userID, otherUserID string) error {
	if err := s.chat.MarkRead(ctx, petID, userID, otherUserID); err != nil {
		return err
	}
	return s.notif.MarkReadByPetAndType(ctx, userID, petID, "message")
}
