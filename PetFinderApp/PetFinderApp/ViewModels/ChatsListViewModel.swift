//
//  ChatsListViewModel.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 19.03.2026.
//

import Foundation

@MainActor
final class ChatsListViewModel: ObservableObject {

    // MARK: - Published state

    @Published private(set) var threads: [ChatThread] = []
    @Published private(set) var isLoading = false

    var totalUnreadCount: Int {
        threads.reduce(0) { $0 + $1.unreadCount }
    }

    // MARK: - Dependencies

    private let repository: ChatRepositoryProtocol

    init(repository: ChatRepositoryProtocol = APIClientChatRepository()) {
        self.repository = repository
    }

    // MARK: - Methods

    func fetchThreads() async {
        isLoading = true
        do {
            threads = try await repository.fetchThreads()
        } catch {}
        isLoading = false
    }
}
