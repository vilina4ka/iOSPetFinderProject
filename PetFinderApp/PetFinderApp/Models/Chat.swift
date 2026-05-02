//
//  Chat.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 18.03.2026.
//

import Foundation

struct ChatMessage: Codable, Identifiable {
    let id: String
    let petId: String
    let sightingId: String?
    let senderId: String
    let recipientId: String
    let text: String
    let isRead: Bool
    let createdAt: Date?
    let imageUrl: String?
    let fileName: String?
}

struct ChatThread: Codable, Identifiable {
    var id: String { petId + (sightingId ?? "") + otherUserId }
    let petId: String
    let sightingId: String?
    let petName: String
    let petImageUrl: String
    let otherUserId: String
    let otherUserName: String
    let otherUserAvatar: String
    let lastMessage: String
    let lastMessageAt: Date?
    let unreadCount: Int
}
