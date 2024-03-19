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
        }
        .menuBarExtraStyle(.menu)
        
        Window("CoverView", id: "cover-view-window", content: {
            GeometryReader { geometry in
                CoverView()
                    .frame(minWidth: geometry.size.width, minHeight: geometry.size.height)
                    .background(BlurEffectView().ignoresSafeArea())
                    .environmentObject(appDelegate)
            }
            
        }).windowStyle(.hiddenTitleBar) // hiding title bar itself
        
        Window("ConfigurationView", id: "configuration-view-window", content: {
            ConfigurationView()
                .navigationTitle("Customise")
                .environmentObject(appDelegate)
        })
    }
}
#endif
