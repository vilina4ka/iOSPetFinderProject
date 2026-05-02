//
//  PetDetailViewModel.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 10.03.2026.
//

import Foundation
import Combine

// MARK: - PetDetailViewModel

@MainActor
final class PetDetailViewModel: ObservableObject {

    // MARK: - Dependencies

    private let pet: Pet
    private let repository: PetRepositoryProtocol

    // MARK: - Init

    init(pet: Pet, repository: PetRepositoryProtocol = APIClientPetRepository()) {
        self.pet = pet
        self.repository = repository
    }

    // MARK: - Computed

    private let devOverrideIsOwner: Bool? = nil

    var isOwner: Bool {
        if let override = devOverrideIsOwner { return override }
        guard let currentId = AuthManager.shared.currentUser?.id,
              let ownerId = pet.ownerId else { return false }
        return currentId == ownerId
    }

    var shareText: String {
        var text = "🐾 \(pet.name) (\(pet.breed))\n"
        text += "\(pet.description)\n"
        text += "📍 \(pet.location)\n"
        return text
    }

    var shareImageURL: URL? {
        guard let first = pet.imageUrls.first else { return nil }
        return URL(string: first)
    }
}
