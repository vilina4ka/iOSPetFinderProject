package repository

import (
	"context"
	"fmt"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/lapki/backend/internal/model"
)

type SubscriptionRepo interface {
	Subscribe(ctx context.Context, userID, petID string) error
	Unsubscribe(ctx context.Context, userID, petID string) error
	IsSubscribed(ctx context.Context, userID, petID string) (bool, error)
	ListSubscribed(ctx context.Context, userID string) ([]model.Pet, error)
	ListSubscribers(ctx context.Context, petID string) ([]string, error)
}

type PostgresSubscriptionRepo struct {
	pool *pgxpool.Pool
}

func NewPostgresSubscriptionRepo(pool *pgxpool.Pool) *PostgresSubscriptionRepo {
	return &PostgresSubscriptionRepo{pool: pool}
}

func (r *PostgresSubscriptionRepo) Subscribe(ctx context.Context, userID, petID string) error {
	_, err := r.pool.Exec(ctx,
		`INSERT INTO subscriptions (user_id, pet_id, created_at) VALUES ($1, $2, $3) ON CONFLICT DO NOTHING`,
		userID, petID, time.Now(),
	)
	if err != nil {
		return fmt.Errorf("subscriptions subscribe: %w", err)
	}
	return nil
}

func (r *PostgresSubscriptionRepo) Unsubscribe(ctx context.Context, userID, petID string) error {
	_, err := r.pool.Exec(ctx,
		`DELETE FROM subscriptions WHERE user_id = $1 AND pet_id = $2`,
		userID, petID,
	)
	if err != nil {
		return fmt.Errorf("subscriptions unsubscribe: %w", err)
	}
	return nil
}

func (r *PostgresSubscriptionRepo) IsSubscribed(ctx context.Context, userID, petID string) (bool, error) {
	var count int
	err := r.pool.QueryRow(ctx,
		`SELECT COUNT(*) FROM subscriptions WHERE user_id = $1 AND pet_id = $2`,
		userID, petID,
	).Scan(&count)
	if err != nil {
		return false, fmt.Errorf("subscriptions is_subscribed: %w", err)
	}
	return count > 0, nil
}

func (r *PostgresSubscriptionRepo) ListSubscribers(ctx context.Context, petID string) ([]string, error) {
	rows, err := r.pool.Query(ctx, `SELECT user_id FROM subscriptions WHERE pet_id = $1`, petID)
	if err != nil {
		return nil, fmt.Errorf("subscriptions list subscribers: %w", err)
	}
	defer rows.Close()

	var userIDs []string
	for rows.Next() {
		var uid string
		if err := rows.Scan(&uid); err != nil {
			continue
		}
		userIDs = append(userIDs, uid)
	}
	return userIDs, nil
}

func (r *PostgresSubscriptionRepo) ListSubscribed(ctx context.Context, userID string) ([]model.Pet, error) {
	rows, err := r.pool.Query(ctx,
		`SELECT p.id, p.owner_id, p.name, p.type, p.breed, p.age, p.lost_date,
		        p.description, p.external_signs, p.contact_phone, p.contact_name,
		        p.image_urls, p.latitude, p.longitude, p.address, p.status,
		        p.created_at, p.updated_at
		 FROM pets p
		 JOIN subscriptions s ON s.pet_id = p.id
		 WHERE s.user_id = $1
		 ORDER BY s.created_at DESC`,
		userID,
	)
	if err != nil {
		return nil, fmt.Errorf("subscriptions list: %w", err)
	}
	defer rows.Close()

	pets := make([]model.Pet, 0)
	for rows.Next() {
		p, err := scanPetRow(rows.Scan)
		if err != nil {
			continue
		}
		pets = append(pets, p)
	}
	return pets, nil
}
