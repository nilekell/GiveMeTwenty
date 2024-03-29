//
//  AppDelegate.swift
//  GiveMeTwenty
//
//  Created by Nile Kelly on 10/03/2024.
//

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    private var timer: Timer?
    var configurationWindow: NSWindow?
    var coverWindow: NSWindow?
    private var coverViewIsShowing: Bool = false
    
    @AppStorage(SettingsKeys.reminderFrequency) private var reminderFrequency: Int = 2
    @AppStorage(SettingsKeys.isFirstAppOpen) private var isFirstAppOpen: Bool = true
    @AppStorage(SettingsKeys.coverViewDuration) private var coverViewDuration: Double = 60.0
    @AppStorage(SettingsKeys.selectedSound) private var selectedSound: String = NSSound.Sound.basso.rawValue
    @AppStorage(SettingsKeys.currentStreak) private var currentStreak: Int = 0
    @AppStorage(SettingsKeys.skips) private var skips: Int = 0
    @AppStorage(SettingsKeys.sets) private var sets: Int = 0
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        setDefaultSettingsValues()
        
        setupConfigurationWindow()
        
        setupTimer()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
    
    private func setDefaultSettingsValues() {
        // uncomment this line and re-run app to reset all app settings
        // UserDefaults.standard.setValue(true, forKey: SettingsKeys.isFirstAppOpen)
        
        let defaults = UserDefaults.standard
        
        if isFirstAppOpen {
            print("Setting default values for first time.")
            defaults.setValue(false, forKey: SettingsKeys.isFirstAppOpen)
            defaults.setValue(0, forKey: SettingsKeys.currentStreak)
            defaults.setValue(0, forKey: SettingsKeys.skips)
            defaults.setValue(0, forKey: SettingsKeys.sets)
            defaults.setValue(2, forKey: SettingsKeys.reminderFrequency)
            defaults.setValue(false, forKey: SettingsKeys.runWhenComputerStarts)
            defaults.setValue(true, forKey: SettingsKeys.showTimerInMenuBar)
            defaults.setValue("Time to give me twenty!", forKey: SettingsKeys.popUpMenuMessage)
            defaults.setValue(false, forKey: SettingsKeys.notificationsEnabled)
            defaults.setValue(60.0, forKey: SettingsKeys.coverViewDuration)
            defaults.setValue(NSSound.Sound.basso.rawValue, forKey: SettingsKeys.selectedSound)
        }
        
        print("isFirstAppOpen: \(defaults.bool(forKey: SettingsKeys.isFirstAppOpen))")
        print("currentStreak: \(defaults.integer(forKey: SettingsKeys.currentStreak))")
        print("skips: \(defaults.integer(forKey: SettingsKeys.skips))")
        print("sets: \(defaults.integer(forKey: SettingsKeys.sets))")
        print("reminderFrequency: \(defaults.integer(forKey: SettingsKeys.reminderFrequency))")
        print("runWhenComputerStarts: \(defaults.bool(forKey: SettingsKeys.runWhenComputerStarts))")
        print("showTimerInMenuBar: \(defaults.bool(forKey: SettingsKeys.showTimerInMenuBar))")
        print("popUpMenuMessage: \(defaults.string(forKey: SettingsKeys.popUpMenuMessage) ?? "N/A")")
        print("notificationsEnabled: \(defaults.bool(forKey: SettingsKeys.notificationsEnabled))")
        print("coverViewDuration: \(defaults.double(forKey: SettingsKeys.coverViewDuration))")
        print("selectedSound: \(defaults.string(forKey: SettingsKeys.selectedSound) ?? "N/A")")
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
    
    @objc private func timerAction() {
        if coverViewIsShowing {
            // do not make window key, active, main, or at the front, if it already is being displayed
            // NOTE: if user clicks on another application or window, then isKeyWindow will be false
            print("timerAction() skipped, as CoverView already being shown")
            return
        }
        
        // whenever timer triggers, show the cover window
        showCoverWindow()
        
        print("CoverView presented for: \(coverViewDuration)s")
        // automatically closing screen after coverViewDuration
        DispatchQueue.main.asyncAfter(deadline: .now() + coverViewDuration) {
            if let selectedSoundEnum = NSSound.Sound(rawValue: self.selectedSound) {
                NSSound.play(selectedSoundEnum)
            }
            
            self.hideCoverWindow()
            self.incrementStreak()
            
            print("closed CoverView after: \(self.coverViewDuration)")
        }
    }
    
    private func cancelTimer() {
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
                    let now = Date.now
                    snoozePeriodInSeconds = Int(startOfTomorrow.timeIntervalSince(now))
                }
        }
        
        // force unwrapping as every case in SnoozePeriod has been met in switch statement
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(snoozePeriodInSeconds!)) {
            self.setupTimer()
        }
    }
    
    private func setupConfigurationWindow() {
        configurationWindow = NSApplication.shared.windows.first(where: { $0.title == "ConfigurationView" })
        configurationWindow?.level = .normal
        configurationWindow?.isReleasedWhenClosed = false
    }
    
    private func hideConfigurationWindow() {
        if let window = self.configurationWindow {
            window.close()
        }
    }
    
    private func showCoverWindow() {
        // set variable to track if cover view is being displayed
        coverViewIsShowing = true
        
        let screenSize = NSScreen.main!.frame
        let hostingController = NSHostingController(rootView: CoverView()
            .frame(minWidth: screenSize.size.width, minHeight: screenSize.size.height)
            .background(BlurEffectView().ignoresSafeArea())
            .frame(minWidth: screenSize.size.width, minHeight: screenSize.size.height)
            .environmentObject(self))
        
        coverWindow = NSWindow(contentViewController: hostingController)
        coverWindow?.titleVisibility = .hidden
        coverWindow?.titlebarAppearsTransparent = true
        coverWindow?.titlebarSeparatorStyle = .none
        coverWindow?.standardWindowButton(.closeButton)?.isHidden = true
        coverWindow?.standardWindowButton(.miniaturizeButton)?.isHidden = true
        coverWindow?.standardWindowButton(.zoomButton)?.isHidden = true
        coverWindow?.level = .popUpMenu
        coverWindow?.isReleasedWhenClosed = false
        
        // bring window to front
        coverWindow?.makeKeyAndOrderFront(nil)
        // focus window (allows window to be interacted with, without having to click on it first)
        NSApplication.shared.activate(ignoringOtherApps: true)
    }
    
    func hideCoverWindow() {
        if let window = self.coverWindow {
            window.close()
            coverViewIsShowing = false
        }
    }
    
    func resetStreak() {
        currentStreak = 0
    }
    
    func incrementStreak() {
        currentStreak += 1
        sets += 1
    }
    
    func incrementSkip() {
        skips += 1
    }
}
