package handler

import (
	"sync"

	"github.com/gorilla/websocket"
)

type Client struct {
	userID string
	conn   *websocket.Conn
	send   chan []byte
}

type Hub struct {
	clients map[string]*Client
	mu      sync.RWMutex
}

func NewHub() *Hub {
	return &Hub{clients: make(map[string]*Client)}
}

func (h *Hub) Register(userID string, conn *websocket.Conn) *Client {
	client := &Client{
		userID: userID,
		conn:   conn,
		send:   make(chan []byte, 64),
	}
	h.mu.Lock()
	if old, ok := h.clients[userID]; ok {
		close(old.send)
	}
	h.clients[userID] = client
	h.mu.Unlock()
	return client
}

func (h *Hub) Unregister(userID string) {
	h.mu.Lock()
	if c, ok := h.clients[userID]; ok {
		delete(h.clients, userID)
		close(c.send)
	}
	h.mu.Unlock()
}

func (h *Hub) Send(userID string, msg []byte) {
	h.mu.RLock()
	client, ok := h.clients[userID]
	h.mu.RUnlock()
	if !ok {
		return
	}
	select {
	case client.send <- msg:
	default:
	}
}
