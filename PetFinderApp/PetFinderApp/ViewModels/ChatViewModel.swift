//
//  ChatViewModel.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 18.03.2026.
//

import Foundation
import Combine

// MARK: - Models

struct ChatMessage: Codable, Identifiable {
    let id: String
    let petId: String
    let sightingId: String?
    let senderId: String
    let recipientId: String
    let text: String
    let isRead: Bool
    let createdAt: Date?
}

struct ChatThread: Codable, Identifiable {
    var id: String { petId + (sightingId ?? "") + otherUserId }
    let petId: String
    let sightingId: String?
    let petName: String
    let petImageUrl: String
    let otherUserId: String
    let otherUserName: String
    let otherUserAvatar: String
    let lastMessage: String
    let lastMessageAt: Date?
    let unreadCount: Int
}

struct SendMessageRequest: Encodable {
    let recipientId: String
    let text: String
    let sightingId: String?
}

struct CreateMessageResponse: Decodable {
    let id: String
}

// MARK: - ChatViewModel

@MainActor
final class ChatViewModel: ObservableObject {

    @Published private(set) var messages: [ChatMessage] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var isSending: Bool = false

    var currentUserId: String? {
        AuthManager.shared.currentUser?.id
    }

    private let pet: Pet
    private let recipientId: String
    private let sightingId: String?

    init(pet: Pet, recipientId: String, sightingId: String? = nil) {
        self.pet = pet
        self.recipientId = recipientId
        self.sightingId = sightingId
    }

    func loadMessages() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }

        var queryItems = [URLQueryItem(name: "other_user_id", value: recipientId)]
        if let sid = sightingId {
            queryItems.append(URLQueryItem(name: "sighting_id", value: sid))
        }

        do {
            let loaded: [ChatMessage] = try await APIClient.shared.request(
                "GET",
                path: "/chats/\(pet.id)",
                queryItems: queryItems
            )
            messages = loaded.reversed()
        } catch {
        }
    }

    func markMessagesRead() async {
        do {
            let _: EmptyResponse = try await APIClient.shared.request(
                "POST",
                path: "/chats/\(pet.id)/read",
                queryItems: [URLQueryItem(name: "other_user_id", value: recipientId)]
            )
        } catch {
        }
    }

    func sendMessage(_ text: String) async throws {
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        guard !isSending else { return }

        isSending = true
        defer { isSending = false }

        let request = SendMessageRequest(recipientId: recipientId, text: text, sightingId: sightingId)
        let _: CreateMessageResponse = try await APIClient.shared.request(
            "POST",
            path: "/chats/\(pet.id)/message",
            body: request
        )
        await loadMessages()
    }
}
