//
//  ContentView.swift
//  GiveMeTwenty
//
//  Created by Nile Kelly on 23/02/2024.
//

import SwiftUI
import UserNotifications
import LaunchAtLogin

struct ConfigurationView: View {
    
    @EnvironmentObject private var appDelegate: AppDelegate
    
    // Configure app to send reminders every x hours
    @AppStorage(SettingsKeys.reminderFrequency) var reminderFrequency: Int = 2
    
    // Configure app to send notifications or not
    @AppStorage(SettingsKeys.notificationsEnabled) var notificationsEnabled: Bool = false
    
    // Configure timer to appear in menu bar or not
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
                .onChange(of: reminderFrequency) { oldValue, newValue in
                    updateTimerConfig()
                    updateNotificationConfig(notificationsEnabled, popUpMenuMessage, newValue)
                }
                
                Text("hours remind me.")
                
            }
            .padding()
            
            Toggle(isOn: $notificationsEnabled) {
                Text("Enable notifications")
            }
            .toggleStyle(.checkbox)
            .padding()
            .onChange(of: notificationsEnabled) { oldValue, newValue in
                requestNotificationPermissions(newValue)
                updateNotificationConfig(newValue, popUpMenuMessage, reminderFrequency)
            }
            
            
            Text("Edit the message to be shown in notifications and the pop up screen:")
                .padding(.horizontal)
                .padding(.top)
            
            TextField(popUpMenuMessage, text: $popUpMenuMessage)
                .textFieldStyle(.roundedBorder)
                .frame(width: 150)
                .clipped()
                .padding(.horizontal)
                .padding(.bottom)
                .padding(.bottom)
                .onChange(of: popUpMenuMessage) { oldValue, newValue in
                    updateNotificationConfig(notificationsEnabled, newValue, reminderFrequency)
                }
            
            HStack (spacing: 0) {
                Text("Show cover screen for ")
                
                Text("\(Int(coverViewDuration))")
                    .foregroundColor(isEditing ? .red : .blue)
                
                Text("seconds.")
                    .padding(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 0))
            }
            .padding(.horizontal)
            
            Slider(
                value: $coverViewDuration,
                in: 0...300,
                onEditingChanged: { editing in
                    isEditing = editing
                }
            )
            .frame(maxWidth: 250)
            .padding(.horizontal)
            .padding(.bottom)
            
            Toggle(isOn: $showTimerInMenuBar) {
                Text("Show timer in menu bar")
            }
            .toggleStyle(.checkbox)
            .padding()
            
            LaunchAtLogin.Toggle("Run when computer starts")
                .padding()
            
            Button(action: {
                NSApp.terminate(self)
            }, label: {
                Text("Quit GiveMeTwenty")
            })
            .padding()
            
        }
        .frame(minWidth: 500, maxWidth: .infinity, minHeight: 500, maxHeight: .infinity, alignment: .topLeading)
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
    
    func updateNotificationConfig(_ notisEnabled: Bool, _ message: String, _ reminderFreq: Int) {
        
        print("notisEnabled: \(notisEnabled), message: \(message), reminderFreq: \(reminderFreq)")
        
        let center = UNUserNotificationCenter.current()
        
        if notisEnabled {
            // do this stuff when notifications have been enabled
            let content = UNMutableNotificationContent()
            content.title = "GiveMeTwenty"
            content.subtitle = message
            content.sound = UNNotificationSound.default
            
            let reminderFrequencyInSeconds = reminderFreq * 60 * 60
            let interval: TimeInterval = TimeInterval(reminderFrequencyInSeconds)
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: true)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            center.removeAllDeliveredNotifications()
            center.removeAllPendingNotificationRequests()
            
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
    
    func updateTimerConfig() {
        appDelegate.setupTimer()
    }
}

#Preview {
    ConfigurationView()
}
