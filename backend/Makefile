.PHONY: run build migrate help up down logs restart

help:
	@echo "run      - start server locally"
	@echo "build    - build binary"
	@echo "migrate  - apply migrations to local DB"
	@echo "up       - start DB + backend via Docker"
	@echo "down     - stop containers"
	@echo "logs     - tail backend logs"
	@echo "restart  - rebuild and restart backend"

run:
	go run ./cmd/main.go

build:
	CGO_ENABLED=0 go build -o bin/lapki ./cmd/main.go

migrate:
	@for f in migrations/*.sql; do \
		echo "applying $$f"; \
		psql $$DATABASE_URL -f $$f; \
	done

up:
	docker compose up -d --build

down:
	docker compose down

logs:
	docker compose logs -f backend

restart:
	docker compose up -d --build backend
