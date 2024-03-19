//
//  MenuBarView.swift
//  GiveMeTwenty
//
//  Created by Nile Kelly on 19/03/2024.
//

import SwiftUI

struct MenuBarView: View {
    
    @EnvironmentObject private var appDelegate: AppDelegate
    
    @Environment(\.openWindow) var openWindow
    
    var body: some View {
        Button("Just did twenty") {
        }

        Divider()

        Text("Snooze for...")

        Button("30 minutes") {
        }

        Button("1 hour") {
        }

        Button("2 hours") {
        }

        Button("4 hours") {
        }

        Button("Until tomorrow") {
        }

        Divider()

        Button("Preferences...") {
            // adding activate() and makeKeyAndOrderFront() allow configuration window to always come to front
            NSApplication.shared.activate(ignoringOtherApps: true)
            openWindow(id: "configuration-view-window")
            appDelegate.configurationWindow?.makeKeyAndOrderFront(self)
        }

        Divider()

        Button("Quit GiveMeTwenty") {
            NSApp.terminate(self)
        }
    }
}

#Preview {
    MenuBarView()
        .frame(width: 150)
}
