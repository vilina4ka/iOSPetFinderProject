//
//  User.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 27.08.2025.
//

import Foundation

struct AppUser: Identifiable, Decodable {
    let id: String
    let name: String
    let email: String?
    let avatarURL: String?
    let phone: String?

    enum CodingKeys: String, CodingKey {
        case id, name, email, phone
        case avatarURL = "avatarUrl"
    }
}

struct LoginResponse: Decodable {
    let token: String
    let user: AppUser
}

struct YandexLoginRequest: Encodable {
    let code: String
}
