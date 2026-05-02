//
//  PetListViewModel.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 02.09.2025.
//

import Foundation
import CoreLocation
import Combine

@MainActor
class PetListViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published var pets: [Pet] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    // MARK: - Dependencies

    private let repository: PetRepositoryProtocol

    // MARK: - Init

    init(repository: PetRepositoryProtocol = APIClientPetRepository()) {
        self.repository = repository
    }

    // MARK: - Public Methods

    func fetchPets(
        at location: CLLocationCoordinate2D,
        with radiusInKm: Double,
        searchText: String? = nil,
        petType: String? = nil,
        lostFrom: Date? = nil,
        lostTo: Date? = nil,
        breed: String? = nil
    ) async {
        isLoading = true
        errorMessage = nil

        do {
            let fetchedPets = try await repository.fetchPets(
                lat: location.latitude,
                lon: location.longitude,
                radiusInMeters: radiusInKm * 1000,
                searchText: searchText,
                petType: petType,
                lostFrom: lostFrom,
                lostTo: lostTo,
                breed: breed
            )

            var seen = Set<String>()
            self.pets = fetchedPets.filter { seen.insert($0.id).inserted }

        } catch {
            self.errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
