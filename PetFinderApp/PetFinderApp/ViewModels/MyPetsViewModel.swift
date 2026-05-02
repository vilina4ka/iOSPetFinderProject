//
//  MyPetsViewModel.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 10.04.2026.
//

import Foundation

@MainActor
final class MyPetsViewModel: ObservableObject {

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

    func fetchPets() async {
        isLoading = true
        errorMessage = nil
        do {
            pets = try await repository.fetchMyPets()
        } catch {
            errorMessage = "Не удалось загрузить объявления"
        }
        isLoading = false
    }
}
