//
//  ContentView.swift
//  GiveMeTwenty
//
//  Created by Nile Kelly on 23/02/2024.
//

import SwiftUI
import UserNotifications

struct ConfigurationView: View {
    // Configure app to send reminders every x hours
    @AppStorage(SettingsKeys.reminderFrequency) var reminderFrequency: Int = 2
    
    // Configure app to send notifications or not
    @AppStorage(SettingsKeys.notificationsEnabled) var notificationsEnabled: Bool = false
    
    // Configure app to run when computer starts
    @AppStorage(SettingsKeys.runWhenComputerStarts) var runWhenComputerStarts: Bool = true
    
    // Configure app to appear in menu bar or not
    @AppStorage(SettingsKeys.showAppInMenuBar) var showAppInMenuBar: Bool = true
    
    // Configure message to show on popUp Menu & Notification
    @AppStorage(SettingsKeys.popUpMenuMessage) var popUpMenuMessage: String = "Time to give me twenty!"
    
    private let reminderFrequencyOptions = [1, 2, 3, 4, 5, 6, 7, 8]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Picker("Every", selection: $reminderFrequency) {
                    ForEach(reminderFrequencyOptions, id: \.self) {
                        Text($0.description)
                    }
                }
                .frame(width: 80)
                .clipped()
                
                Text("hours remind me.")
                
            }
            .padding()
            
            Toggle(isOn: $notificationsEnabled) {
                Text("Enable notifications")
            }
            .toggleStyle(.checkbox)
            .padding()
            
            Toggle(isOn: $runWhenComputerStarts) {
                Text("Run when computer starts")
            }
            .toggleStyle(.checkbox)
            .padding()
            
            Text("Edit the message to be shown in notifications and the pop up screen:")
                .padding(.horizontal)
            
            TextField(popUpMenuMessage, text: $popUpMenuMessage)
                .textFieldStyle(.roundedBorder)
                .frame(width: 150)
                .clipped()
                .padding()
            
            Toggle(isOn: $showAppInMenuBar) {
                Text("Show app in menu bar")
            }
            .toggleStyle(.checkbox)
            .padding()
            
            Button(action: {
                NSApp.terminate(self)
            }, label: {
                Text("Quit GiveMeTwenty")
            })
            .padding()
            
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        .padding()
    }
}

#Preview {
    ConfigurationView()
}
