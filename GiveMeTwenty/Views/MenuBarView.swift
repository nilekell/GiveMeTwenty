//
//  MenuBarView.swift
//  GiveMeTwenty
//
//  Created by Nile Kelly on 19/03/2024.
//

import SwiftUI

struct MenuBarView: View {
    
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
            openWindow(id: "configuration-view-window")
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
