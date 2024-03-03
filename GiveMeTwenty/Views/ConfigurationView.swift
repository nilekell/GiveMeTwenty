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
    @AppStorage(SettingsKeys.showTimerInMenuBar) var showTimerInMenuBar: Bool = true
    
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
            .onChange(of: notificationsEnabled, initial: true) { oldValue, newValue in
                requestNotificationPermissions(newValue)
                updateNotificationConfig(newValue)
            }
            
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
            
            Toggle(isOn: $showTimerInMenuBar) {
                Text("Show timer in menu bar")
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
        .frame(minWidth: 400, maxWidth: .infinity, minHeight: 400, maxHeight: .infinity, alignment: .topLeading)
        .padding()
    }
    
    func requestNotificationPermissions(_ notificationsEnabled: Bool) {
        if notificationsEnabled {
            // do this stuff when notifications have been enabled
            let center = UNUserNotificationCenter.current()
            center.getNotificationSettings { settings in
                if settings.authorizationStatus != .authorized {
                    center.requestAuthorization(options: [.alert, .sound]) { success, error in
                        if success {
                            print("Notification permissions granted.")
                        } else if let error {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        } else {
            print("skipping request for notification permissions, notifications disabled by user.")
        }
    }
    
    func updateNotificationConfig(_ notificationsEnabled: Bool) {
        let center = UNUserNotificationCenter.current()
        
        if notificationsEnabled {
            // do this stuff when notifications have been enabled
            let content = UNMutableNotificationContent()
            content.title = "GiveMeTwenty"
            content.subtitle = popUpMenuMessage
            content.sound = UNNotificationSound.default
            
            let reminderFrequencyInSeconds = reminderFrequency * 60 * 60
            let interval: TimeInterval = TimeInterval(reminderFrequencyInSeconds)
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: true)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request) { error in
                if let error {
                    print("Error scheduling notification: \(error.localizedDescription)")
                } else {
                    print("Added notification request.")
                }
            }
        } else {
            // disabling notifications
            center.removeAllDeliveredNotifications()
            center.removeAllPendingNotificationRequests()
            print("disabled notifications")
        }
    }
}

#Preview {
    ConfigurationView()
}
