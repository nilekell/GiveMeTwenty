//
//  GiveMeTwentyApp.swift
//  GiveMeTwenty
//
//  Created by Nile Kelly on 23/02/2024.
//

import SwiftUI

#if os(macOS)
@main
struct GiveMeTwentyApp: App {
    // Accessing App Delegate
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        MenuBarExtra("GiveMeTwenty", systemImage: "20.circle.fill") {
            MenuBarView()
                .environmentObject(appDelegate)
        }
        .menuBarExtraStyle(.menu)
        
        Window("ConfigurationView", id: "configuration-view-window", content: {
            ConfigurationView()
                .navigationTitle("Customise")
                .environmentObject(appDelegate)
        })
    }
}
#endif
