.PHONY: run build migrate help up down logs restart

help:
	@echo "Доступные команды:"
	@echo ""
	@echo "  Локальная разработка:"
	@echo "  make run       - Запустить сервер локально (нужна локальная БД)"
	@echo "  make build     - Собрать бинарник"
	@echo "  make migrate   - Применить миграции к локальной БД"
	@echo ""
	@echo "  Docker:"
	@echo "  make up        - Поднять всё (БД + бэкенд) через Docker"
	@echo "  make down      - Остановить контейнеры"
	@echo "  make logs      - Смотреть логи бэкенда"
	@echo "  make restart   - Пересобрать и перезапустить бэкенд"

# Локальная разработка

run:
	@echo "Запуск сервера..."
	go run ./cmd/main.go

build:
	@echo "Сборка бинарника..."
	CGO_ENABLED=0 go build -o bin/lapki ./cmd/main.go
	@echo "Бинарник собран: bin/lapki"

migrate:
	@echo "Применение миграций..."
	@for f in migrations/*.sql; do \
		echo "  → $$f"; \
		psql $$DATABASE_URL -f $$f; \
	done
	@echo "Миграции применены"

# Docker

up:
	@echo "Запуск через Docker Compose..."
	docker compose up -d --build
	@echo "Сервер запущен на http://localhost:8080"

down:
	@echo "Остановка контейнеров..."
	docker compose down

logs:
	docker compose logs -f backend

restart:
	@echo "Пересборка и перезапуск бэкенда..."
	docker compose up -d --build backend
