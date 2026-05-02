package model

import (
	"time"
)

type Pet struct {
	ID            string     `json:"id"`
	OwnerID       string     `json:"owner_id"`
	Name          string     `json:"name"`
	Type          string     `json:"type"`
	Breed         string     `json:"breed"`
	Age           *int       `json:"age"`
	LostDate      *time.Time `json:"lost_date"`
	Description   string     `json:"description"`
	ExternalSigns string     `json:"external_signs"`
	ContactPhone  *string    `json:"contact_phone"`
	ContactName   *string    `json:"contact_name"`
	ImageURLs     []string   `json:"image_urls"`
	Latitude      *float64   `json:"latitude"`
	Longitude     *float64   `json:"longitude"`
	Address       string     `json:"address"`
	Status        string     `json:"status"`
	CreatedAt     time.Time  `json:"created_at"`
	UpdatedAt     time.Time  `json:"updated_at"`
}

type CreatePetRequest struct {
	Name          string    `json:"name" binding:"required"`
	Type          string    `json:"type" binding:"required"`
	Breed         string    `json:"breed"`
	Age           *int      `json:"age"`
	LostDate      time.Time `json:"lost_date" binding:"required"`
	Description   string    `json:"description"`
	ExternalSigns string    `json:"external_signs"`
	ContactPhone  string    `json:"contact_phone"`
	ContactName   string    `json:"contact_name"`
	ImageURLs     []string  `json:"image_urls"`
	Latitude      float64   `json:"latitude" binding:"required"`
	Longitude     float64   `json:"longitude" binding:"required"`
	Address       string    `json:"address" binding:"required"`
}

type ListPetsRequest struct {
	Latitude   float64 `form:"lat" binding:"required"`
	Longitude  float64 `form:"long" binding:"required"`
	Radius     float64 `form:"radius" binding:"required"`
	SearchText string  `form:"search"`
	PetType    string  `form:"type"`
	LostFrom   string  `form:"lost_from"`
	LostTo     string  `form:"lost_to"`
	Breed      string  `form:"breed"`
}

type Sighting struct {
	ID             string    `json:"id"`
	PetID          string    `json:"pet_id"`
	ReporterID     string    `json:"reporter_id"`
	ReporterName   string    `json:"reporter_name"`
	ReporterAvatar string    `json:"reporter_avatar"`
	Latitude       float64   `json:"latitude"`
	Longitude      float64   `json:"longitude"`
	Address        string    `json:"address"`
	Comment        string    `json:"comment"`
	ImageURLs      []string  `json:"image_urls"`
	Status         string    `json:"status"`
	CreatedAt      time.Time `json:"created_at"`
}
