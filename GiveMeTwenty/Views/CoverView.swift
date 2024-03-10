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
    
    @AppStorage(SettingsKeys.selectedSound) var selectedSound: String = NSSound.Sound.basso.rawValue // Default sound

    
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
        .onAppear(perform: {
            print("CoverView will show for \(coverViewDuration) seconds")
            // automatically closing screen after 60s
            DispatchQueue.main.asyncAfter(deadline: .now() + coverViewDuration) {
                closeScreen()
            }
        })
    }
    
    func closeScreen() {
        if let selectedSoundEnum = NSSound.Sound(rawValue: selectedSound) {
            NSSound.play(selectedSoundEnum)
        }
        appDelegate.hideCoverWindow()
    }
}

#Preview {
    CoverView()
}
