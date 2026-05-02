package service

import (
	"context"
	"fmt"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/lapki/backend/internal/model"
	"github.com/lapki/backend/internal/repository"
)

type PetService struct {
	pets  repository.PetRepo
	notif repository.NotificationRepo
	subs  repository.SubscriptionRepo
}

func NewPetService(pets repository.PetRepo, notif repository.NotificationRepo, subs repository.SubscriptionRepo) *PetService {
	return &PetService{pets: pets, notif: notif, subs: subs}
}

func (s *PetService) ListPets(ctx context.Context, req model.ListPetsRequest) ([]model.Pet, error) {
	pets, err := s.pets.ListInRadius(ctx, req.Latitude, req.Longitude, req.Radius, req.SearchText)
	if err != nil {
		return nil, err
	}

	if req.PetType != "" {
		filtered := pets[:0]
		for _, p := range pets {
			if p.Type == req.PetType {
				filtered = append(filtered, p)
			}
		}
		pets = filtered
	}

	if req.LostFrom != "" {
		if from, err := time.Parse("2006-01-02", req.LostFrom); err == nil {
			filtered := pets[:0]
			for _, p := range pets {
				if p.LostDate != nil && !p.LostDate.Before(from) {
					filtered = append(filtered, p)
				}
			}
			pets = filtered
		}
	}

	if req.LostTo != "" {
		if to, err := time.Parse("2006-01-02", req.LostTo); err == nil {
			to = to.Add(24*time.Hour - time.Second)
			filtered := pets[:0]
			for _, p := range pets {
				if p.LostDate != nil && !p.LostDate.After(to) {
					filtered = append(filtered, p)
				}
			}
			pets = filtered
		}
	}

	if req.Breed != "" {
		filtered := pets[:0]
		for _, p := range pets {
			if p.Breed == req.Breed {
				filtered = append(filtered, p)
			}
		}
		pets = filtered
	}

	return pets, nil
}

func (s *PetService) GetPet(ctx context.Context, id string) (*model.Pet, error) {
	return s.pets.GetByID(ctx, id)
}

func (s *PetService) CreatePet(ctx context.Context, userID string, req model.CreatePetRequest) (string, error) {
	return s.pets.Create(ctx, userID, req)
}

func (s *PetService) UpdatePet(ctx context.Context, petID, userID string, params repository.PetUpdateParams) error {
	ownerID, err := s.pets.GetOwnerID(ctx, petID)
	if err == pgx.ErrNoRows {
		return ErrNotFound
	}
	if err != nil {
		return err
	}
	if ownerID != userID {
		return ErrForbidden
	}

	if err := s.pets.Update(ctx, petID, params); err != nil {
		return err
	}

	go func() {
		subscribers, err := s.subs.ListSubscribers(context.Background(), petID)
		if err != nil {
			return
		}
		for _, subscriberID := range subscribers {
			if subscriberID == userID {
				continue
			}
			_ = s.notif.Create(context.Background(), subscriberID, "update", petID, nil,
				fmt.Sprintf("Обновлена анкета: %s", params.Name),
				"Владелец обновил информацию о питомце",
			)
		}
	}()

	return nil
}

func (s *PetService) PatchPetStatus(ctx context.Context, petID, userID, status string) error {
	ownerID, err := s.pets.GetOwnerID(ctx, petID)
	if err == pgx.ErrNoRows {
		return ErrNotFound
	}
	if err != nil {
		return err
	}
	if ownerID != userID {
		return ErrForbidden
	}
	return s.pets.PatchStatus(ctx, petID, status)
}

func (s *PetService) DeletePet(ctx context.Context, petID, userID string) error {
	ownerID, err := s.pets.GetOwnerID(ctx, petID)
	if err == pgx.ErrNoRows {
		return ErrNotFound
	}
	if err != nil {
		return err
	}
	if ownerID != userID {
		return ErrForbidden
	}
	return s.pets.Delete(ctx, petID)
}

func (s *PetService) AddSighting(ctx context.Context, petID, userID string, p repository.SightingParams) (string, error) {
	sightingID, ownerID, petName, err := s.pets.AddSighting(ctx, petID, userID, p)
	if err != nil {
		return "", err
	}

	if ownerID != "" && ownerID != userID {
		address := p.Address
		sid := sightingID
		go func() {
			_ = s.notif.Create(context.Background(), ownerID, "sighting", petID, &sid,
				fmt.Sprintf("Возможно видели %s", petName),
				address,
			)
		}()
	}

	return sightingID, nil
}

func (s *PetService) PatchSightingStatus(ctx context.Context, petID, sightingID, userID, status string) error {
	if status != "confirmed" && status != "rejected" && status != "pending" {
		return fmt.Errorf("invalid status: %s", status)
	}
	ownerID, err := s.pets.GetOwnerID(ctx, petID)
	if err == pgx.ErrNoRows {
		return ErrNotFound
	}
	if err != nil {
		return err
	}
	if ownerID != userID {
		return ErrForbidden
	}
	if err := s.pets.PatchSightingStatus(ctx, sightingID, status); err != nil {
		return err
	}

	if status == "confirmed" {
		go func() {
			pet, err := s.pets.GetByID(context.Background(), petID)
			if err != nil || pet == nil {
				return
			}
			subscribers, err := s.subs.ListSubscribers(context.Background(), petID)
			if err != nil {
				return
			}
			for _, subscriberID := range subscribers {
				if subscriberID == ownerID {
					continue
				}
				sid := sightingID
				_ = s.notif.Create(context.Background(), subscriberID, "sighting", petID, &sid,
					fmt.Sprintf("Новое наблюдение: %s", pet.Name),
					"Владелец подтвердил место, где видели питомца",
				)
			}
		}()
	}

	return nil
}

func (s *PetService) GetSightings(ctx context.Context, petID string) ([]model.Sighting, error) {
	return s.pets.GetSightings(ctx, petID)
}

func (s *PetService) ListMyPets(ctx context.Context, userID string) ([]model.Pet, error) {
	return s.pets.ListByOwner(ctx, userID)
}
