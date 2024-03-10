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


class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    var timer: Timer?
    var coverWindow: NSWindow?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupTimer()
        findCoverWindow()
        hideTitleBarButtons()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
    
    func setupTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
            if let window = self.coverWindow {
                if window.isVisible {
                    window.orderOut(nil)
                } else {
                    window.makeKeyAndOrderFront(nil)
                }
            }
        }
    }
    
    func findCoverWindow() {
        coverWindow = NSApplication.shared.windows.first(where: { $0.title == "CoverView" })
    }
    
    func hideTitleBarButtons() {
        coverWindow?.standardWindowButton(.closeButton)?.isHidden = true
        coverWindow?.standardWindowButton(.miniaturizeButton)?.isHidden = true
        coverWindow?.standardWindowButton(.zoomButton)?.isHidden = true
    }
}
#endif
