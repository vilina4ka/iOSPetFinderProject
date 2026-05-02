//
//  SubscriptionsViewModel.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 12.04.2026.
//

import Foundation

@MainActor
final class SubscriptionsViewModel: ObservableObject {

    // MARK: - Published state

    @Published private(set) var pets: [Pet] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    // MARK: - Dependencies

    private let repository: UserRepositoryProtocol

    init(repository: UserRepositoryProtocol = APIClientUserRepository()) {
        self.repository = repository
    }

    // MARK: - Methods

    func fetchSubscriptions() async {
        isLoading = true
        errorMessage = nil
        do {
            pets = try await repository.fetchSubscriptions()
        } catch {
            errorMessage = "Не удалось загрузить подписки"
        }
        isLoading = false
    }
}
