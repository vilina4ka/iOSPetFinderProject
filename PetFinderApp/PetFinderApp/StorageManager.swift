//
//  StorageManager.swift
//  PetforPets
//
//  Created by Вилина Ольховская on 07.09.2025.
//


import Foundation
import UIKit
import Supabase

final class StorageManager {
    static let shared = StorageManager()
    private init() {}
    
    func uploadPetImage(image: UIImage, bucketName: String) async throws -> URL {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            throw NSError(domain: "StorageManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Не удалось конвертировать изображение."])
        }
        
        let imageFileName = UUID().uuidString + ".jpg"
        
        try await supabase.storage
            .from(bucketName)
            .upload(path: imageFileName, file: imageData, options: FileOptions(contentType: "image/jpeg"))
        
        let imageUrlResponse = try supabase.storage
            .from(bucketName)
            .getPublicURL(path: imageFileName)
        
        return imageUrlResponse
    }
}
