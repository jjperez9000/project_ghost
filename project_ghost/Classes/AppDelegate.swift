//
//  AppDelegate.swift
//  project_wingman2
//
//  Created by John Perez on 4/15/23.
//

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    //start hack https://christiantietze.de/posts/2019/06/observe-nswindow-changes/
    static var shared: AppDelegate?
    
    private var windowsAfterLastUpdate: [NSWindow] = []
    var allClosed = false
    
    func applicationDidUpdate(_ notification: Notification) {
        self.windowsAfterLastUpdate = visibleRegularWindows()
    }
    
    func applicationWillUpdate(_ notification: Notification) {
        let currentWindows = visibleRegularWindows()
        guard currentWindows != self.windowsAfterLastUpdate else { return }
        
        if windowsAfterLastUpdate.isEmpty && !currentWindows.isEmpty {
            allClosed = false
        } else if !windowsAfterLastUpdate.isEmpty && currentWindows.isEmpty {
            allClosed = true
        }
    }
    
    private func visibleRegularWindows() -> [NSWindow] {
        return NSApp.windows
            .filter { false == ["NSStatusBarWindow"].contains($0.className) }
            .filter { $0.isVisible }
    }
    //end
    
    
    // Ghost window setup
    var window: NSWindow!
    func applicationWillFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(Defaults.shared.get(forKey: "hideIcon") ?? false ? .accessory : .regular)
        
        // Create the new window
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 100, height: 100),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        
        // Set the content of the new window to the SwiftUI view
        window.contentView = NSHostingView(rootView: GhostView())
        
        window.isOpaque = false // transparent
        window.backgroundColor = NSColor(red: 1, green: 0.5, blue: 0.5, alpha: 0.0) // actually transparent
        window.styleMask = .borderless //no menubar
        window.ignoresMouseEvents = true // can't be clicked
        window.level = .floating // always up front
        window.orderOut(nil) // hide on creation
        
        AppDelegate.shared = self
        let eventMask: NSEvent.EventTypeMask = [.mouseMoved, .leftMouseDragged, .rightMouseDragged, .otherMouseDragged]
        NSEvent.addGlobalMonitorForEvents(matching: eventMask) { _ in
            let mouseLocation = NSEvent.mouseLocation
            self.moveWindow(x: mouseLocation.x, y :mouseLocation.y)
        }
    }
    
    func moveWindow(x: CGFloat, y: CGFloat) {
        let newPosition = NSPoint(x: x+15, y: y-30)
        window.setFrameOrigin(newPosition)
    }
    
    // show or hide the app Icon
    func updateActivationPolicy(to policy: NSApplication.ActivationPolicy) {
        NSApp.setActivationPolicy(policy)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    // control the ghost that chases the cursor
    func summonGhost() {
        DispatchQueue.main.async {
            self.window.orderFront(nil)
        }
    }
    func hideGhost() {
        DispatchQueue.main.async {
            self.window.orderOut(nil)
        }
    }
}
