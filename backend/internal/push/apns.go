package push

import (
	"bytes"
	"crypto/ecdsa"
	"crypto/rand"
	"crypto/sha256"
	"crypto/x509"
	"encoding/base64"
	"encoding/json"
	"encoding/pem"
	"fmt"
	"io"
	"net/http"
	"sync"
	"time"
)

type Sender struct {
	keyID      string
	teamID     string
	bundleID   string
	privateKey *ecdsa.PrivateKey
	sandbox    bool

	mu        sync.Mutex
	jwtToken  string
	jwtIssued time.Time

	client *http.Client
}

type Notification struct {
	DeviceToken string
	Title       string
	Body        string
	PetID       string
	Type        string
}

func NewSender(keyPEM []byte, keyID, teamID, bundleID string, sandbox bool) (*Sender, error) {
	key, err := parseP8Key(keyPEM)
	if err != nil {
		return nil, fmt.Errorf("apns: parse key: %w", err)
	}
	return &Sender{
		keyID:      keyID,
		teamID:     teamID,
		bundleID:   bundleID,
		privateKey: key,
		sandbox:    sandbox,
		client:     &http.Client{Timeout: 10 * time.Second},
	}, nil
}

func parseP8Key(keyPEM []byte) (*ecdsa.PrivateKey, error) {
	block, _ := pem.Decode(keyPEM)
	if block == nil {
		return nil, fmt.Errorf("failed to decode PEM")
	}
	raw, err := x509.ParsePKCS8PrivateKey(block.Bytes)
	if err != nil {
		return nil, err
	}
	ecKey, ok := raw.(*ecdsa.PrivateKey)
	if !ok {
		return nil, fmt.Errorf("key is not EC")
	}
	return ecKey, nil
}

func (s *Sender) getJWT() (string, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	if s.jwtToken != "" && time.Since(s.jwtIssued) < 45*time.Minute {
		return s.jwtToken, nil
	}

	headerJSON, _ := json.Marshal(map[string]string{"alg": "ES256", "kid": s.keyID})
	claimsJSON, _ := json.Marshal(map[string]interface{}{
		"iss": s.teamID,
		"iat": time.Now().Unix(),
	})

	hdr := base64.RawURLEncoding.EncodeToString(headerJSON)
	cls := base64.RawURLEncoding.EncodeToString(claimsJSON)
	payload := hdr + "." + cls

	hash := sha256.Sum256([]byte(payload))
	r, ss, err := ecdsa.Sign(rand.Reader, s.privateKey, hash[:])
	if err != nil {
		return "", fmt.Errorf("sign: %w", err)
	}

	sig := make([]byte, 64)
	rb, sb := r.Bytes(), ss.Bytes()
	copy(sig[32-len(rb):32], rb)
	copy(sig[64-len(sb):64], sb)

	jwt := payload + "." + base64.RawURLEncoding.EncodeToString(sig)
	s.jwtToken = jwt
	s.jwtIssued = time.Now()
	return jwt, nil
}

func (s *Sender) Send(n Notification) error {
	jwt, err := s.getJWT()
	if err != nil {
		return err
	}

	type apnsAlert struct {
		Title string `json:"title"`
		Body  string `json:"body"`
	}
	type apnsAPS struct {
		Alert apnsAlert `json:"alert"`
		Sound string    `json:"sound"`
	}
	type apnsPayload struct {
		APS    apnsAPS `json:"aps"`
		PetID  string  `json:"pet_id,omitempty"`
		NType  string  `json:"type,omitempty"`
	}

	body, err := json.Marshal(apnsPayload{
		APS:   apnsAPS{Alert: apnsAlert{Title: n.Title, Body: n.Body}, Sound: "default"},
		PetID: n.PetID,
		NType: n.Type,
	})
	if err != nil {
		return err
	}

	host := "https://api.push.apple.com"
	if s.sandbox {
		host = "https://api.sandbox.push.apple.com"
	}

	req, err := http.NewRequest("POST",
		fmt.Sprintf("%s/3/device/%s", host, n.DeviceToken),
		bytes.NewReader(body),
	)
	if err != nil {
		return err
	}
	req.Header.Set("Authorization", "bearer "+jwt)
	req.Header.Set("apns-topic", s.bundleID)
	req.Header.Set("apns-push-type", "alert")
	req.Header.Set("apns-expiration", "0")
	req.Header.Set("apns-priority", "10")
	req.Header.Set("Content-Type", "application/json")

	resp, err := s.client.Do(req)
	if err != nil {
		return fmt.Errorf("apns http: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		rb, _ := io.ReadAll(resp.Body)
		return fmt.Errorf("apns %d: %s", resp.StatusCode, string(rb))
	}
	return nil
}
