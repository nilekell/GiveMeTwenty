//
//  SettingsViewModel.swift
//  GiveMeTwenty
//
//  Created by Nile Kelly on 27/02/2024.
//

import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    // Configure app to send reminders every x hours
    @Published var reminderFrequency = 2 {
        didSet {
            updateReminderFrequency()
        }
    }
    
    // Configure app to send notifications or not
    @Published var notificationsEnabled = true {
        didSet {
            toggleNotifications()
        }
    }
    
    // Configure app to run when computer starts
    @Published var runWhenComputerStarts = true {
        didSet {
            toggleRunWhenComputerStarts()
        }
    }
    
    // Configure app to appear in menu bar or not
    @Published var showAppInMenuBar = true {
        didSet {
            toggleShowAppInMenuBar()
        }
    }
    
    // Configure message to show on popUp Menu
    @Published var popUpMenuMessage = "Give Me Twenty!" {
        didSet {
            toggleShowAppInMenuBar()
        }
    }
    
    // Configure sound to play whenever notification is sent
    
    private var persistenceService: UserDefaultsPersistenceService
    
    init() {
        persistenceService = UserDefaultsPersistenceService.shared
    }
    
    func updateReminderFrequency() {
        print("updated reminderFrequency: \(reminderFrequency)")
    }
    
    func toggleNotifications() {
        print("updated notificationsEnabled: \(notificationsEnabled)")
    }
    
    func toggleRunWhenComputerStarts() {
        print("updated runWhenComputerStarts: \(runWhenComputerStarts)")
    }
    
    func toggleShowAppInMenuBar() {
        print("updated showAppInMenuBar: \(showAppInMenuBar)")
    }
    
    func updatePopUpMenuMessage() {
        print("update popUpMenuMessage: \(popUpMenuMessage)")
    }
}
