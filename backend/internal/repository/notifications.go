package repository

import (
	"context"
	"fmt"

	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/lapki/backend/internal/model"
)

type NotificationRepo interface {
	Create(ctx context.Context, userID, notifType, petID, title, body string) error
	ListByUser(ctx context.Context, userID string) ([]model.Notification, error)
	UnreadCount(ctx context.Context, userID string) (int, error)
	MarkRead(ctx context.Context, userID, notifID string) error
	MarkReadByPetAndType(ctx context.Context, userID, petID, notifType string) error
	MarkAllRead(ctx context.Context, userID string) error
}

type PostgresNotificationRepo struct {
	pool *pgxpool.Pool
}

func NewPostgresNotificationRepo(pool *pgxpool.Pool) *PostgresNotificationRepo {
	return &PostgresNotificationRepo{pool: pool}
}

func (r *PostgresNotificationRepo) Create(ctx context.Context, userID, notifType, petID, title, body string) error {
	_, err := r.pool.Exec(ctx,
		`INSERT INTO notifications (user_id, type, pet_id, title, body) VALUES ($1, $2, $3, $4, $5)`,
		userID, notifType, petID, title, body,
	)
	if err != nil {
		return fmt.Errorf("notifications create: %w", err)
	}
	return nil
}

func (r *PostgresNotificationRepo) ListByUser(ctx context.Context, userID string) ([]model.Notification, error) {
	rows, err := r.pool.Query(ctx,
		`SELECT id, user_id, type, pet_id, title, body, is_read, created_at
		 FROM notifications WHERE user_id = $1
		 ORDER BY created_at DESC LIMIT 50`,
		userID,
	)
	if err != nil {
		return nil, fmt.Errorf("notifications list: %w", err)
	}
	defer rows.Close()

	notifications := make([]model.Notification, 0)
	for rows.Next() {
		var n model.Notification
		if err := rows.Scan(&n.ID, &n.UserID, &n.Type, &n.PetID, &n.Title, &n.Body, &n.IsRead, &n.CreatedAt); err != nil {
			continue
		}
		notifications = append(notifications, n)
	}
	return notifications, nil
}

func (r *PostgresNotificationRepo) UnreadCount(ctx context.Context, userID string) (int, error) {
	var count int
	err := r.pool.QueryRow(ctx,
		`SELECT COUNT(*) FROM notifications WHERE user_id = $1 AND is_read = FALSE`,
		userID,
	).Scan(&count)
	if err != nil {
		return 0, fmt.Errorf("notifications unread count: %w", err)
	}
	return count, nil
}

func (r *PostgresNotificationRepo) MarkRead(ctx context.Context, userID, notifID string) error {
	_, err := r.pool.Exec(ctx,
		`UPDATE notifications SET is_read = TRUE WHERE id = $1 AND user_id = $2`,
		notifID, userID,
	)
	if err != nil {
		return fmt.Errorf("notifications mark read: %w", err)
	}
	return nil
}

func (r *PostgresNotificationRepo) MarkReadByPetAndType(ctx context.Context, userID, petID, notifType string) error {
	_, err := r.pool.Exec(ctx,
		`UPDATE notifications SET is_read = TRUE WHERE user_id = $1 AND pet_id = $2 AND type = $3 AND is_read = FALSE`,
		userID, petID, notifType,
	)
	if err != nil {
		return fmt.Errorf("notifications mark read by pet: %w", err)
	}
	return nil
}

func (r *PostgresNotificationRepo) MarkAllRead(ctx context.Context, userID string) error {
	_, err := r.pool.Exec(ctx,
		`UPDATE notifications SET is_read = TRUE WHERE user_id = $1 AND is_read = FALSE`,
		userID,
	)
	if err != nil {
		return fmt.Errorf("notifications mark read: %w", err)
	}
	return nil
}
