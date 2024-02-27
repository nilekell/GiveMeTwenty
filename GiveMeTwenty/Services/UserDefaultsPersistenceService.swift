//
//  UserDefaultsPersistenceService.swift
//  GiveMeTwenty
//
//  Created by Nile Kelly on 27/02/2024.
//

import Foundation

class UserDefaultsPersistenceService {
    
    static let shared = UserDefaultsPersistenceService()
    private let storage: UserDefaults

    private init() {
        storage = UserDefaults.standard
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
}
