//
//  LocationService.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 11.09.2025.
//

import Foundation

struct SavedLocation: Codable {
    let latitude: Double
    let longitude: Double
    let radius: Float
    let address: String
}

class LocationService {
    
    static let shared = LocationService()
    
    private let defaults = UserDefaults.standard
    private let locationKey = "savedUserLocation"
    
    private init() {}
    
    func saveLocation(_ location: SavedLocation) {
        do {
            let data = try JSONEncoder().encode(location)
            defaults.set(data, forKey: locationKey)
            print("Локация успешно сохранена.")
        } catch {
            print("Ошибка при сохранении локации: \(error)")
        }
    }
    
    func loadLocation() -> SavedLocation? {
        guard let data = defaults.data(forKey: locationKey) else {
            return nil
        }
        
        do {
            let location = try JSONDecoder().decode(SavedLocation.self, from: data)
            print("Локация успешно загружена.")
            return location
        } catch {
            print("Ошибка при загрузке локации: \(error)")
            return nil
        }
    }
    
    func getDefaultLocation() -> SavedLocation {
        return SavedLocation(
            latitude: 55.751244,
            longitude: 37.618423,
            radius: 10.0,
            address: "Москва"
        )
    }
}
