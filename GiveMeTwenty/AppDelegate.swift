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
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupTimer()
        findCoverWindow()
        hideCoverWindow()
        hideTitleBarButtons()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
    
    func setupTimer(_ reminderFrequency: Int = 2) {
        // Cancel any existing timer before setting up a new one to avoid having multiple timers active simultaneously.
        if timer?.isValid != nil && timer?.isValid == true {
            timer?.invalidate()
        }
        
        print("setupTimer: \(reminderFrequency)")
        let reminderFrequencyInSeconds = reminderFrequency * 60 * 60
        
        timer = Timer(timeInterval: TimeInterval(reminderFrequencyInSeconds), target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        
        // Safely unwrap the timer before adding it to the run loop.
        if let timer = timer {
            RunLoop.main.add(timer, forMode: .common)
        } else {
            print("Failed to add timer to run loop.")
        }
    }
    
    @objc func timerAction() {
        // whenever timer triggers, show the cover window
        if let window = self.coverWindow {
            window.makeKeyAndOrderFront(nil)
        }
    }
    
    func findCoverWindow() {
        coverWindow = NSApplication.shared.windows.first(where: { $0.title == "CoverView" })
        coverWindow?.level = .popUpMenu
    }
    
    func hideCoverWindow() {
        if let window = self.coverWindow {
            window.orderOut(nil)
        }
    }
    
    func hideTitleBarButtons() {
        coverWindow?.standardWindowButton(.closeButton)?.isHidden = true
        coverWindow?.standardWindowButton(.miniaturizeButton)?.isHidden = true
        coverWindow?.standardWindowButton(.zoomButton)?.isHidden = true
    }
}
