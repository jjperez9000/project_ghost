//
//  project_wingman2App.swift
//  project_wingman2
//
//  Created by John Perez on 4/6/23.
//

import SwiftUI

@main
struct project_ghost: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appState = AppState()
    @Environment(\.openWindow) private var openWindow
    
    var body: some Scene {
        WindowGroup("Haunted Mac", id: "1") {
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
            Button("Exit") {
                //https://stackoverflow.com/questions/70160320/how-can-i-close-quit-my-app-in-macos-swiftui-life-cycle
                NSApp.terminate(nil)
            }
        }
    }
}
