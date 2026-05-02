//
//  WebSocketService.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 30.04.2026.
//

import Foundation

// MARK: - Incoming message from WebSocket

struct WSIncomingMessage: Decodable {
    let type: String
    let id: String?
    let petId: String?
    let senderId: String?
    let recipientId: String?
    let text: String?
    let imageUrl: String?
    let fileName: String?
    let sightingId: String?
    let createdAt: Date?

    enum CodingKeys: String, CodingKey {
        case type
        case id
        case petId       = "pet_id"
        case senderId    = "sender_id"
        case recipientId = "recipient_id"
        case text
        case imageUrl    = "image_url"
        case fileName    = "file_name"
        case sightingId  = "sighting_id"
        case createdAt   = "created_at"
    }
}

// MARK: - WebSocketService

final class WebSocketService: NSObject {

    static let shared = WebSocketService()

    /// Called on main thread when a new_message event arrives.
    var onMessage: ((WSIncomingMessage) -> Void)?

    private var task: URLSessionWebSocketTask?
    private var urlSession: URLSession?
    private var isConnected = false

    private let wsURL = "ws://178.154.198.101:8080/ws"

    private override init() { super.init() }

    // MARK: - Public API

    func connect() {
        guard !isConnected else { return }
        guard let token = APIClient.shared.authToken,
              let url = URL(string: wsURL) else { return }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        task = urlSession?.webSocketTask(with: request)
        task?.resume()
        isConnected = true
        receiveNext()
    }

    func disconnect() {
        task?.cancel(with: .normalClosure, reason: nil)
        task = nil
        urlSession = nil
        isConnected = false
    }

    // MARK: - Private

    private func receiveNext() {
        task?.receive { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let message):
                self.handle(message)
                self.receiveNext()
            case .failure:
                self.isConnected = false
            }
        }
    }

    private func handle(_ message: URLSessionWebSocketTask.Message) {
        var data: Data?
        switch message {
        case .string(let text):
            data = text.data(using: .utf8)
        case .data(let d):
            data = d
        @unknown default:
            return
        }
        guard let data else { return }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        guard let incoming = try? decoder.decode(WSIncomingMessage.self, from: data),
              incoming.type == "new_message" else { return }

        DispatchQueue.main.async {
            self.onMessage?(incoming)
        }
    }
}

// MARK: - URLSessionWebSocketDelegate

extension WebSocketService: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession,
                    webSocketTask: URLSessionWebSocketTask,
                    didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
                    reason: Data?) {
        isConnected = false
    }
}
