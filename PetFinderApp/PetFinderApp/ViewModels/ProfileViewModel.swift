//
//  ProfileViewModel.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 07.09.2025.
//

import Foundation
import Combine

@MainActor
final class ProfileViewModel: ObservableObject {

    @Published private(set) var user: AppUser?

    init() {
        AuthManager.shared.$currentUser
            .assign(to: &$user)
    }

    func signOut() async throws {
        try await AuthManager.shared.signOut()
    }
}
