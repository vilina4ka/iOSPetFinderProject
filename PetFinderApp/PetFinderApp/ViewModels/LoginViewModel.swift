//
//  LoginViewModel.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 27.08.2025.
//

import Foundation

@MainActor
final class LoginViewModel: ObservableObject {

    @Published private(set) var isYandexLoading = false
    @Published private(set) var isDevLoading = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var didLogin = false

    func signInWithYandex() async {
        guard !isYandexLoading else { return }
        isYandexLoading = true
        errorMessage = nil
        do {
            try await AuthManager.shared.signInWithYandex()
            didLogin = true
        } catch {
            errorMessage = error.localizedDescription
        }
        isYandexLoading = false
    }

    func devLogin() async {
        guard !isDevLoading else { return }
        isDevLoading = true
        errorMessage = nil
        do {
            let response: LoginResponse = try await APIClient.shared.request("POST", path: "/auth/dev-login")
            APIClient.shared.authToken = response.token
            await AuthManager.shared.fetchCurrentUser()
            didLogin = true
        } catch {
            errorMessage = error.localizedDescription
        }
        isDevLoading = false
    }
}
