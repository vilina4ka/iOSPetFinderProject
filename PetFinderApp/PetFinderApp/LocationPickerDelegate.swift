//
//  LocationPickerDelegate.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 15.09.2025.
//

import Foundation

protocol LocationPickerDelegate: AnyObject {
    func didFinishPickingLocation(location: SavedLocation)
}
