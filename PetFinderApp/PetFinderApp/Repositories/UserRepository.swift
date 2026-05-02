//
//  UserRepository.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 12.05.2026.
//

import Foundation

// MARK: - Protocol

protocol UserRepositoryProtocol {
    func fetchMyPets() async throws -> [Pet]
    func fetchSubscriptions() async throws -> [Pet]
}

// MARK: - APIClient Implementation

final class APIClientUserRepository: UserRepositoryProtocol {

    private let api: APIClient

    init(api: APIClient = .shared) {
        self.api = api
    }

    func fetchMyPets() async throws -> [Pet] {
        return try await api.request("GET", path: "/me/pets")
    }

    func fetchSubscriptions() async throws -> [Pet] {
        return try await api.request("GET", path: "/subscriptions")
    }
}
