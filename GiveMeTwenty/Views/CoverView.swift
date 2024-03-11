//
//  CoverView.swift
//  GiveMeTwenty
//
//  Created by Nile Kelly on 07/03/2024.
//

import SwiftUI

struct CoverView: View {
    
    @EnvironmentObject private var appDelegate: AppDelegate
    
    @AppStorage(SettingsKeys.popUpMenuMessage) var popUpMenuMessage: String = "Time to give me twenty!"
    @AppStorage(SettingsKeys.coverViewDuration) var coverViewDuration: Double = 60.0
    @AppStorage(SettingsKeys.selectedSound) var selectedSound: String = NSSound.Sound.basso.rawValue
    
    var body: some View {
        VStack {
            Text(popUpMenuMessage)
                .font(.system(size: 64))
                .bold()
            
            Button(action: closeScreen) {
                Label("Close", systemImage: "arrow.up")
            }
        }
        // adding focusable() enables onKeyPress to work
        .focusable()
        // removing blue outline
        .focusEffectDisabled()
        .onKeyPress(keys: [.escape, .space, .return]) { press in
            closeScreen()
            return .handled
        }
    }
    
    func closeScreen() {
        appDelegate.hideCoverWindow()
    }
}

#Preview {
    CoverView()
}
