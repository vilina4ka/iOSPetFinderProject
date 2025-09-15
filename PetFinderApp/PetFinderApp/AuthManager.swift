//
//  AuthManager.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 11.09.2025.
//

import Foundation
import Supabase
import AuthenticationServices
import Combine
public struct MockUser: Identifiable {
    public let id: UUID
}

@MainActor
class AuthManager: ObservableObject {
    
    // MARK: - Properties
    
    static let shared = AuthManager()
    
    @Published private(set) var currentUser: MockUser?
    
    @Published private(set) var currentSession: Session?
    
    private init() {
        print("Создаем мок-пользователя для работы без реальной авторизации.")
        let dummyUser = MockUser(id: UUID())
        self.currentUser = dummyUser
        print("Mock-пользователь создан. currentUser ID: \(dummyUser.id)")
    }
    
    func signInWithYandex() async throws {
        print("signInWithYandex() вызван, но авторизация пока не реализована.")
    }
    
    // Имитация выхода
    func signOut() async throws {
        try await Task.sleep(nanoseconds: 1 * 1_000_000_000)
        await MainActor.run {
            self.currentSession = nil
            self.currentUser = nil
            print("🔴 Пользователь вышел (имитация).")
        }
    }
}
