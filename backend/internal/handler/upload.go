package handler

import (
	"bytes"
	"context"
	"fmt"
	"net/http"
	"path/filepath"
	"strings"

	"github.com/aws/aws-sdk-go-v2/aws"
	awsconfig "github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/credentials"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/aws/aws-sdk-go-v2/service/s3/types"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	appconfig "github.com/lapki/backend/internal/config"
)

const s3Endpoint = "https://storage.yandexcloud.net"

type UploadHandler struct {
	cfg      *appconfig.Config
	s3Client *s3.Client
}

func NewUploadHandler(cfg *appconfig.Config) *UploadHandler {
	awsCfg, err := awsconfig.LoadDefaultConfig(context.Background(),
		awsconfig.WithRegion("ru-central1"),
		awsconfig.WithCredentialsProvider(credentials.NewStaticCredentialsProvider(
			cfg.S3KeyID, cfg.S3SecretKey, "",
		)),
	)
	if err != nil {
		panic(fmt.Sprintf("s3 config error: %v", err))
	}

	client := s3.NewFromConfig(awsCfg, func(o *s3.Options) {
		o.BaseEndpoint = aws.String(s3Endpoint)
		o.UsePathStyle = true
	})

	return &UploadHandler{cfg: cfg, s3Client: client}
}

func mimeTypeForExt(ext string) string {
	switch strings.ToLower(ext) {
	case ".jpg", ".jpeg":
		return "image/jpeg"
	case ".png":
		return "image/png"
	case ".gif":
		return "image/gif"
	case ".webp":
		return "image/webp"
	case ".pdf":
		return "application/pdf"
	case ".mp4":
		return "video/mp4"
	case ".mov":
		return "video/quicktime"
	case ".doc":
		return "application/msword"
	case ".docx":
		return "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
	case ".xls":
		return "application/vnd.ms-excel"
	case ".xlsx":
		return "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
	case ".zip":
		return "application/zip"
	case ".txt":
		return "text/plain"
	default:
		return "application/octet-stream"
	}
}

// @Summary     Загрузка фото
// @Description Загружает изображение в Yandex Object Storage, возвращает публичный URL
// @Tags        upload
// @Accept      multipart/form-data
// @Produce     json
// @Security    BearerAuth
// @Param       image formData file true "Файл изображения (макс 50 МБ)"
// @Success     200 {object} map[string]string
// @Failure     400 {object} map[string]string
// @Router      /upload [post]
func (h *UploadHandler) UploadImage(c *gin.Context) {
	file, err := c.FormFile("image")
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Не удалось получить файл"})
		return
	}

	if file.Size > 50*1024*1024 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Файл слишком большой (максимум 50 МБ)"})
		return
	}

	originalName := file.Filename
	ext := strings.ToLower(filepath.Ext(originalName))
	contentType := mimeTypeForExt(ext)

	src, err := file.Open()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка при обработке файла"})
		return
	}
	defer src.Close()

	buf := new(bytes.Buffer)
	if _, err = buf.ReadFrom(src); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка чтения файла"})
		return
	}

	key := uuid.New().String() + ext

	_, err = h.s3Client.PutObject(c.Request.Context(), &s3.PutObjectInput{
		Bucket:      aws.String(h.cfg.S3Bucket),
		Key:         aws.String(key),
		Body:        bytes.NewReader(buf.Bytes()),
		ContentType: aws.String(contentType),
		ACL:         types.ObjectCannedACLPublicRead,
	})
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка при загрузке файла"})
		return
	}

	fileURL := fmt.Sprintf("%s/%s/%s", s3Endpoint, h.cfg.S3Bucket, key)
	c.JSON(http.StatusOK, gin.H{
		"url":       fileURL,
		"file_name": originalName,
	})
}
