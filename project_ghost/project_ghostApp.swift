//
//  project_wingman2App.swift
//  project_wingman2
//
//  Created by John Perez on 4/6/23.
//

import SwiftUI

// add comments to this code:
@main
struct project_ghost: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appState = AppState()
    @Environment(\.openWindow) private var openWindow
    
    var body: some Scene {
        WindowGroup("SpiritAI", id: "1") {
            ContentView()
        }
        .windowResizabilityContentSize()
        MenuBarExtra("", image: "ghost.spooky") {
            Button("Settings") {
                if appDelegate.allClosed {
                    openWindow(id: "1")
                }
                NSApp.activate(ignoringOtherApps: true)
            }
            Button("Quit") {
                NSApp.terminate(nil)
            }
        }
    }
}
