//
//  StorageManager.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 28.08.2025.
//

import Foundation
import UIKit

final class StorageManager {

    // MARK: - Singleton

    static let shared = StorageManager()
    private init() {}

    // MARK: - Public Methods

    func uploadPetImage(image: UIImage, bucketName: String) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            throw NSError(domain: "StorageManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Не удалось конвертировать изображение."])
        }

        let imageFileName = UUID().uuidString + ".jpg"

        let uploadedURL = try await APIClient.shared.upload(imageData: imageData, filename: imageFileName)

        return uploadedURL
    }
}
