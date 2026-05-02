//
//  ReportSightingViewModel.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 27.03.2026.
//

import UIKit
import CoreLocation

@MainActor
final class ReportSightingViewModel: ObservableObject {

    // MARK: - Form state

    @Published var comment: String = ""
    @Published var selectedImages: [UIImage] = []
    @Published var currentLocation: CLLocation?
    @Published var currentAddress: String = ""

    // MARK: - UI state

    @Published private(set) var isSubmitting = false
    @Published private(set) var didSubmit = false
    @Published private(set) var errorMessage: String?

    // MARK: - Dependencies

    private let pet: Pet
    private let repository: SightingRepositoryProtocol

    init(pet: Pet, repository: SightingRepositoryProtocol = APIClientSightingRepository()) {
        self.pet = pet
        self.repository = repository
    }

    // MARK: - Submit

    func submit() async {
        guard let location = currentLocation else {
            errorMessage = "Не удалось определить локацию. Попробуйте ещё раз."
            return
        }

        isSubmitting = true
        errorMessage = nil

        do {
            // Загружаем все фото параллельно
            var imageUrls: [String] = []
            for (index, image) in selectedImages.enumerated() {
                if let jpeg = image.jpegData(compressionQuality: 0.8) {
                    let response = try await APIClient.shared.upload(
                        data: jpeg,
                        filename: "sighting_\(UUID().uuidString)_\(index).jpg",
                        mimeType: "image/jpeg"
                    )
                    imageUrls.append(response.url)
                }
            }

            let _ = try await repository.reportSighting(
                petId: pet.id,
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude,
                address: currentAddress,
                comment: comment,
                imageUrls: imageUrls
            )

            didSubmit = true
        } catch {
            errorMessage = "Не удалось отправить репорт. Попробуйте ещё раз."
        }

        isSubmitting = false
    }
}
