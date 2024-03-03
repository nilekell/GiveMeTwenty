//
//  GiveMeTwentyApp.swift
//  GiveMeTwenty
//
//  Created by Nile Kelly on 23/02/2024.
//

import SwiftUI

@main
struct GiveMeTwentyApp: App {
    
    @AppStorage(SettingsKeys.showAppInMenuBar) var showAppInMenuBar: Bool = true
    
    var body: some Scene {
        #if os(macOS)
        MenuBarExtra(isInserted: $settingsViewModel.showAppInMenuBar) {
            ContentView()
                .navigationTitle("GiveMeTwenty")
        } label: {
            Label("GiveMeTwenty", systemImage: "star")
        }
        .menuBarExtraStyle(.window)
        #endif
    }
}
