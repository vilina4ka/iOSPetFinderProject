//
//  NotificationsViewModel.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 05.04.2026.
//

import Foundation

@MainActor
final class NotificationsViewModel: ObservableObject {

    // MARK: - Published state

    @Published private(set) var notifications: [AppNotification] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    var unreadCount: Int {
        notifications.filter { !$0.isRead }.count
    }

    // MARK: - Dependencies

    private let repository: NotificationRepositoryProtocol

    init(repository: NotificationRepositoryProtocol = APIClientNotificationRepository()) {
        self.repository = repository
    }

    // MARK: - Methods

    func fetchNotifications() async {
        isLoading = true
        errorMessage = nil
        do {
            notifications = try await repository.fetchNotifications()
        } catch {
            errorMessage = "Не удалось загрузить уведомления"
        }
        isLoading = false
    }

    func markAsRead(id: String) async {
        guard let index = notifications.firstIndex(where: { $0.id == id }) else { return }
        let n = notifications[index]
        notifications[index] = AppNotification(
            id: n.id, type: n.type, petId: n.petId, sightingId: n.sightingId,
            title: n.title, body: n.body,
            isRead: true, createdAt: n.createdAt
        )
        try? await repository.markAsRead(id: id)
    }

    func markAllRead() async {
        do {
            try await repository.markAllRead()
            notifications = notifications.map {
                AppNotification(
                    id: $0.id, type: $0.type, petId: $0.petId, sightingId: $0.sightingId,
                    title: $0.title, body: $0.body,
                    isRead: true, createdAt: $0.createdAt
                )
            }
        } catch {}
    }
}
