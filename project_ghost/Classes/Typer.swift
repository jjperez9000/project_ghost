//
//  Typer.swift
//  project_wingman
//
//  Created by John Perez on 3/5/23.
//

import Foundation
import Cocoa

// https://stackoverflow.com/questions/49716420/adding-a-global-monitor-with-nseventmaskkeydown-mask-does-not-trigger
// https://stackoverflow.com/questions/62270679/swift-5-mac-app-screen-shot-copy-selected-area-to-clipboard

class Typer: ObservableObject {
    var allCodes = [Character: Int32]()
    init() {
        self.initAllCodes()
    }
    public func typeOutAnswer(answer: String) {
        for character in answer {
            var isShift: Bool = false
            var characterKeyCode = self.allCodes[character] ?? 0x00
            let source = CGEventSource(stateID: .hidSystemState)
            if characterKeyCode < 0 {
                characterKeyCode *= -1
                isShift = true
            }
            let keyDown = CGEvent(keyboardEventSource: source, virtualKey: UInt16(characterKeyCode) , keyDown: true)
            let keyUp = CGEvent(keyboardEventSource: source, virtualKey: UInt16(characterKeyCode) , keyDown: false)
            if isShift {
                keyDown!.flags = [.maskShift]
                keyUp!.flags = [.maskShift]
            } else {
                keyDown!.flags = []
                keyUp!.flags = []
            }
            keyDown?.post(tap: .cghidEventTap)
            keyUp?.post(tap: .cghidEventTap)
        }
    }
    
    // I hate this code, you hate this code. We all hate this code.
    // I scoured the internet, I parsed the docs, I asked GPT.
    // there is no other way. This is the *only* way.
    // unless it isn't? If it isn't please tell me.
    func initAllCodes() {
        self.allCodes["`"] = 0x32
        self.allCodes["-"] = 0x1B
        self.allCodes["="] = 0x18
        self.allCodes["["] = 0x21
        self.allCodes["]"] = 0x1E
        self.allCodes["\\"] = 0x2A
        self.allCodes[";"] = 0x29
        self.allCodes["'"] = 0x27
        self.allCodes[","] = 0x2B
        self.allCodes["."] = 0x2F
        self.allCodes["/"] = 0x2C
        self.allCodes["1"] = 0x12
        self.allCodes["2"] = 0x13
        self.allCodes["3"] = 0x14
        self.allCodes["4"] = 0x15
        self.allCodes["5"] = 0x17
        self.allCodes["6"] = 0x16
        self.allCodes["7"] = 0x1A
        self.allCodes["8"] = 0x1C
        self.allCodes["9"] = 0x19
        self.allCodes["0"] = 0x1D
        self.allCodes["a"] = 0x00
        self.allCodes["b"] = 0x0B
        self.allCodes["c"] = 0x08
        self.allCodes["d"] = 0x02
        self.allCodes["e"] = 0x0E
        self.allCodes["f"] = 0x03
        self.allCodes["g"] = 0x05
        self.allCodes["h"] = 0x04
        self.allCodes["i"] = 0x22
        self.allCodes["j"] = 0x26
        self.allCodes["k"] = 0x28
        self.allCodes["l"] = 0x25
        self.allCodes["m"] = 0x2E
        self.allCodes["n"] = 0x2D
        self.allCodes["o"] = 0x1F
        self.allCodes["p"] = 0x23
        self.allCodes["q"] = 0x0C
        self.allCodes["r"] = 0x0F
        self.allCodes["s"] = 0x01
        self.allCodes["t"] = 0x11
        self.allCodes["u"] = 0x20
        self.allCodes["v"] = 0x09
        self.allCodes["w"] = 0x0D
        self.allCodes["x"] = 0x07
        self.allCodes["y"] = 0x10
        self.allCodes["z"] = 0x06
        self.allCodes[" "] = 0x31
        self.allCodes["\u{7f}"] = 0x33 // backspace
        self.allCodes["\n"] = 0x24
        self.allCodes["?"] = 0x2C * -1
        self.allCodes["B"] = 0x0B * -1
        self.allCodes["C"] = 0x08 * -1
        self.allCodes["D"] = 0x02 * -1
        self.allCodes["E"] = 0x0E * -1
        self.allCodes["F"] = 0x03 * -1
        self.allCodes["G"] = 0x05 * -1
        self.allCodes["H"] = 0x04 * -1
        self.allCodes["I"] = 0x22 * -1
        self.allCodes["J"] = 0x26 * -1
        self.allCodes["K"] = 0x28 * -1
        self.allCodes["L"] = 0x25 * -1
        self.allCodes["M"] = 0x2E * -1
        self.allCodes["N"] = 0x2D * -1
        self.allCodes["O"] = 0x1F * -1
        self.allCodes["P"] = 0x23 * -1
        self.allCodes["Q"] = 0x0C * -1
        self.allCodes["R"] = 0x0F * -1
        self.allCodes["S"] = 0x01 * -1
        self.allCodes["T"] = 0x11 * -1
        self.allCodes["U"] = 0x20 * -1
        self.allCodes["V"] = 0x09 * -1
        self.allCodes["W"] = 0x0D * -1
        self.allCodes["X"] = 0x07 * -1
        self.allCodes["Y"] = 0x10 * -1
        self.allCodes["Z"] = 0x06 * -1
        self.allCodes["!"] = 0x12 * -1
        self.allCodes["@"] = 0x13 * -1
        self.allCodes["#"] = 0x14 * -1
        self.allCodes["$"] = 0x15 * -1
        self.allCodes["%"] = 0x17 * -1
        self.allCodes["^"] = 0x16 * -1
        self.allCodes["&"] = 0x1A * -1
        self.allCodes["*"] = 0x1C * -1
        self.allCodes["("] = 0x19 * -1
        self.allCodes[")"] = 0x1D * -1
        self.allCodes["~"] = 0x32 * -1
        self.allCodes["+"] = 0x18 * -1
        self.allCodes["_"] = 0x1B * -1
        self.allCodes["{"] = 0x21 * -1
        self.allCodes["|"] = 0x2A * -1
        self.allCodes["}"] = 0x1E * -1
        self.allCodes[":"] = 0x29 * -1
        self.allCodes["<"] = 0x2B * -1
        self.allCodes[">"] = 0x2F * -1
        self.allCodes["\""] = 0x27 * -1
    }
}

