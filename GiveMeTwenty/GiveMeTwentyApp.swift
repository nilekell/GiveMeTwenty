//
//  GiveMeTwentyApp.swift
//  GiveMeTwenty
//
//  Created by Nile Kelly on 23/02/2024.
//

import SwiftUI

@main
struct GiveMeTwentyApp: App {
    
    // not meant to be changed
    @AppStorage(SettingsKeys.showAppInMenuBar) private let showAppInMenuBar: Bool = true
    
    var body: some Scene {
        #if os(macOS)
        MenuBarExtra(isInserted: $showAppInMenuBar) {
            ConfigurationView()
                .navigationTitle("GiveMeTwenty")
        } label: {
            Label("GiveMeTwenty", systemImage: "star")
        }
        .menuBarExtraStyle(.window)
        #endif
    }
}
