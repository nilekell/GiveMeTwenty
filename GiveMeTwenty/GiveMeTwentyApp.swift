//
//  GiveMeTwentyApp.swift
//  GiveMeTwenty
//
//  Created by Nile Kelly on 23/02/2024.
//

import SwiftUI

@main
struct GiveMeTwentyApp: App {
    @StateObject private var settingsViewModel = SettingsViewModel()
    
    var body: some Scene {
        #if os(macOS)
        MenuBarExtra(isInserted: $settingsViewModel.showAppInMenuBar) {
            ContentView()
                .navigationTitle("GiveMeTwenty")
        } label: {
            Label("GiveMeTwenty", systemImage: "star")
        }
        .menuBarExtraStyle(.window)
        .environmentObject(settingsViewModel)
        #endif
        
        WindowGroup {
            ContentView()
                .navigationTitle("GiveMeTwenty")
                .environmentObject(settingsViewModel)
        }
    }
}
