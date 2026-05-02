package model

import "time"

type Message struct {
	ID          string    `json:"id"`
	PetID       string    `json:"pet_id"`
	SightingID  *string   `json:"sighting_id"`
	SenderID    string    `json:"sender_id"`
	RecipientID string    `json:"recipient_id"`
	Text        string    `json:"text"`
	IsRead      bool      `json:"is_read"`
	CreatedAt   time.Time `json:"created_at"`
	ImageURL    *string   `json:"image_url"`
	FileName    *string   `json:"file_name"`
}

type ChatThread struct {
	PetID           string    `json:"pet_id"`
	SightingID      *string   `json:"sighting_id"`
	PetName         string    `json:"pet_name"`
	PetImageURL     string    `json:"pet_image_url"`
	OtherUserID     string    `json:"other_user_id"`
	OtherUserName   string    `json:"other_user_name"`
	OtherUserAvatar string    `json:"other_user_avatar"`
	LastMessage     string    `json:"last_message"`
	LastMessageAt   time.Time `json:"last_message_at"`
	UnreadCount     int       `json:"unread_count"`
}
