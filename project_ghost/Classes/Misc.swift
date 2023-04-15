//
//  Misc.swift
//  project_wingman2
//
//  Created by John Perez on 4/8/23.
//

import Foundation
import SwiftUI
import KeyboardShortcuts

//https://www.reddit.com/r/SwiftUI/comments/va8ygf/translucent_window_with_transparent_title_bar_in/
// extension for window translucency
struct VisualEffectView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()

        view.blendingMode = .behindWindow
        view.state = .active
        view.material = .underWindowBackground

        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        
    }
}

//https://github.com/sindresorhus/KeyboardShortcuts
//functions for keyboard shortcuts implementation
@MainActor
final class AppState: ObservableObject {
    let chatDriver = ChatDriver()
    init() {
        KeyboardShortcuts.onKeyUp(for: .sendQ) { [self] in
            chatDriver.performResponse()
        }
        KeyboardShortcuts.onKeyUp(for: .sendCodingQ) { [self] in
            chatDriver.performResponse(codeMode: true)
        }
    }
}

extension KeyboardShortcuts.Name {
    static let sendQ = Self("sendQ")
    static let sendCodingQ = Self("sendCodingQ")
}


// extention to prevent window resizing
// https://developer.apple.com/forums/thread/719389
extension Scene {
    func windowResizabilityContentSize() -> some Scene {
        if #available(macOS 13.0, *) {
            return windowResizability(.contentSize)
        } else {
            return self
        }
    }
}
