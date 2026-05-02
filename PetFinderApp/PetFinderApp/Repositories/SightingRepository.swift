//
//  SightingRepository.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 28.03.2026.
//

import Foundation

// MARK: - Protocol

protocol SightingRepositoryProtocol {
    func reportSighting(
        petId: String,
        latitude: Double,
        longitude: Double,
        address: String,
        comment: String,
        imageUrls: [String]
    ) async throws -> String
}

// MARK: - APIClient Implementation

final class APIClientSightingRepository: SightingRepositoryProtocol {

    private let api: APIClient

    init(api: APIClient = .shared) {
        self.api = api
    }

    func reportSighting(
        petId: String,
        latitude: Double,
        longitude: Double,
        address: String,
        comment: String,
        imageUrls: [String]
    ) async throws -> String {
        let body = SightingRequest(
            latitude: latitude,
            longitude: longitude,
            address: address,
            comment: comment,
            imageUrls: imageUrls
        )
        let response: SightingCreateResponse = try await api.request(
            "POST",
            path: "/pets/\(petId)/sightings",
            body: body
        )
        return response.id
    }
}

// MARK: - Request / Response models

private struct SightingRequest: Encodable {
    let latitude: Double
    let longitude: Double
    let address: String
    let comment: String
    let imageUrls: [String]
}

private struct SightingCreateResponse: Decodable {
    let id: String
}
