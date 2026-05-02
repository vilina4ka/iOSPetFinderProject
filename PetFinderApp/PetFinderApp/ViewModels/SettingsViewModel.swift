//
//  SettingsViewModel.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 10.04.2026.
//

import Foundation
import UserNotifications

@MainActor
final class SettingsViewModel: ObservableObject {

    @Published private(set) var notificationsEnabled = false

    func checkNotificationStatus() async {
        let settings = await withCheckedContinuation { continuation in
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                continuation.resume(returning: settings)
            }
        }
        notificationsEnabled = settings.authorizationStatus == .authorized
    }

    /// Returns `true` if the user granted permission.
    func requestNotificationPermission() async -> Bool {
        let granted = await withCheckedContinuation { continuation in
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                continuation.resume(returning: granted)
            }
        }
        notificationsEnabled = granted
        return granted
    }
}
