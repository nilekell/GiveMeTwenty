//
//  ContentView.swift
//  GiveMeTwenty
//
//  Created by Nile Kelly on 23/02/2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    let reminderFrequencies = [1, 2, 3, 4, 5, 6, 7, 8]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Picker("Every", selection: $settingsViewModel.reminderFrequency) {
                    ForEach(reminderFrequencies, id: \.self) {
                        Text($0.description)
                    }
                }
                .frame(width: 80)
                .clipped()
                
                Text("hours take a break.")
                
            }
            .padding()
            
            Toggle(isOn: $settingsViewModel.notificationsEnabled) {
                Text("Enable notifications")
            }
            .toggleStyle(.checkbox)
            .padding()
            
            Toggle(isOn: $settingsViewModel.runWhenComputerStarts) {
                Text("Run when computer starts")
            }
            .toggleStyle(.checkbox)
            .padding()
            
            Toggle(isOn: $settingsViewModel.showAppInMenuBar) {
                Text("Show app in menu bar")
            }
            .toggleStyle(.checkbox)
            .padding()
            
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        .padding()
    }
}

#Preview {
    ContentView()
        .environmentObject(SettingsViewModel())
}
