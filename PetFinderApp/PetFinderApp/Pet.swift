//
//  Pet.swift
//  PetforPets
//
//  Created by Вилина Ольховская on 07.09.2025.
//

import Foundation

struct Pet: Identifiable, Codable, Hashable {
    let id: Int
    
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
    let lostDate: Date
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at" 
        case name, breed, description, location, imageUrls, age, externalSigns, latitude, longitude, type, contactPhone, contactName, lostDate
    }
    
    var timeAgo: String {
        let date = lostDate
        
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day], from: date, to: now)
        
        if let days = components.day, days > 0 { return "\(days) дн" }
        return "0 дн"
    }
}
