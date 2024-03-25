//
//  CoverView.swift
//  GiveMeTwenty
//
//  Created by Nile Kelly on 07/03/2024.
//

import SwiftUI

struct CoverView: View {
    
    @EnvironmentObject private var appDelegate: AppDelegate
    
    @AppStorage(SettingsKeys.popUpMenuMessage) private var popUpMenuMessage: String = "Time to give me twenty!"
    
    @AppStorage(SettingsKeys.currentStreak) private var currentStreak: Int = 0
    
    @State private var hideSkipButton: Bool = false
    
    var body: some View {
        VStack {
            Text(popUpMenuMessage)
                .font(.system(size: 64))
                .bold()
            
            Text("Current streak: \(currentStreak)")
                .font(.system(size: 16))
                .padding()
            
            if !hideSkipButton {
                Button(action: skipButtonPressed) {
                    Label("Skip", systemImage: "arrow.right")
                }
            }
            
            if hideSkipButton {
                Text("Are you sure you want to skip? Skipping will reset your streak.")
                    .foregroundStyle(.red)
                    .bold()
                    .padding()
                
                Button(action: secondSkipButtonPressed) {
                    Label("Skip", systemImage: "arrow.right")
                }
            }
        }
        // adding focusable() enables onKeyPress to work
        .focusable()
        // removing blue outline
        .focusEffectDisabled()
    }
    
    func skipButtonPressed() {
        hideSkipButton = true
    }
    
    func secondSkipButtonPressed() {
        appDelegate.resetStreak()
        appDelegate.incrementSkip()
        appDelegate.hideCoverWindow()
    }
}

#Preview {
    CoverView()
        .frame(minWidth: 500, minHeight: 500)
}
