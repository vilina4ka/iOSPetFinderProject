package handler

import (
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"net/url"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/lapki/backend/internal/config"
	"github.com/lapki/backend/internal/model"
)

type AuthHandler struct {
	pool *pgxpool.Pool
	cfg  *config.Config
}

type yandexTokenResponse struct {
	AccessToken string `json:"access_token"`
	TokenType   string `json:"token_type"`
	ExpiresIn   int    `json:"expires_in"`
}

type yandexUserInfo struct {
	ID           string           `json:"id"`
	Login        string           `json:"login"`
	Email        string           `json:"default_email"`
	FullName     string           `json:"real_name"`
	AvatarID     string           `json:"default_avatar_id"`
	DefaultPhone *yandexPhoneInfo `json:"default_phone"`
}

type yandexPhoneInfo struct {
	Number string `json:"number"`
}

func NewAuthHandler(pool *pgxpool.Pool, cfg *config.Config) *AuthHandler {
	return &AuthHandler{pool: pool, cfg: cfg}
}

type LoginRequest struct {
	Code string `json:"code" binding:"required"`
}

type LoginResponse struct {
	Token string      `json:"token"`
	User  *model.User `json:"user"`
}

func (h *AuthHandler) YandexCallback(c *gin.Context) {
	code := c.Query("code")
	if code == "" {
		c.Data(http.StatusBadRequest, "text/html; charset=utf-8",
			[]byte(`<html><body><p>Ошибка авторизации. Закройте окно и попробуйте снова.</p></body></html>`))
		return
	}
	c.Redirect(http.StatusFound, "lapki://auth?code="+code)
}

func (h *AuthHandler) YandexLogin(c *gin.Context) {
	var req LoginRequest
	if err := c.BindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Неверный формат запроса"})
		return
	}

	accessToken, err := h.exchangeYandexCode(req.Code)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Ошибка аутентификации"})
		return
	}

	userInfo, err := h.getYandexUserInfo(accessToken)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Ошибка получения данных пользователя"})
		return
	}

	user, err := h.upsertUser(c.Request.Context(), userInfo)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка сервера"})
		return
	}

	jwtToken, err := h.generateToken(user.ID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка генерации токена"})
		return
	}

	c.JSON(http.StatusOK, LoginResponse{Token: jwtToken, User: user})
}

func (h *AuthHandler) Me(c *gin.Context) {
	userID := c.GetString("user_id")
	if userID == "" {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Не авторизован"})
		return
	}

	var user model.User
	err := h.pool.QueryRow(c.Request.Context(),
		"SELECT id, yandex_id, name, email, avatar_url, phone, created_at FROM users WHERE id = $1",
		userID,
	).Scan(&user.ID, &user.YandexID, &user.Name, &user.Email, &user.AvatarURL, &user.Phone, &user.CreatedAt)

	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Пользователь не найден"})
		return
	}

	c.JSON(http.StatusOK, user)
}

func (h *AuthHandler) exchangeYandexCode(code string) (string, error) {
	params := url.Values{}
	params.Set("grant_type", "authorization_code")
	params.Set("code", code)
	params.Set("client_id", h.cfg.YandexClientID)
	params.Set("client_secret", h.cfg.YandexSecret)

	resp, err := http.Post(
		"https://oauth.yandex.ru/token",
		"application/x-www-form-urlencoded",
		strings.NewReader(params.Encode()),
	)
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		body, _ := io.ReadAll(resp.Body)
		return "", fmt.Errorf("yandex oauth error %d: %s", resp.StatusCode, string(body))
	}

	var tokenResp yandexTokenResponse
	if err := json.NewDecoder(resp.Body).Decode(&tokenResp); err != nil {
		return "", err
	}
	if tokenResp.AccessToken == "" {
		return "", fmt.Errorf("empty access_token")
	}
	return tokenResp.AccessToken, nil
}

func (h *AuthHandler) getYandexUserInfo(accessToken string) (*yandexUserInfo, error) {
	req, _ := http.NewRequest("GET", "https://login.yandex.ru/info", nil)
	req.Header.Add("Authorization", "OAuth "+accessToken)
	req.Header.Add("Accept", "application/json")

	resp, err := (&http.Client{}).Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("yandex userinfo error: %d", resp.StatusCode)
	}

	var userInfo yandexUserInfo
	if err := json.NewDecoder(resp.Body).Decode(&userInfo); err != nil {
		return nil, err
	}
	return &userInfo, nil
}

func (h *AuthHandler) upsertUser(ctx context.Context, userInfo *yandexUserInfo) (*model.User, error) {
	userID := uuid.New().String()

	avatarURL := ""
	if userInfo.AvatarID != "" {
		avatarURL = "https://avatars.yandex.net/get-yapic/" + userInfo.AvatarID + "/islands-200"
	}

	phone := ""
	if userInfo.DefaultPhone != nil {
		phone = userInfo.DefaultPhone.Number
	}

	user := &model.User{
		ID:       userID,
		YandexID: userInfo.ID,
		Name:     userInfo.FullName,
		Email:    &userInfo.Email,
		Phone:    &phone,
	}

	err := h.pool.QueryRow(ctx,
		`INSERT INTO users (id, yandex_id, name, email, avatar_url, phone, created_at)
		 VALUES ($1, $2, $3, $4, $5, $6, $7)
		 ON CONFLICT (yandex_id) DO UPDATE
		 SET name = $3, email = $4, avatar_url = $5, phone = $6
		 RETURNING id, yandex_id, name, email, avatar_url, phone, created_at`,
		userID, userInfo.ID, userInfo.FullName, userInfo.Email, avatarURL, phone, time.Now(),
	).Scan(&user.ID, &user.YandexID, &user.Name, &user.Email, &user.AvatarURL, &user.Phone, &user.CreatedAt)

	if err != nil {
		return nil, err
	}
	return user, nil
}

func (h *AuthHandler) DevLogin(c *gin.Context) {
	devUserID := "00000000-0000-0000-0000-000000000001"
	devEmail := "test@lapki.dev"
	devUser := &model.User{
		ID:    devUserID,
		Name:  "Тест Пользователь",
		Email: &devEmail,
	}

	_, err := h.pool.Exec(c.Request.Context(),
		`INSERT INTO users (id, yandex_id, name, email, created_at)
		 VALUES ($1, $2, $3, $4, NOW())
		 ON CONFLICT (yandex_id) DO UPDATE SET name = $3`,
		devUserID, "dev-yandex-id-001", devUser.Name, devUser.Email,
	)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка сервера"})
		return
	}

	token, err := h.generateToken(devUserID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка токена"})
		return
	}

	c.JSON(http.StatusOK, LoginResponse{Token: token, User: devUser})
}

func (h *AuthHandler) generateToken(userID string) (string, error) {
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"user_id": userID,
		"exp":     time.Now().Add(time.Hour * 24 * 30).Unix(),
	})
	return token.SignedString([]byte(h.cfg.JWTSecret))
}
