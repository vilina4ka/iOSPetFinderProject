//
//  PetListViewModel.swift
//  PetforPets
//
//  Created by Вилина Ольховская on 07.09.2025.
//

import Foundation
import CoreLocation
import Supabase

@MainActor
class PetListViewModel: ObservableObject {
    
    @Published var pets: [Pet] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private struct RpcParams: Encodable {
        let lat: Double
        let long: Double
        let radius_meters: Double
        let search_text: String?
    }

    func fetchPets(at location: CLLocationCoordinate2D, with radiusInKm: Double, searchText: String? = nil) async {
        isLoading = true
        errorMessage = nil
        
        let radiusInMeters = radiusInKm * 1000
        
        do {
            let params = RpcParams(
                lat: location.latitude,
                long: location.longitude,
                radius_meters: radiusInMeters,
                search_text: searchText
            )
            
            let response = try await supabase
                .rpc("pets_in_radius", params: params)
                .execute()
            let fetchedPets = try supabseJSONDecoder.decode([Pet].self, from: response.data)

            self.pets = fetchedPets
            
        } catch {
            self.errorMessage = error.localizedDescription
            print("ОШИБКA при загрузке питомцев: \(error)")
        }
        
        isLoading = false
    }
}
