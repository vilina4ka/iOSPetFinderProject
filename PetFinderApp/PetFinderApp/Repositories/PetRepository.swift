//
//  PetRepository.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 14.02.2026.
//

import Foundation

// MARK: - Protocol

protocol PetRepositoryProtocol {
    func fetchPets(
        lat: Double,
        lon: Double,
        radiusInMeters: Double,
        searchText: String?,
        petType: String?,
        lostFrom: Date?,
        lostTo: Date?,
        breed: String?
    ) async throws -> [Pet]

    func createPet(_ pet: UpsertPet) async throws -> String
    func updatePet(id: String, _ pet: UpsertPet) async throws
}

// MARK: - APIClient Implementation

final class APIClientPetRepository: PetRepositoryProtocol {

    private let api: APIClient

    init(api: APIClient = .shared) {
        self.api = api
    }

    func fetchPets(
        lat: Double,
        lon: Double,
        radiusInMeters: Double,
        searchText: String?,
        petType: String?,
        lostFrom: Date?,
        lostTo: Date?,
        breed: String?
    ) async throws -> [Pet] {
        var queryItems = [
            URLQueryItem(name: "lat", value: "\(lat)"),
            URLQueryItem(name: "long", value: "\(lon)"),
            URLQueryItem(name: "radius", value: "\(radiusInMeters)")
        ]

        if let searchText, !searchText.isEmpty {
            queryItems.append(URLQueryItem(name: "search", value: searchText))
        }
        if let petType, !petType.isEmpty {
            queryItems.append(URLQueryItem(name: "type", value: petType))
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        if let lostFrom {
            queryItems.append(URLQueryItem(name: "lost_from", value: dateFormatter.string(from: lostFrom)))
        }
        if let lostTo {
            queryItems.append(URLQueryItem(name: "lost_to", value: dateFormatter.string(from: lostTo)))
        }
        if let breed, !breed.isEmpty {
            queryItems.append(URLQueryItem(name: "breed", value: breed))
        }

        return try await api.request("GET", path: "/pets", queryItems: queryItems)
    }

    func createPet(_ pet: UpsertPet) async throws -> String {
        struct CreateResponse: Decodable {
            let id: String
        }
        let response: CreateResponse = try await api.request("POST", path: "/pets", body: pet)
        return response.id
    }

    func updatePet(id: String, _ pet: UpsertPet) async throws {
        let _: EmptyResponse = try await api.request("PUT", path: "/pets/\(id)", body: pet)
    }
}
