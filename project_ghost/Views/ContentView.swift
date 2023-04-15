//
//  ContentView.swift
//  project_wingman
//
//  Created by John Perez on 2/21/23.
//
import SwiftUI
import KeyboardShortcuts

struct ContentView: View {
    @State private var currentViewIndex: Int = Defaults.shared.get(forKey: "currentView") ?? 0
    var body: some View {
        ZStack {
            VStack {
                LazyHGrid(rows: [GridItem(.fixed(20), spacing: 20)], spacing: 20) {
                    ForEach(0..<3) { index in
                        GridItemView(index: index, selected: index == currentViewIndex)
                            .onTapGesture {
                                currentViewIndex = index
                                Defaults.shared.set(currentViewIndex,forKey: "currentView")
                            }
                    }
                }
                .frame(height: 70)
                Divider()
            }
            .offset(y: -200)
            VStack{
                Spacer()
                Group {
                    switch currentViewIndex {
                    case 0:
                        AboutView()
                    case 1:
                        SettingsView()
                    case 2:
                        AdvancedSettingsView()
                    default:
                        AboutView()
                    }
                }
                Spacer()
            }
        }
        .frame(width: 950, height: 500)
        .background(VisualEffectView())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
