//
//  NotificationRepository.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 14.02.2026.
//

import Foundation

// MARK: - Protocol

protocol NotificationRepositoryProtocol {
    func fetchNotifications() async throws -> [AppNotification]
    func fetchUnreadCount() async throws -> Int
    func markAllRead() async throws
}

// MARK: - APIClient Implementation

final class APIClientNotificationRepository: NotificationRepositoryProtocol {

    private struct UnreadCountResponse: Decodable {
        let count: Int
    }

    private let api: APIClient

    init(api: APIClient = .shared) {
        self.api = api
    }

    func fetchNotifications() async throws -> [AppNotification] {
        return try await api.request("GET", path: "/notifications")
    }

    func fetchUnreadCount() async throws -> Int {
        let response: UnreadCountResponse = try await api.request(
            "GET", path: "/notifications/unread-count"
        )
        return response.count
    }

    func markAllRead() async throws {
        let _: EmptyResponse = try await api.request("POST", path: "/notifications/read-all")
    }
}
