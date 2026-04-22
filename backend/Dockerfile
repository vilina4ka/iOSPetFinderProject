FROM golang:1.23-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -o bin/lapki ./cmd/main.go
FROM alpine:3.20
RUN apk add --no-cache ca-certificates postgresql-client

WORKDIR /app

COPY --from=builder /app/bin/lapki .
COPY migrations/ ./migrations/
COPY scripts/entrypoint.sh ./entrypoint.sh
RUN chmod +x entrypoint.sh
RUN mkdir -p uploads

EXPOSE 8080

ENTRYPOINT ["./entrypoint.sh"]
