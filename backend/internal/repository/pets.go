package repository

import (
	"context"
	"fmt"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/lapki/backend/internal/model"
)

type PetRepo interface {
	ListInRadius(ctx context.Context, lat, lon, radius float64, search string) ([]model.Pet, error)
	GetByID(ctx context.Context, id string) (*model.Pet, error)
	GetOwnerID(ctx context.Context, petID string) (string, error)
	Create(ctx context.Context, ownerID string, req model.CreatePetRequest) (string, error)
	Update(ctx context.Context, id string, p PetUpdateParams) error
	PatchStatus(ctx context.Context, id, status string) error
	Delete(ctx context.Context, id string) error
	AddSighting(ctx context.Context, petID, reporterID string, p SightingParams) (sightingID, ownerID, petName string, err error)
	GetSightings(ctx context.Context, petID string) ([]model.Sighting, error)
	PatchSightingStatus(ctx context.Context, sightingID, status string) error
	ListBySubscriber(ctx context.Context, userID string) ([]model.Pet, error)
	ListByOwner(ctx context.Context, ownerID string) ([]model.Pet, error)
}

type PetUpdateParams struct {
	Name          string
	Type          string
	Breed         string
	Age           *int
	Description   string
	ExternalSigns string
	ContactPhone  string
	ContactName   string
	ImageURLs     []string
	Address       string
	Latitude      *float64
	Longitude     *float64
	LostDate      *time.Time
}

type SightingParams struct {
	Latitude  float64
	Longitude float64
	Address   string
	Comment   string
	ImageURLs []string
}

type PostgresPetRepo struct {
	pool *pgxpool.Pool
}

func NewPostgresPetRepo(pool *pgxpool.Pool) *PostgresPetRepo {
	return &PostgresPetRepo{pool: pool}
}

func scanPetRow(scan func(dest ...any) error) (model.Pet, error) {
	var p model.Pet
	var imageURLs []string
	err := scan(
		&p.ID, &p.OwnerID, &p.Name, &p.Type, &p.Breed, &p.Age, &p.LostDate, &p.Description,
		&p.ExternalSigns, &p.ContactPhone, &p.ContactName, &imageURLs,
		&p.Latitude, &p.Longitude, &p.Address, &p.Status, &p.CreatedAt, &p.UpdatedAt,
	)
	if err != nil {
		return model.Pet{}, err
	}
	p.ImageURLs = imageURLs
	return p, nil
}

func (r *PostgresPetRepo) ListInRadius(ctx context.Context, lat, lon, radius float64, search string) ([]model.Pet, error) {
	rows, err := r.pool.Query(ctx,
		`SELECT id, owner_id, name, type, breed, age, lost_date, description, external_signs,
		        contact_phone, contact_name, image_urls, latitude, longitude, address, status, created_at, updated_at
		 FROM pets_in_radius($1, $2, $3, $4)`,
		lat, lon, radius, search,
	)
	if err != nil {
		return nil, fmt.Errorf("pets list query: %w", err)
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

func (r *PostgresPetRepo) GetByID(ctx context.Context, id string) (*model.Pet, error) {
	p, err := scanPetRow(r.pool.QueryRow(ctx,
		`SELECT id, owner_id, name, type, breed, age, lost_date, description, external_signs,
		        contact_phone, contact_name, image_urls, latitude, longitude, address, status, created_at, updated_at
		 FROM pets WHERE id = $1`, id,
	).Scan)
	if err == pgx.ErrNoRows {
		return nil, nil
	}
	if err != nil {
		return nil, fmt.Errorf("pets get: %w", err)
	}
	return &p, nil
}

func (r *PostgresPetRepo) GetOwnerID(ctx context.Context, petID string) (string, error) {
	var ownerID string
	err := r.pool.QueryRow(ctx, "SELECT owner_id FROM pets WHERE id = $1", petID).Scan(&ownerID)
	if err == pgx.ErrNoRows {
		return "", pgx.ErrNoRows
	}
	return ownerID, err
}

func (r *PostgresPetRepo) Create(ctx context.Context, ownerID string, req model.CreatePetRequest) (string, error) {
	petID := uuid.New().String()
	now := time.Now()
	_, err := r.pool.Exec(ctx,
		`INSERT INTO pets (id, owner_id, name, type, breed, age, lost_date, description, external_signs,
		                   contact_phone, contact_name, image_urls, latitude, longitude, address, created_at, updated_at)
		 VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17)`,
		petID, ownerID, req.Name, req.Type, req.Breed, req.Age, req.LostDate, req.Description,
		req.ExternalSigns, req.ContactPhone, req.ContactName, req.ImageURLs,
		req.Latitude, req.Longitude, req.Address, now, now,
	)
	if err != nil {
		return "", fmt.Errorf("pets create: %w", err)
	}
	return petID, nil
}

func (r *PostgresPetRepo) Update(ctx context.Context, id string, p PetUpdateParams) error {
	_, err := r.pool.Exec(ctx,
		`UPDATE pets SET
			name           = $1,
			type           = $2,
			breed          = $3,
			age            = $4,
			description    = $5,
			external_signs = $6,
			contact_phone  = $7,
			contact_name   = $8,
			image_urls     = $9,
			address        = COALESCE(NULLIF($10, ''), address),
			latitude       = COALESCE($11, latitude),
			longitude      = COALESCE($12, longitude),
			lost_date      = COALESCE($13, lost_date),
			updated_at     = $14
		WHERE id = $15`,
		p.Name, p.Type, p.Breed, p.Age, p.Description, p.ExternalSigns,
		p.ContactPhone, p.ContactName, p.ImageURLs,
		p.Address, p.Latitude, p.Longitude, p.LostDate, time.Now(), id,
	)
	if err != nil {
		return fmt.Errorf("pets update: %w", err)
	}
	return nil
}

func (r *PostgresPetRepo) PatchStatus(ctx context.Context, id, status string) error {
	_, err := r.pool.Exec(ctx,
		"UPDATE pets SET status = $1, updated_at = $2 WHERE id = $3",
		status, time.Now(), id,
	)
	if err != nil {
		return fmt.Errorf("pets patch status: %w", err)
	}
	return nil
}

func (r *PostgresPetRepo) Delete(ctx context.Context, id string) error {
	_, err := r.pool.Exec(ctx, "DELETE FROM pets WHERE id = $1", id)
	if err != nil {
		return fmt.Errorf("pets delete: %w", err)
	}
	return nil
}

func (r *PostgresPetRepo) AddSighting(ctx context.Context, petID, reporterID string, p SightingParams) (string, string, string, error) {
	sightingID := uuid.New().String()

	var ownerID, petName string
	_ = r.pool.QueryRow(ctx, "SELECT owner_id, name FROM pets WHERE id = $1", petID).Scan(&ownerID, &petName)

	imageURLs := p.ImageURLs
	if imageURLs == nil {
		imageURLs = []string{}
	}

	_, err := r.pool.Exec(ctx,
		`INSERT INTO sightings (id, pet_id, reporter_id, latitude, longitude, address, comment, image_urls, created_at)
		 VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)`,
		sightingID, petID, reporterID, p.Latitude, p.Longitude, p.Address, p.Comment, imageURLs, time.Now(),
	)
	if err != nil {
		return "", "", "", fmt.Errorf("sightings add: %w", err)
	}
	return sightingID, ownerID, petName, nil
}

func (r *PostgresPetRepo) GetSightings(ctx context.Context, petID string) ([]model.Sighting, error) {
	rows, err := r.pool.Query(ctx,
		`SELECT s.id, s.pet_id, s.reporter_id, COALESCE(u.name, ''),
		        s.latitude, s.longitude, s.address, s.comment, s.image_urls,
		        COALESCE(s.status, 'pending'), s.created_at
		 FROM sightings s
		 LEFT JOIN users u ON u.id = s.reporter_id
		 WHERE s.pet_id = $1 ORDER BY s.created_at DESC`,
		petID,
	)
	if err != nil {
		return nil, fmt.Errorf("sightings list: %w", err)
	}
	defer rows.Close()

	sightings := make([]model.Sighting, 0)
	for rows.Next() {
		var s model.Sighting
		if err := rows.Scan(&s.ID, &s.PetID, &s.ReporterID, &s.ReporterName,
			&s.Latitude, &s.Longitude, &s.Address, &s.Comment, &s.ImageURLs,
			&s.Status, &s.CreatedAt); err != nil {
			continue
		}
		sightings = append(sightings, s)
	}
	return sightings, nil
}

func (r *PostgresPetRepo) PatchSightingStatus(ctx context.Context, sightingID, status string) error {
	_, err := r.pool.Exec(ctx,
		`UPDATE sightings SET status = $1 WHERE id = $2`,
		status, sightingID,
	)
	if err != nil {
		return fmt.Errorf("sightings patch status: %w", err)
	}
	return nil
}

func (r *PostgresPetRepo) ListByOwner(ctx context.Context, ownerID string) ([]model.Pet, error) {
	rows, err := r.pool.Query(ctx,
		`SELECT id, owner_id, name, type, breed, age, lost_date, description, external_signs,
		        contact_phone, contact_name, image_urls, latitude, longitude, address, status,
		        created_at, updated_at
		 FROM pets WHERE owner_id = $1 ORDER BY created_at DESC`,
		ownerID,
	)
	if err != nil {
		return nil, fmt.Errorf("pets by owner: %w", err)
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

func (r *PostgresPetRepo) ListBySubscriber(ctx context.Context, userID string) ([]model.Pet, error) {
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
