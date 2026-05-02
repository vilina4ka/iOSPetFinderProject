//
//  Utils.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 08.09.2025.
//

import Foundation

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
