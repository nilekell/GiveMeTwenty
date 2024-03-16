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
    
    // not meant to be changed after initialisation
    @AppStorage(SettingsKeys.showAppInMenuBar) private var showAppInMenuBar: Bool = true
    
    // Accessing App Delegate
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        // ensuring that showAppInMenuBar is always true
        UserDefaults.standard.setValue(true, forKey: SettingsKeys.showAppInMenuBar)
    }
    
    var body: some Scene {
        MenuBarExtra(isInserted: $showAppInMenuBar) {
            ConfigurationView()
                .environmentObject(appDelegate)
        } label: {
            Label("GiveMeTwenty", systemImage: "20.circle.fill")
        }
        .menuBarExtraStyle(.window)
        
        Window("CoverView", id: "CoverViewWindow", content: {
            GeometryReader { geometry in
                CoverView()
                    .frame(minWidth: geometry.size.width, minHeight: geometry.size.height)
                    .background(BlurEffectView().ignoresSafeArea())
                    .environmentObject(appDelegate)
            }
            
        }).windowStyle(.hiddenTitleBar) // hiding title bar itself
    }
}
#endif
