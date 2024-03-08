//
//  BlurEffectView.swift
//  GiveMeTwenty
//
//  Created by Nile Kelly on 08/03/2024.
//

import SwiftUI
import Foundation

struct BlurEffectView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        // called when view is first created
        let view = NSVisualEffectView()

        view.blendingMode = .behindWindow
        view.state = .active
        view.material = .underWindowBackground

        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        // called when view state changes
    }
}
