//
//  UserDefaultsPersistenceService.swift
//  GiveMeTwenty
//
//  Created by Nile Kelly on 27/02/2024.
//

import Foundation

extension UserDefaults {
    func valueExists(forKey key: String) -> Bool {
        return object(forKey: key) != nil
    }
}

enum SettingsKeys {
    static let reminderFrequency = "reminderFrequency"
    static let runWhenComputerStarts = "runWhenComputerStarts"
    static let showAppInMenuBar = "showAppInMenuBar"
    static let popUpMenuMessage = "popUpMenuMessage"
    static let notificationsEnabled = "notificationsEnabled"
}

class UserDefaultsPersistenceService {
    
    // initialising singleton
    static let shared = UserDefaultsPersistenceService()
    
    private let storage: UserDefaults

    private init() {
        storage = UserDefaults.standard
        
        // Default values mapped to their keys
        let defaultValues: [String: Any] = [
            SettingsKeys.reminderFrequency: 1,
            SettingsKeys.notificationsEnabled: false,
            SettingsKeys.runWhenComputerStarts: true,
            SettingsKeys.showAppInMenuBar: true,
            SettingsKeys.popUpMenuMessage: "Give Me Twenty!"
        ]
        
        // Iterate over the default values and set them if they don't exist
        for (key, value) in defaultValues {
            if !storage.valueExists(forKey: key) {
                if let boolValue = value as? Bool {
                    saveBool(key: key, value: boolValue)
                }
                if let stringValue = value as? String {
                    saveString(key: key, value: stringValue)
                }
                if let intValue = value as? Int {
                    saveInt(key: key, value: intValue)
                }
            }
        }
    }
    
    func saveBool(key: String, value: Bool) {
        storage.set(value, forKey: key)
    }
    
    func loadBool(key: String) -> Bool {
        storage.bool(forKey: key)
    }
    
    func saveString(key: String, value: String) {
        storage.set(value, forKey: key)
    }
    
    func loadString(key: String) -> String {
        storage.string(forKey: key) ?? ""
    }
    
    func saveInt(key: String, value: Int) {
        storage.set(value, forKey: key)
    }
    
    func loadInt(key: String) -> Int {
        storage.integer(forKey: key)
    }
}
