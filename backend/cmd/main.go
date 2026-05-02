package main

import (
	"log"

	"github.com/gin-gonic/gin"
	"github.com/lapki/backend/internal/config"
	"github.com/lapki/backend/internal/db"
	"github.com/lapki/backend/internal/handler"
	"github.com/lapki/backend/internal/middleware"
	"github.com/lapki/backend/internal/repository"
	"github.com/lapki/backend/internal/service"
	swaggerFiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"

	_ "github.com/lapki/backend/docs"
)

// @title           Lapki API
// @version         1.0
// @description     REST API приложения для поиска потерявшихся питомцев
// @host            178.154.198.101:8080
// @BasePath        /
// @schemes         http
// @securityDefinitions.apikey BearerAuth
// @in              header
// @name            Authorization
func main() {
	cfg := config.LoadConfig()

	pool, err := db.Connect(cfg.DatabaseURL)
	if err != nil {
		log.Fatalf("failed to connect to database: %v", err)
	}
	defer pool.Close()

	// Repositories
	petRepo := repository.NewPostgresPetRepo(pool)
	notifRepo := repository.NewPostgresNotificationRepo(pool)
	subsRepo := repository.NewPostgresSubscriptionRepo(pool)
	chatRepo := repository.NewPostgresChatRepo(pool)

	// Services
	petService := service.NewPetService(petRepo, notifRepo, subsRepo)
	chatService := service.NewChatService(chatRepo, notifRepo)

	// WebSocket hub
	hub := handler.NewHub()

	// Wire hub into chat service for real-time delivery.
	chatService.Notify = hub.Send

	// Handlers
	webHandler := handler.NewWebHandler(petService)
	authHandler := handler.NewAuthHandler(pool, cfg)
	petsHandler := handler.NewPetsHandler(petService)
	uploadHandler := handler.NewUploadHandler(cfg)
	chatHandler := handler.NewChatHandler(chatService, hub)
	notificationsHandler := handler.NewNotificationsHandler(notifRepo, cfg)
	subscriptionsHandler := handler.NewSubscriptionsHandler(subsRepo, cfg)

	router := gin.Default()

	router.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerFiles.Handler))
	router.GET("/view/pets/:id", webHandler.PetPage)

	router.POST("/auth/yandex", authHandler.YandexLogin)
	router.GET("/auth/callback", authHandler.YandexCallback)

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
		authorized.GET("/ws", chatHandler.WebSocket)
		authorized.POST("/chats/:petID/message", chatHandler.SendMessage)
		authorized.DELETE("/chats/message/:messageID", chatHandler.DeleteMessage)
		authorized.PATCH("/chats/message/:messageID", chatHandler.EditMessage)

		authorized.GET("/notifications", notificationsHandler.ListNotifications)
		authorized.GET("/notifications/unread-count", notificationsHandler.UnreadCount)
		authorized.POST("/notifications/:id/read", notificationsHandler.MarkRead)
		authorized.POST("/notifications/read-all", notificationsHandler.MarkAllRead)

		authorized.POST("/pets/:id/subscribe", subscriptionsHandler.Subscribe)
		authorized.DELETE("/pets/:id/subscribe", subscriptionsHandler.Unsubscribe)
		authorized.GET("/pets/:id/subscribed", subscriptionsHandler.IsSubscribed)
		authorized.GET("/subscriptions", subscriptionsHandler.ListSubscribed)

		authorized.GET("/me", authHandler.Me)
		authorized.GET("/users/:id", authHandler.GetUser)
	}

	if err := router.Run(":" + cfg.Port); err != nil {
		log.Fatalf("failed to start server: %v", err)
	}
}
