//
//  Notification.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 07.09.2025.
//

import Foundation

struct AppNotification: Decodable {
    let id: String
    let type: String
    let petId: String?
    let sightingId: String?
    let title: String
    let body: String
    let isRead: Bool
    let createdAt: Date
}
