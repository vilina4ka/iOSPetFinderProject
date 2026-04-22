package model

import "time"

type User struct {
	ID        string    `json:"id"`
	YandexID  string    `json:"yandex_id"`
	Name      string    `json:"name"`
	Email     *string   `json:"email"`
	AvatarURL *string   `json:"avatar_url"`
	Phone     *string   `json:"phone"`
	CreatedAt time.Time `json:"created_at"`
}
