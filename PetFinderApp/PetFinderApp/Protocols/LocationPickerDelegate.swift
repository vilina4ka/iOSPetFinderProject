//
//  LocationPickerDelegate.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 01.09.2025.
//

import Foundation

protocol LocationPickerDelegate: AnyObject {
    func didFinishPickingLocation(location: SavedLocation)
}
