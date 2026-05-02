package handler

import (
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/lapki/backend/internal/service"
)

const logoBase64 = "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"

type WebHandler struct {
	service *service.PetService
}

func NewWebHandler(svc *service.PetService) *WebHandler {
	return &WebHandler{service: svc}
}

func (h *WebHandler) PetPage(c *gin.Context) {
	pet, err := h.service.GetPet(c.Request.Context(), c.Param("id"))
	if err != nil || pet == nil {
		c.Data(http.StatusNotFound, "text/html; charset=utf-8", []byte(notFoundPage()))
		return
	}

	lostDate := ""
	if pet.LostDate != nil {
		lostDate = pet.LostDate.Format("02.01.2006")
	}

	photoHTML := ""
	if len(pet.ImageURLs) > 0 {
		photoHTML = fmt.Sprintf(`<img src="%s" alt="Фото питомца">`, pet.ImageURLs[0])
	} else {
		photoHTML = `<div class="no-photo">🐾</div>`
	}

	statusLabel := "Ищем"
	statusClass := "status-lost"
	if pet.Status == "found" {
		statusLabel = "Найден"
		statusClass = "status-found"
	}

	extraRows := ""
	if pet.Breed != "" {
		extraRows += infoRow("Порода", pet.Breed)
	}
	if pet.Age != nil {
		extraRows += infoRow("Возраст", fmt.Sprintf("%d лет", *pet.Age))
	}
	if lostDate != "" {
		extraRows += infoRow("Пропал", lostDate)
	}
	if pet.Address != "" {
		extraRows += infoRow("Место", pet.Address)
	}
	if pet.ExternalSigns != "" {
		extraRows += infoRow("Внешние признаки", pet.ExternalSigns)
	}

	contactHTML := ""
	if pet.ContactPhone != nil && *pet.ContactPhone != "" {
		contactHTML = fmt.Sprintf(`<a class="contact-btn" href="tel:%s">%s</a>`, *pet.ContactPhone, *pet.ContactPhone)
	}

	descriptionHTML := ""
	if pet.Description != "" {
		descriptionHTML = fmt.Sprintf(`<div class="description">%s</div>`, pet.Description)
	}

	contactWrapHTML := ""
	if contactHTML != "" {
		contactWrapHTML = fmt.Sprintf(`<div class="contact-wrap">%s</div>`, contactHTML)
	}

	html := fmt.Sprintf(`<!DOCTYPE html>
<html lang="ru">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>%s — Лапки</title>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
           background: #f2f2f7; color: #1c1c1e; min-height: 100vh; }
    .header { background: #fff; padding: 16px 20px;
              display: flex; align-items: center; gap: 12px;
              border-bottom: 1px solid #e5e5ea; }
    .header-logo-img { width: 36px; height: 36px; object-fit: contain; }
    .header-title { font-size: 20px; font-weight: 700; color: #1c1c1e; }
    .card { background: #fff; border-radius: 16px; margin: 16px;
            overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
    .photo-wrap { width: 100%%; aspect-ratio: 1; overflow: hidden;
                  background: #f2f2f7; display: flex; align-items: center; justify-content: center; }
    .photo-wrap img { width: 100%%; height: 100%%; object-fit: cover; }
    .no-photo { font-size: 80px; }
    .info { padding: 16px; }
    .name-row { display: flex; align-items: center; justify-content: space-between; margin-bottom: 8px; }
    .name { font-size: 24px; font-weight: 700; }
    .status-lost  { background: #ff3b30; color: #fff; border-radius: 8px;
                    padding: 4px 10px; font-size: 13px; font-weight: 600; }
    .status-found { background: #34c759; color: #fff; border-radius: 8px;
                    padding: 4px 10px; font-size: 13px; font-weight: 600; }
    .description { font-size: 15px; line-height: 1.5; color: #3a3a3c; margin-bottom: 14px; }
    .rows { border-top: 1px solid #f2f2f7; }
    .row { display: flex; justify-content: space-between; padding: 10px 0;
           border-bottom: 1px solid #f2f2f7; font-size: 15px; }
    .row-label { color: #8e8e93; }
    .row-value { font-weight: 500; text-align: right; max-width: 60%%; }
    .contact-wrap { padding: 16px; }
    .contact-btn { display: block; background: #00ADFF; color: #fff; text-align: center;
                   padding: 14px; border-radius: 12px; font-size: 17px; font-weight: 600;
                   text-decoration: none; }
    .footer { text-align: center; color: #8e8e93; font-size: 13px; padding: 16px; }
  </style>
</head>
<body>
  <div class="header">
    <img class="header-logo-img" src="data:image/png;base64,%s" alt="Лапки">
    <span class="header-title">Лапки</span>
  </div>
  <div class="card">
    <div class="photo-wrap">%s</div>
    <div class="info">
      <div class="name-row">
        <span class="name">%s</span>
        <span class="%s">%s</span>
      </div>
      %s
      <div class="rows">%s</div>
    </div>
    %s
  </div>
  <div class="footer">Лапки — помогаем найти потерявшихся питомцев</div>
</body>
</html>`,
		pet.Name,
		logoBase64,
		photoHTML,
		pet.Name,
		statusClass, statusLabel,
		descriptionHTML,
		extraRows,
		contactWrapHTML,
	)

	c.Data(http.StatusOK, "text/html; charset=utf-8", []byte(html))
}

func infoRow(label, value string) string {
	return fmt.Sprintf(`<div class="row"><span class="row-label">%s</span><span class="row-value">%s</span></div>`, label, value)
}

func notFoundPage() string {
	return `<!DOCTYPE html><html lang="ru"><head><meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Не найдено — Лапки</title>
<style>body{font-family:-apple-system,sans-serif;display:flex;align-items:center;
justify-content:center;min-height:100vh;background:#f2f2f7;color:#1c1c1e;}
.wrap{text-align:center;}.emoji{font-size:64px;margin-bottom:16px;}
h1{font-size:22px;font-weight:700;margin-bottom:8px;}
p{color:#8e8e93;font-size:15px;}</style></head>
<body><div class="wrap"><div class="emoji">🐾</div>
<h1>Объявление не найдено</h1>
<p>Возможно, питомец уже найден или объявление удалено.</p>
</div></body></html>`
}
