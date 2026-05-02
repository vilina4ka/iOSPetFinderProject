//
//  AuthManager.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 27.08.2025.
//

import Foundation
import UIKit
import AuthenticationServices
import KeychainAccess
import Combine

// MARK: - Models

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

// MARK: - AuthManager

@MainActor
class AuthManager: ObservableObject {

    static let shared = AuthManager()

    @Published private(set) var currentUser: AppUser?
    private let yandexClientID = "eefea0386012477b90094b0c36504525"

    private var yandexRedirectURI: String {
        return "\(kBaseURL)/auth/callback"
    }

    private let contextProvider = YandexAuthContextProvider()

    private init() {
        Task {
            await fetchCurrentUser()
        }
    }

    // MARK: - Public Properties

    var isLoggedIn: Bool {
        APIClient.shared.isLoggedIn
    }

    // MARK: - Auth Methods

    func signInWithYandex() async throws {

        let encodedRedirect = yandexRedirectURI.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? yandexRedirectURI
        let authURLString = "https://oauth.yandex.ru/authorize?response_type=code&client_id=\(yandexClientID)&redirect_uri=\(encodedRedirect)&display=popup&prompt=select_account&scope=login:info%20login:email%20login:avatar"

        guard let authURL = URL(string: authURLString) else {
            throw NSError(domain: "AuthManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Некорректный URL авторизации"])
        }

        let code = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<String, Error>) in
            let session = ASWebAuthenticationSession(url: authURL, callbackURLScheme: "lapki") { callbackURL, error in
                if let error = error as NSError? {
                    if error.code == ASWebAuthenticationSessionError.canceledLogin.rawValue {
                        continuation.resume(throwing: NSError(
                            domain: "AuthManager",
                            code: -99,
                            userInfo: [NSLocalizedDescriptionKey: "Вход отменён"]
                        ))
                    } else {
                        continuation.resume(throwing: error)
                    }
                    return
                }

                guard let url = callbackURL,
                      let code = URLComponents(url: url, resolvingAgainstBaseURL: true)?
                        .queryItems?
                        .first(where: { $0.name == "code" })?
                        .value else {
                    continuation.resume(throwing: NSError(
                        domain: "AuthManager",
                        code: -2,
                        userInfo: [NSLocalizedDescriptionKey: "Не удалось получить код авторизации"]
                    ))
                    return
                }

                continuation.resume(returning: code)
            }

            session.presentationContextProvider = self.contextProvider
            session.prefersEphemeralWebBrowserSession = true

            guard session.start() else {
                continuation.resume(throwing: NSError(
                    domain: "AuthManager",
                    code: -3,
                    userInfo: [NSLocalizedDescriptionKey: "Не удалось запустить экран авторизации"]
                ))
                return
            }
        }

        let loginRequest = YandexLoginRequest(code: code)
        let loginResponse: LoginResponse = try await APIClient.shared.request(
            "POST",
            path: "/auth/yandex",
            body: loginRequest
        )

        APIClient.shared.authToken = loginResponse.token
        self.currentUser = loginResponse.user

    }

    func signOut() async throws {
        APIClient.shared.authToken = nil
        self.currentUser = nil
    }

    func fetchCurrentUser() async {
        guard isLoggedIn else {
            self.currentUser = nil
            return
        }

        do {
            let user: AppUser = try await APIClient.shared.request("GET", path: "/me")
            self.currentUser = user
        } catch {
            if case APIError.unauthorized = error {
                self.currentUser = nil
            }
        }
    }
}

// MARK: - Presentation Context для ASWebAuthenticationSession

private class YandexAuthContextProvider: NSObject, ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first(where: { $0.isKeyWindow }) ?? UIWindow()
    }
}
