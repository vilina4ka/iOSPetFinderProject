package repository

import (
	"context"
	"fmt"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/lapki/backend/internal/model"
)

// ChatRepo defines the data-access contract for messages and chat threads.
type ChatRepo interface {
	ListThreads(ctx context.Context, userID string) ([]model.ChatThread, error)
	GetMessages(ctx context.Context, petID, userID, otherUserID, sightingID string, limit, offset int) ([]model.Message, error)
	SendMessage(ctx context.Context, petID string, sightingID *string, senderID, recipientID, text string, imageURL *string, fileName *string) (id string, createdAt time.Time, err error)
	DeleteMessage(ctx context.Context, messageID, senderID string) (recipientID, petID, text string, err error)
	EditMessage(ctx context.Context, messageID, senderID, newText string) error
	MarkRead(ctx context.Context, petID, userID, otherUserID string) error
}

type PostgresChatRepo struct {
	pool *pgxpool.Pool
}

func NewPostgresChatRepo(pool *pgxpool.Pool) *PostgresChatRepo {
	return &PostgresChatRepo{pool: pool}
}

func (r *PostgresChatRepo) ListThreads(ctx context.Context, userID string) ([]model.ChatThread, error) {
	rows, err := r.pool.Query(ctx, `
		WITH ranked AS (
			SELECT
				m.*,
				ROW_NUMBER() OVER (
					PARTITION BY m.pet_id,
					             LEAST(m.sender_id, m.recipient_id), GREATEST(m.sender_id, m.recipient_id)
					ORDER BY m.created_at DESC
				) AS rn
			FROM messages m
			WHERE m.sender_id = $1 OR m.recipient_id = $1
		)
		SELECT
			r.pet_id,
			r.sighting_id,
			p.name AS pet_name,
			COALESCE(p.image_urls[1], '') AS pet_image_url,
			CASE WHEN r.sender_id = $1 THEN r.recipient_id ELSE r.sender_id END AS other_user_id,
			COALESCE(u.name, 'Аноним') AS other_user_name,
			COALESCE(u.avatar_url, '') AS other_user_avatar,
			CASE
				WHEN r.file_name IS NOT NULL THEN r.file_name
				WHEN r.image_url IS NOT NULL AND r.text = '' THEN 'Фото'
				ELSE r.text
			END AS last_message,
			r.created_at AS last_message_at,
			(
				SELECT COUNT(*) FROM messages m2
				WHERE m2.pet_id = r.pet_id
				  AND m2.recipient_id = $1
				  AND NOT m2.is_read
				  AND m2.sender_id = CASE WHEN r.sender_id = $1 THEN r.recipient_id ELSE r.sender_id END
			) AS unread_count
		FROM ranked r
		JOIN pets p ON p.id = r.pet_id
		JOIN users u ON u.id = CASE WHEN r.sender_id = $1 THEN r.recipient_id ELSE r.sender_id END
		WHERE r.rn = 1
		ORDER BY r.created_at DESC
	`, userID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	threads := make([]model.ChatThread, 0)
	for rows.Next() {
		var t model.ChatThread
		if err := rows.Scan(
			&t.PetID, &t.SightingID, &t.PetName, &t.PetImageURL,
			&t.OtherUserID, &t.OtherUserName, &t.OtherUserAvatar,
			&t.LastMessage, &t.LastMessageAt, &t.UnreadCount,
		); err != nil {
			continue
		}
		threads = append(threads, t)
	}
	return threads, nil
}

func (r *PostgresChatRepo) GetMessages(ctx context.Context, petID, userID, otherUserID, sightingID string, limit, offset int) ([]model.Message, error) {
	// sightingID is intentionally ignored here: all messages between two users
	// about the same pet belong to one chat regardless of which sighting prompted them.
	query := `SELECT id, pet_id, sighting_id, sender_id, recipient_id, text, is_read, created_at, image_url, file_name
			  FROM messages
			  WHERE pet_id = $1
			  AND ((sender_id = $2 AND recipient_id = $3) OR (sender_id = $3 AND recipient_id = $2))
			  ORDER BY created_at DESC LIMIT $4 OFFSET $5`
	args := []any{petID, userID, otherUserID, limit, offset}

	rows, err := r.pool.Query(ctx, query, args...)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var messages []model.Message
	for rows.Next() {
		var m model.Message
		if err := rows.Scan(&m.ID, &m.PetID, &m.SightingID, &m.SenderID, &m.RecipientID, &m.Text, &m.IsRead, &m.CreatedAt, &m.ImageURL, &m.FileName); err != nil {
			continue
		}
		messages = append(messages, m)
	}
	return messages, nil
}

func (r *PostgresChatRepo) SendMessage(ctx context.Context, petID string, sightingID *string, senderID, recipientID, text string, imageURL *string, fileName *string) (string, time.Time, error) {
	id := uuid.New().String()
	now := time.Now()
	_, err := r.pool.Exec(ctx,
		`INSERT INTO messages (id, pet_id, sighting_id, sender_id, recipient_id, text, is_read, created_at, image_url, file_name)
		 VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)`,
		id, petID, sightingID, senderID, recipientID, text, false, now, imageURL, fileName,
	)
	return id, now, err
}

func (r *PostgresChatRepo) DeleteMessage(ctx context.Context, messageID, senderID string) (recipientID, petID, text string, err error) {
	err = r.pool.QueryRow(ctx,
		`DELETE FROM messages WHERE id = $1 AND sender_id = $2
		 RETURNING recipient_id, pet_id::text, COALESCE(text, '')`,
		messageID, senderID,
	).Scan(&recipientID, &petID, &text)
	if err != nil {
		return "", "", "", fmt.Errorf("message not found or not owned by sender")
	}
	return recipientID, petID, text, nil
}

func (r *PostgresChatRepo) EditMessage(ctx context.Context, messageID, senderID, newText string) error {
	result, err := r.pool.Exec(ctx,
		`UPDATE messages SET text = $1 WHERE id = $2 AND sender_id = $3`,
		newText, messageID, senderID,
	)
	if err != nil {
		return err
	}
	if result.RowsAffected() == 0 {
		return fmt.Errorf("message not found or not owned by sender")
	}
	return nil
}

func (r *PostgresChatRepo) MarkRead(ctx context.Context, petID, userID, otherUserID string) error {
	_, err := r.pool.Exec(ctx,
		`UPDATE messages SET is_read = true
		 WHERE pet_id = $1 AND recipient_id = $2 AND sender_id = $3 AND NOT is_read`,
		petID, userID, otherUserID,
	)
	return err
}
