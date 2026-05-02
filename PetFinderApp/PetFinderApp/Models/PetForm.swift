//
//  PetForm.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 06.09.2025.
//

import UIKit

enum PetPhoto {
    case existing(url: URL)
    case new(image: UIImage)
}

enum PetType: String, CaseIterable, Codable {
    case cat = "кошка"
    case dog = "собака"
}

struct UpsertPet: Codable {
    let name: String
    let breed: String
    let description: String
    let location: String
    let imageUrls: [String]
    let externalSigns: String?
    let latitude: Double?
    let longitude: Double?
    let age: Int?
    let type: String
    let contactPhone: String?
    let contactName: String?
    let lostDate: Date?

    enum CodingKeys: String, CodingKey {
        case name, breed, age, type
        case location = "address"
        case imageUrls
        case externalSigns
        case latitude, longitude
        case contactPhone
        case contactName
        case lostDate
        case description
    }
}
