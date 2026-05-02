//
//  Pet.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 26.08.2025.
//
import Foundation

struct Pet: Identifiable, Codable, Hashable {
    let id: String
    let createdAt: Date?
    let name: String
    let breed: String
    let description: String
    let location: String
    let imageUrls: [String]
    let age: Int?
    let externalSigns: String?
    let longitude: Double?
    let latitude: Double?
    let type: String
    let contactPhone: String?
    let contactName: String?
    let lostDate: Date?
    let ownerId: String?
    let status: String?

    enum CodingKeys: String, CodingKey {
        case id, name, breed, description, age, latitude, longitude, type, status
        case location = "address"   
        case createdAt
        case imageUrls
        case externalSigns
        case contactPhone
        case contactName
        case lostDate
        case ownerId
    }

    var daysLost: Int? {
        guard let date = lostDate ?? createdAt else { return nil }
        let days = Calendar.current.dateComponents([.day], from: date, to: Date()).day ?? 0
        return max(0, days)
    }

    var timeAgo: String {
        guard let days = daysLost else { return "" }
        if days == 0 { return "сегодня" }
        return "\(days) дн"
    }
}

// MARK: - Sighting

struct Sighting: Codable {
    let id: String
    let petId: String
    let reporterId: String
    let reporterName: String
    let reporterAvatar: String
    let latitude: Double
    let longitude: Double
    let address: String
    let comment: String
    let imageUrls: [String]
    var status: String
    let createdAt: Date?
}
