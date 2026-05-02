//
//  APIClient.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 12.02.2026.
//

import Foundation
import KeychainAccess

let kBaseURL = "http://178.154.198.101:8080"

final class APIClient {

    // MARK: - Singleton

    static let shared = APIClient()
    private init() {
    }

    // MARK: - Properties

    private let baseURL = kBaseURL
    private let keychain = Keychain(service: "ru.lapki.app")
    private let keychainTokenKey = "authToken"

    var authToken: String? {
        get {
            return try? keychain.get(keychainTokenKey)
        }
        set {
            if let token = newValue {
                try? keychain.set(token, key: keychainTokenKey)
            } else {
                try? keychain.remove(keychainTokenKey)
            }
        }
    }

    var isLoggedIn: Bool {
        return authToken != nil
    }

    let apiDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .custom { (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)

            let isoWithFraction = ISO8601DateFormatter()
            isoWithFraction.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            if let date = isoWithFraction.date(from: dateString) {
                return date
            }

            let isoPlain = ISO8601DateFormatter()
            isoPlain.formatOptions = [.withInternetDateTime]
            if let date = isoPlain.date(from: dateString) {
                return date
            }

            let shortFormatter = DateFormatter()
            shortFormatter.dateFormat = "yyyy-MM-dd"
            shortFormatter.locale = Locale(identifier: "en_US_POSIX")
            if let date = shortFormatter.date(from: dateString) {
                return date
            }

            throw DecodingError.dataCorruptedError(in: container,
                debugDescription: "Cannot decode date string \(dateString)")
        }
        return decoder
    }()

    let apiEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()

    // MARK: - Public Methods

    func request<T: Decodable>(
        _ method: String,
        path: String,
        body: Encodable? = nil,
        queryItems: [URLQueryItem]? = nil
    ) async throws -> T {

        guard var urlComponents = URLComponents(string: baseURL + path) else {
            throw APIError.invalidURL
        }

        if let queryItems = queryItems {
            urlComponents.queryItems = queryItems
        }

        guard let url = urlComponents.url else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        if let body = body {
            let encoded = try apiEncoder.encode(body)
            request.httpBody = encoded
        } else {
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.unknown
        }


        switch httpResponse.statusCode {
        case 200...299:
            do {
                let decoded = try apiDecoder.decode(T.self, from: data)
                return decoded
            } catch {
                throw APIError.unknown
            }
        case 401:
            authToken = nil
            throw APIError.unauthorized
        case 400...499:
            if let body = try? JSONDecoder().decode(ErrorResponse.self, from: data),
               let text = body.text {
                throw APIError.server(text)
            }
            throw APIError.server("Что-то пошло не так. Попробуйте ещё раз.")
        case 500...599:
            throw APIError.server("Ошибка сервера: \(httpResponse.statusCode)")
        default:
            throw APIError.unknown
        }
    }

    func upload(imageData: Data, filename: String) async throws -> String {
        let boundary = UUID().uuidString
        let url = URL(string: baseURL + "/upload")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        var body = Data()

        let boundaryPrefix = "--\(boundary)\r\n"
        body.append(Data(boundaryPrefix.utf8))
        body.append(Data("Content-Disposition: form-data; name=\"image\"; filename=\"\(filename)\"\r\n".utf8))
        body.append(Data("Content-Type: image/jpeg\r\n\r\n".utf8))
        body.append(imageData)
        body.append(Data("\r\n--\(boundary)--\r\n".utf8))

        request.httpBody = body


        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.unknown
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.server("Ошибка загрузки: \(httpResponse.statusCode)")
        }

        let uploadResponse = try apiDecoder.decode(UploadResponse.self, from: data)
        return uploadResponse.url
    }
}

// MARK: - Error Types

enum APIError: LocalizedError {
    case invalidURL
    case unauthorized
    case server(String)
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Некорректный URL"
        case .unauthorized:
            return "Не авторизирован"
        case .server(let message):
            return message
        case .unknown:
            return "Неизвестная ошибка"
        }
    }
}

// MARK: - Response Models

struct ErrorResponse: Decodable {
    let message: String? 
    let error: String?

    var text: String? { message ?? error }
}

struct UploadResponse: Decodable {
    let url: String
}

struct EmptyResponse: Decodable {}
