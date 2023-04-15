//
//  AdvancedSettingsView.swift
//  project_wingman2
//
//  Created by John Perez on 4/9/23.
//
import SwiftUI

struct AdvancedSettingsView: View {
    let textWidth: CGFloat = 200
    let objectWidth: CGFloat = 300
    let offsetDist: CGFloat = 170
    
    @State var temperature: Double = Defaults.shared.get(forKey: "temperature") ?? 1.0
    @State var top_p: Double = Defaults.shared.get(forKey: "top_p") ?? 1.0
    @State var maxTokens: Int = Defaults.shared.get(forKey: "maxTokens") ?? 5000
    @State var presencePenalty: Double = Defaults.shared.get(forKey: "presencePenalty") ?? 0.0
    @State var enablePP: Bool = Defaults.shared.get(forKey: "enablePP") ?? false
    @State var frequencyPenalty: Double = Defaults.shared.get(forKey: "frequencyPenalty") ?? 0.0
    @State var enableFP: Bool = Defaults.shared.get(forKey: "enableFP") ?? false
    
    @State var hideThing = false
    
    var body: some View {
        VStack {
            settingItem(title: "Temperature",
                        value: $temperature,
                        range: 0...2,
                        step: 0.05,
                        key: "temperature",
                        info: "Determines how consistent the\nresponse is to any given prompt is.\nA lower value means a more consistent\nresponse.").zIndex(1)
            
            settingItem(title: "Top_p",
                        value: $top_p,
                        range: 0...2,
                        step: 0.05,
                        key: "top_p",
                        info: "Very similar to temperature.")
            
            Text("It is generally advised to only alter one of the above  values at a time.")
                .font(.footnote)
                .padding(.bottom, 10)
            
            settingItem(title: "Max Tokens",
                        value: Binding(
                            get: { Double(maxTokens) },
                            set: { maxTokens = Int($0.rounded()) }
                        ),
                        range: 100...5000,
                        step: 100,
                        key: "maxTokens",
                        info: "Sets the max length of response.")
            
            settingItem(title: "Presence Penalty",
                        value: $presencePenalty,
                        range: -2...2,
                        step: 0.1,
                        key: "presencePenalty",
                        info: "Determines how much GPT is\nencouraged to stay on topic",
                        enableToggle: $enablePP)
            
            settingItem(title: "Frequency Penalty",
                        value: $frequencyPenalty,
                        range: -2...2,
                        step: 0.1,
                        key: "frequencyPenalty",
                        info: "Determines how likely GPT is\nto repeat itself.",
                        enableToggle: $enableFP)
        }
        .padding()
    }
    
    func settingItem(title: String, value: Binding<Double>, range: ClosedRange<Double>, step: Double, key: String, info: String, enableToggle: Binding<Bool>? = nil) -> some View {
        
        
        HStack {
            Text(title)
                .frame(width: textWidth, alignment: .trailing)
            
            ZStack {
                HStack {
                    if let toggle = enableToggle {
                        Toggle("", isOn: toggle)
                            .frame(width: 40)
                            .offset(x: 2, y: -2)
                    }
                    
                    Text(value.wrappedValue < 4999 ?
                         range.upperBound > 1000 ?
                         String(format: "%.0f", value.wrappedValue) :
                            String(format: "%.2f", value.wrappedValue) :
                            "∞")
                    .frame(width: 40)
                    .disabled(enableToggle?.wrappedValue == false)
                    Slider(value: value, in: range, step: step)
                        .onChange(of: value.wrappedValue) { _ in
                            Defaults.shared.set(value.wrappedValue, forKey: key)
                            print(key, Defaults.shared.get(forKey: key) ?? 1.0)
                        }
                        .disabled(enableToggle?.wrappedValue == false)
                        .padding(.trailing, 10)
                    MenuButtonView(info: info)
                }
                
                
                
            }
            .frame(width: objectWidth)
        }
        .padding(.trailing, 100)
    }
}

struct AdvancedSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedSettingsView()
    }
}
