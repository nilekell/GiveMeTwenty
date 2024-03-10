//
//  NSSoundExtension.swift
//  GiveMeTwenty
//
//  Created by Nile Kelly on 10/03/2024.
//

import AppKit

public extension NSSound {

    enum Sound: String, CaseIterable {
        case basso = "Basso"
        case blow = "Blow"
        case bottle = "Bottle"
        case frog = "Frog"
        case funk = "Funk"
        case glass = "Glass"
        case hero = "Hero"
        case morse = "Morse"
        case ping = "Ping"
        case pop = "Pop"
        case purr = "Purr"
        case sosumi = "Sosumi"
        case submarine = "Submarine"
        case tink = "Tink"
    }

    static func play(_ sound: Sound) {
        NSSound(named: NSSound.Name(sound.rawValue))?.play()
    }
}
