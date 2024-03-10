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
    
    // not meant to be changed
    @AppStorage(SettingsKeys.showAppInMenuBar) private var showAppInMenuBar: Bool = true
    
    // Accessing App Delegate
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        MenuBarExtra(isInserted: $showAppInMenuBar) {
            ConfigurationView()
        } label: {
            Label("GiveMeTwenty", systemImage: "star")
        }
        .menuBarExtraStyle(.window)
        
        Window("CoverView", id: "CoverViewWindow", content: {
            CoverView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(BlurEffectView().ignoresSafeArea())
        }).windowStyle(.hiddenTitleBar) // hiding title bar itself
    }
}
#endif
