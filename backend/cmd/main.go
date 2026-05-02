package main

import (
	"log"

	"github.com/gin-gonic/gin"
	"github.com/lapki/backend/internal/config"
	"github.com/lapki/backend/internal/db"
	"github.com/lapki/backend/internal/handler"
	"github.com/lapki/backend/internal/middleware"
	"github.com/lapki/backend/internal/repository"
)

func main() {
	cfg := config.LoadConfig()

	pool, err := db.Connect(cfg.DatabaseURL)
	if err != nil {
		log.Fatalf("failed to connect to database: %v", err)
	}
	defer pool.Close()

	petRepo := repository.NewPostgresPetRepo(pool)
	notifRepo := repository.NewPostgresNotificationRepo(pool)
	subsRepo := repository.NewPostgresSubscriptionRepo(pool)

	router := gin.Default()

	authHandler := handler.NewAuthHandler(pool, cfg)
	petsHandler := handler.NewPetsHandler(petRepo, notifRepo, subsRepo, cfg)
	uploadHandler := handler.NewUploadHandler(cfg)
	chatHandler := handler.NewChatHandler(pool, notifRepo, cfg)
	notificationsHandler := handler.NewNotificationsHandler(notifRepo, cfg)
	subscriptionsHandler := handler.NewSubscriptionsHandler(subsRepo, cfg)

	router.POST("/auth/yandex", authHandler.YandexLogin)
	router.GET("/auth/callback", authHandler.YandexCallback)
	router.POST("/auth/dev-login", authHandler.DevLogin)

	authorized := router.Group("/")
	authorized.Use(middleware.RequireAuth(cfg.JWTSecret))
	{
		authorized.GET("/pets", petsHandler.ListPets)
		authorized.GET("/me/pets", petsHandler.ListMyPets)
		authorized.POST("/pets", petsHandler.CreatePet)
		authorized.GET("/pets/:id", petsHandler.GetPet)
		authorized.PUT("/pets/:id", petsHandler.UpdatePet)
		authorized.PATCH("/pets/:id/status", petsHandler.PatchPetStatus)
		authorized.DELETE("/pets/:id", petsHandler.DeletePet)

		authorized.POST("/pets/:id/sightings", petsHandler.AddSighting)
		authorized.GET("/pets/:id/sightings", petsHandler.GetSightings)
		authorized.PATCH("/pets/:id/sightings/:sightingId/status", petsHandler.PatchSightingStatus)

		authorized.POST("/upload", uploadHandler.UploadImage)

		authorized.GET("/chats", chatHandler.ListChats)
		authorized.GET("/chats/:petID", chatHandler.GetMessages)
		authorized.POST("/chats/:petID/read", chatHandler.MarkMessagesRead)
		authorized.GET("/ws/chats/:petID", chatHandler.WebSocket)
		authorized.POST("/chats/:petID/message", chatHandler.SendMessage)

		authorized.GET("/notifications", notificationsHandler.ListNotifications)
		authorized.GET("/notifications/unread-count", notificationsHandler.UnreadCount)
		authorized.POST("/notifications/:id/read", notificationsHandler.MarkRead)
		authorized.POST("/notifications/read-all", notificationsHandler.MarkAllRead)

		authorized.POST("/pets/:id/subscribe", subscriptionsHandler.Subscribe)
		authorized.DELETE("/pets/:id/subscribe", subscriptionsHandler.Unsubscribe)
		authorized.GET("/pets/:id/subscribed", subscriptionsHandler.IsSubscribed)
		authorized.GET("/subscriptions", subscriptionsHandler.ListSubscribed)

		authorized.GET("/me", authHandler.Me)
	}

	if err := router.Run(":" + cfg.Port); err != nil {
		log.Fatalf("failed to start server: %v", err)
	}
}
