package config

import (
	"log"
	"os"
)

type Config struct {
	DatabaseURL    string
	JWTSecret      string
	Port           string
	YandexClientID string
	YandexSecret   string
	BaseURL        string
	S3KeyID        string
	S3SecretKey    string
	S3Bucket       string
}

func mustEnv(key string) string {
	value := os.Getenv(key)
	if value == "" {
		log.Fatalf("required environment variable %s is not set", key)
	}
	return value
}

func getEnv(key, defaultValue string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return defaultValue
}

func LoadConfig() *Config {
	return &Config{
		DatabaseURL:    mustEnv("DATABASE_URL"),
		JWTSecret:      mustEnv("JWT_SECRET"),
		Port:           getEnv("PORT", "8080"),
		YandexClientID: getEnv("YANDEX_CLIENT_ID", ""),
		YandexSecret:   getEnv("YANDEX_SECRET", ""),
		BaseURL:        getEnv("BASE_URL", "http://localhost:8080"),
		S3KeyID:        getEnv("S3_KEY_ID", ""),
		S3SecretKey:    getEnv("S3_SECRET_KEY", ""),
		S3Bucket:       getEnv("S3_BUCKET", "lapki-photos"),
	}
}
