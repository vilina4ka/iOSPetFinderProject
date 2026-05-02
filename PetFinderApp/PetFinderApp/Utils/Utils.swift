//
//  Utils.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 08.09.2025.
//
import Foundation
import UIKit

// MARK: - UIImage helpers

extension UIImage {
    func resizedForChat(maxSide: CGFloat) -> UIImage {
        let longestSide = max(size.width, size.height)
        guard longestSide > maxSide else { return self }
        let scale = maxSide / longestSide
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}

var apiJSONDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
        let container = try decoder.singleValueContainer()
        let dateString = try container.decode(String.self)

        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = isoFormatter.date(from: dateString) {
            return date
        }

        let shortFormatter = DateFormatter()
        shortFormatter.dateFormat = "yyyy-MM-dd"
        if let date = shortFormatter.date(from: dateString) {
            return date
        }

        throw DecodingError.dataCorruptedError(in: container,
            debugDescription: "Cannot decode date string \(dateString)")
    })

    return decoder
}()

let supabseJSONDecoder = apiJSONDecoder
