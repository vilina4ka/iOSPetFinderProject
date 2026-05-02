//
//  ChatRepository.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 18.03.2026.
//

import Foundation

// MARK: - Protocol

protocol ChatRepositoryProtocol {
    func fetchThreads() async throws -> [ChatThread]
    func fetchMessages(petId: String, otherUserId: String, sightingId: String?, limit: Int, offset: Int) async throws -> [ChatMessage]
    func sendMessage(petId: String, recipientId: String, text: String, sightingId: String?, imageUrl: String?, fileName: String?) async throws -> String
    func deleteMessage(id: String) async throws
    func editMessage(id: String, text: String) async throws
    func markRead(petId: String, otherUserId: String) async throws
}

// MARK: - Response models

private struct CreateMessageResponse: Decodable {
    let id: String
}

// MARK: - APIClient Implementation

final class APIClientChatRepository: ChatRepositoryProtocol {

    private let api: APIClient

    init(api: APIClient = .shared) {
        self.api = api
    }

    func fetchThreads() async throws -> [ChatThread] {
        return try await api.request("GET", path: "/chats")
    }

    func fetchMessages(petId: String, otherUserId: String, sightingId: String?, limit: Int = 50, offset: Int = 0) async throws -> [ChatMessage] {
        var queryItems = [
            URLQueryItem(name: "other_user_id", value: otherUserId),
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "offset", value: "\(offset)")
        ]
        if let sid = sightingId {
            queryItems.append(URLQueryItem(name: "sighting_id", value: sid))
        }
        return try await api.request("GET", path: "/chats/\(petId)", queryItems: queryItems)
    }

    func sendMessage(petId: String, recipientId: String, text: String, sightingId: String?, imageUrl: String?, fileName: String?) async throws -> String {
        struct SendRequest: Encodable {
            let recipient_id: String
            let text: String
            let sighting_id: String?
            let image_url: String?
            let file_name: String?
        }
        let body = SendRequest(
            recipient_id: recipientId,
            text: text,
            sighting_id: sightingId,
            image_url: imageUrl,
            file_name: fileName
        )
        let response: CreateMessageResponse = try await api.request("POST", path: "/chats/\(petId)/message", body: body)
        return response.id
    }

    func deleteMessage(id: String) async throws {
        let _: EmptyResponse = try await api.request("DELETE", path: "/chats/message/\(id)")
    }

    func editMessage(id: String, text: String) async throws {
        struct EditRequest: Encodable { let text: String }
        let _: EmptyResponse = try await api.request("PATCH", path: "/chats/message/\(id)", body: EditRequest(text: text))
    }

    func markRead(petId: String, otherUserId: String) async throws {
        let _: EmptyResponse = try await api.request(
            "POST",
            path: "/chats/\(petId)/read",
            queryItems: [URLQueryItem(name: "other_user_id", value: otherUserId)]
        )
    }
}
