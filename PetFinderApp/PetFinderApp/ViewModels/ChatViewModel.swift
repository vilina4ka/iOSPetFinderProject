//
//  ChatViewModel.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 18.03.2026.
//
import Foundation
import Combine
import UIKit
import UniformTypeIdentifiers

// MARK: - ChatViewModel

@MainActor
final class ChatViewModel: ObservableObject {

    @Published private(set) var messages: [ChatMessage] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var isSending: Bool = false
    @Published private(set) var errorMessage: String?

    var currentUserId: String? {
        AuthManager.shared.currentUser?.id
    }

    let recipientName: String
    let recipientAvatar: String

    var petName: String { pet.name }

    private let pet: Pet
    private let recipientId: String
    private let sightingId: String?
    private let repository: ChatRepositoryProtocol
    private let ws = WebSocketService.shared

    init(
        pet: Pet,
        recipientId: String,
        recipientName: String = "",
        recipientAvatar: String = "",
        sightingId: String? = nil,
        repository: ChatRepositoryProtocol = APIClientChatRepository()
    ) {
        self.pet = pet
        self.recipientId = recipientId
        self.recipientName = recipientName
        self.recipientAvatar = recipientAvatar
        self.sightingId = sightingId
        self.repository = repository
    }

    // MARK: - WebSocket

    func connectWebSocket() {
        ws.connect()
        ws.onMessage = { [weak self] incoming in
            guard let self else { return }
            // Only handle messages for this specific chat.
            guard incoming.petId == self.pet.id else { return }
            let newMsg = ChatMessage(
                id: incoming.id ?? UUID().uuidString,
                petId: incoming.petId ?? self.pet.id,
                sightingId: incoming.sightingId,
                senderId: incoming.senderId ?? "",
                recipientId: incoming.recipientId ?? "",
                text: incoming.text ?? "",
                isRead: false,
                createdAt: incoming.createdAt ?? Date(),
                imageUrl: incoming.imageUrl,
                fileName: incoming.fileName
            )
            // Avoid duplicates.
            guard !self.messages.contains(where: { $0.id == newMsg.id }) else { return }
            self.messages.append(newMsg)
        }
    }

    nonisolated func disconnectWebSocket() {
        WebSocketService.shared.onMessage = nil
        WebSocketService.shared.disconnect()
    }

    func loadMessages() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let loaded = try await repository.fetchMessages(
                petId: pet.id,
                otherUserId: recipientId,
                sightingId: sightingId,
                limit: 50,
                offset: 0
            )
            messages = loaded.reversed()
        } catch {
            errorMessage = "Не удалось загрузить сообщения"
        }
    }

    func markMessagesRead() async {
        do {
            try await repository.markRead(petId: pet.id, otherUserId: recipientId)
        } catch {
            print("[ChatViewModel] markRead failed: \(error)")
        }
    }

    func sendMessage(_ text: String) async throws {
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        guard !isSending else { return }

        isSending = true
        defer { isSending = false }

        _ = try await repository.sendMessage(
            petId: pet.id,
            recipientId: recipientId,
            text: text,
            sightingId: sightingId,
            imageUrl: nil,
            fileName: nil
        )
        await loadMessages()
    }

    func deleteMessage(id: String) async throws {
        try await repository.deleteMessage(id: id)
        await loadMessages()
    }

    func editMessage(id: String, text: String) async throws {
        try await repository.editMessage(id: id, text: text)
        await loadMessages()
    }

    /// Uploads a UIImage and sends it as a photo message (shown as image preview).
    func sendImageMessage(_ image: UIImage) async throws {
        guard !isSending else { return }

        isSending = true
        defer { isSending = false }

        let resized = image.resizedForChat(maxSide: 1080)
        guard let imageData = resized.jpegData(compressionQuality: 0.92) else {
            throw APIError.unknown
        }

        let filename = "chat_\(UUID().uuidString).jpg"
        let uploaded = try await APIClient.shared.upload(data: imageData, filename: filename, mimeType: "image/jpeg")

        _ = try await repository.sendMessage(
            petId: pet.id,
            recipientId: recipientId,
            text: "",
            sightingId: sightingId,
            imageUrl: uploaded.url,
            fileName: nil
        )
        await loadMessages()
    }

    /// Uploads any file and sends it as a file attachment bubble.
    func sendFileMessage(fileURL: URL) async throws {
        guard !isSending else { return }

        isSending = true
        defer { isSending = false }

        let accessed = fileURL.startAccessingSecurityScopedResource()
        defer { if accessed { fileURL.stopAccessingSecurityScopedResource() } }

        let fileData = try Data(contentsOf: fileURL)
        let originalName = fileURL.lastPathComponent
        let ext = fileURL.pathExtension.lowercased()

        let mimeType: String
        if let utType = UTType(filenameExtension: ext), let mime = utType.preferredMIMEType {
            mimeType = mime
        } else {
            mimeType = "application/octet-stream"
        }

        let uploaded = try await APIClient.shared.upload(data: fileData, filename: originalName, mimeType: mimeType)

        _ = try await repository.sendMessage(
            petId: pet.id,
            recipientId: recipientId,
            text: "",
            sightingId: sightingId,
            imageUrl: uploaded.url,
            fileName: uploaded.fileName ?? originalName
        )
        await loadMessages()
    }
}
