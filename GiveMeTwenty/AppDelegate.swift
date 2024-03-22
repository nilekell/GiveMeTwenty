//
//  AppDelegate.swift
//  GiveMeTwenty
//
//  Created by Nile Kelly on 10/03/2024.
//

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    var timer: Timer?
    var coverWindow: NSWindow?
    var configurationWindow: NSWindow?
    
    @AppStorage(SettingsKeys.reminderFrequency) private var reminderFrequency: Int = 2
    @AppStorage(SettingsKeys.isFirstAppOpen) private var isFirstAppOpen: Bool = true
    @AppStorage(SettingsKeys.coverViewDuration) private var coverViewDuration: Double = 60.0
    @AppStorage(SettingsKeys.selectedSound) private var selectedSound: String = NSSound.Sound.basso.rawValue
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        setDefaultSettingsValues()
        
        setupConfigurationWindow()
        hideConfigurationWindow()
        
        setupTimer()
        
        setupCoverWindow()
        hideCoverWindow()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
    
    func setDefaultSettingsValues() {
        // uncomment this line and re-run app to reset all app settings
        // UserDefaults.standard.setValue(true, forKey: SettingsKeys.isFirstAppOpen)
        
        if isFirstAppOpen {
            print("Setting default values for first time.")
            let defaults = UserDefaults.standard
            
            defaults.setValue(false, forKey: SettingsKeys.isFirstAppOpen)
            
            defaults.setValue(2, forKey: SettingsKeys.reminderFrequency)
            defaults.setValue(false, forKey: SettingsKeys.runWhenComputerStarts)
            defaults.setValue(true, forKey: SettingsKeys.showTimerInMenuBar)
            defaults.setValue("Time to give me twenty!", forKey: SettingsKeys.popUpMenuMessage)
            defaults.setValue(false, forKey: SettingsKeys.notificationsEnabled)
            defaults.setValue(60.0, forKey: SettingsKeys.coverViewDuration)
            defaults.setValue(NSSound.Sound.basso.rawValue, forKey: SettingsKeys.selectedSound)
        }
    }
    
    func setupTimer() {
        // Cancel any existing timer before setting up a new one to avoid having multiple timers active simultaneously.
        cancelTimer()
        
        let reminderFrequencyInSeconds = reminderFrequency * 60 * 60
        // let reminderFrequencyInSeconds = 5
        
        timer = Timer(timeInterval: TimeInterval(reminderFrequencyInSeconds), target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        
        // Safely unwrap the timer before adding it to the run loop.
        if let timer = timer {
            RunLoop.main.add(timer, forMode: .common)
        } else {
            print("Failed to add timer to run loop.")
        }
    }
    
    func cancelTimer() {
        if timer?.isValid != nil && timer?.isValid == true {
            timer?.invalidate()
        }
    }
    
    func snoozeTimer(forPeriod: SnoozePeriod) {
        
        // cancel any existing timer
        cancelTimer()
        
        var snoozePeriodInSeconds: Int?
        
        switch forPeriod {
            case .thirty:
            snoozePeriodInSeconds = 30 * 60
            case .one:
                snoozePeriodInSeconds = 1 * 60 * 60
            case .two:
                snoozePeriodInSeconds = 2 * 60 * 60
            case .four:
                snoozePeriodInSeconds = 4 * 60 * 60
            case .untilTomorrow:
                let calendar = Calendar.current
                if let startOfTomorrow = calendar.nextDate(after: Date.now, matching: DateComponents(hour: 0, minute: 0, second: 0), matchingPolicy: .nextTime) {
                    // Calculate the difference in seconds between now and the start of tomorrow
                    let now = Date()
                    snoozePeriodInSeconds = Int(startOfTomorrow.timeIntervalSince(now))
                }
        }
        
        // force unwrapping as every case in SnoozePeriod has been met in switch statement
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(snoozePeriodInSeconds!)) {
            self.setupTimer()
        }
        
    }
    
    
    @objc func timerAction() {
        // whenever timer triggers, show the cover window
        if let window = self.coverWindow {
            if window.isKeyWindow {
                // do not make window key, active, main, or at the front, if it already is being displayed
                // NOTE: if user clicks on another application or window, then isKeyWindow will be false
                return
            }
            
            // bring window to front
            window.makeKeyAndOrderFront(nil)
            // focus window (allows window to be interacted with, without having to click on it first)
            NSApplication.shared.activate(ignoringOtherApps: true)
            
            setupCoverWindow()
            
            print("CoverView presented for: \(coverViewDuration)")
            // automatically closing screen after coverViewDuration
            DispatchQueue.main.asyncAfter(deadline: .now() + coverViewDuration) {
                if let selectedSoundEnum = NSSound.Sound(rawValue: self.selectedSound) {
                    NSSound.play(selectedSoundEnum)
                }
                self.hideCoverWindow()
                print("closed CoverView after: \(self.coverViewDuration)")
            }
        }
    }
    
    func setupConfigurationWindow() {
        configurationWindow = NSApplication.shared.windows.first(where: { $0.title == "ConfigurationView" })
        configurationWindow?.level = .popUpMenu
        configurationWindow?.isReleasedWhenClosed = false
    }
    
    func hideConfigurationWindow() {
        if let window = self.configurationWindow {
            window.close()
        }
    }
    
    func setupCoverWindow() {
        coverWindow = NSApplication.shared.windows.first(where: { $0.title == "CoverView" })
        coverWindow?.standardWindowButton(.closeButton)?.isHidden = true
        coverWindow?.standardWindowButton(.miniaturizeButton)?.isHidden = true
        coverWindow?.standardWindowButton(.zoomButton)?.isHidden = true
        coverWindow?.level = .popUpMenu
    }
    
    func hideCoverWindow() {
        if let window = self.coverWindow {
            window.close()
        }
    }
}

enum SnoozePeriod {
    case thirty
    case one
    case two
    case four
    case untilTomorrow
}
