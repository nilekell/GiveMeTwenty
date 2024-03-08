//
//  GiveMeTwentyApp.swift
//  GiveMeTwenty
//
//  Created by Nile Kelly on 23/02/2024.
//

import SwiftUI

@main
struct GiveMeTwentyApp: App {
    
    init() {
        showAppInMenuBar = true
    }
    
    // not meant to be changed
    @AppStorage(SettingsKeys.showAppInMenuBar) private var showAppInMenuBar: Bool = true
    
    #if os(macOS)
    @State var window: NSWindow?
    @AppStorage("showCoverView") private var showCoverView: Bool = true
    #endif

    
    var body: some Scene {
        #if os(macOS)
        MenuBarExtra(isInserted: $showAppInMenuBar) {
            ConfigurationView()
        } label: {
            Label("GiveMeTwenty", systemImage: "star")
        }
        .menuBarExtraStyle(.window)
        
        Window("Give Me Twenty", id: "CoverViewWindow", content: {
            CoverView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(VisualEffectView().ignoresSafeArea())
                .onAppear(perform: {
                    window?.titleVisibility = .hidden
                    window?.styleMask.remove(.titled)
                })
        }).windowStyle(.hiddenTitleBar)
            
        #endif
    }
}
