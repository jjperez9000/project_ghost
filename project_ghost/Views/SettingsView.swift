//
//  SettingsView.swift
//  project_wingman2
//
//  Created by John Perez on 4/8/23.
//
import SwiftUI
import KeyboardShortcuts

// SettingsView is the view for the settings of the app
struct SettingsView: View {
    let appDelegate: AppDelegate = AppDelegate()
    @State private var hideIcon: Bool = Defaults.shared.get(forKey: "hideIcon") ?? false
    
    let textWidth: CGFloat = 200
    let objectWidth: CGFloat = 300
    let offsetDist: CGFloat = 170
    
    @State var token: String = Defaults.shared.get(forKey: "token") ?? ""
    @State var validToken: Bool = Defaults.shared.get(forKey: "validToken") ?? false
    
    @State var curImage: String = Defaults.shared.get(forKey: "validToken") ?? false ? "checkmark" : "xmark"
    @State var curColor: Color = Defaults.shared.get(forKey: "validToken") ?? false ? .green : .red
    
    @State private var tokenUnlocked = false
    
    @State private var selectedOption = Defaults.shared.get(forKey: "loadingAnimation") ?? 0
    let options = ["Ghost Animation", "Typing Animation"]
    
    var body: some View {
        VStack {
            // OpenAI API Key section
            HStack {
                Text("OpenAI API Key").frame(width: textWidth, alignment: .trailing)
                ZStack {
                    HStack {
                        // Toggle button to lock/unlock the TextField for API Key
                        Button(action: {
                            tokenUnlocked.toggle()
                        }) {
                            Label("", systemImage: tokenUnlocked ? "lock.open" : "lock").labelStyle(.iconOnly)
                        }
                        .frame(width: 40)
                        
                        // TextField to input OpenAI API Key
                        TextField("Paste you OpenAI API key here...", text: $token)
                            .onChange(of:  token) { _ in
                                Defaults.shared.set(token, forKey: "token")
                                Task.init() {
                                    curImage = "arrow.2.circlepath"
                                    curColor = .blue
                                    validToken = await ChatDriver.setToken()
                                    Defaults.shared.set(validToken, forKey: "validToken")
                                    curImage = validToken ? "checkmark": "xmark"
                                    curColor = validToken ? .green : .red
                                }
                            }
                            .textFieldStyle(RoundedBorderTextFieldStyle()).disabled(!tokenUnlocked)
                        
                    }
                    // Current status image for the API Key (valid/invalid)
                    Image(systemName: curImage)
                        .foregroundColor(curColor)
                        .offset(x: offsetDist)
                }.frame(width: objectWidth)
            }.padding(.trailing, 100)
            
            Link("(how do I get an api key?)", destination: URL(string: "https://help.openai.com/en/articles/4936850-where-do-i-find-my-secret-api-key")!).padding(.bottom,10)
            
            
            // Activation Sequence section
            HStack {
                Text("Generic Activation Sequence").frame(width: textWidth, alignment: .trailing)
                ZStack {
                    Form {
                        KeyboardShortcuts.Recorder("", name: .sendQ)
                    }.frame(width: objectWidth)
                    MenuButtonView(info: "Sends your raw prompt to GPT")
                        .offset(x: offsetDist)
                }
                
            }
            .padding(.trailing, 100)
            HStack {
                Text("Coding Activation Sequence").frame(width: textWidth, alignment: .trailing)
                ZStack {
                    Form {
                        KeyboardShortcuts.Recorder("", name: .sendCodingQ)
                    }.frame(width: objectWidth)
                    MenuButtonView(info: "GPT will try to respond only with code")
                        .offset(x: offsetDist)
                }
                
            }
            .padding(.trailing, 100)
    
            // Output Mode section
            HStack {
                Text("Output Mode").frame(width: textWidth, alignment: .trailing)
                ZStack {
                    Picker("", selection: $selectedOption) {
                        ForEach(options.indices, id: \.self) { index in
                            Text(options[index]).tag(index)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: selectedOption) { _ in
                        Defaults.shared.set(selectedOption, forKey: "loadingAnimation")
                    }
                    
                    // Info button with a description of each output mode
                    MenuButtonView(info: "Ghost Animation shows a ghost\nnext to cursor while loading\nTyping Animation will type out \na loading animation and the response")
                        .offset(x: offsetDist)
                }.frame(width: objectWidth)
            }
            .padding(.trailing, 100)
            
            // Hide Dock Icon section
            HStack {
                Text("Hide Dock Icon").frame(width: textWidth, alignment: .trailing)
                HStack{
                    Toggle("", isOn: $hideIcon)
                        .padding(.bottom, 5).padding(.leading, 5)
                        .frame(alignment: .top)
                        .onChange(of: hideIcon) { _ in
                            Defaults.shared.set(hideIcon, forKey: "hideIcon")
                            appDelegate.updateActivationPolicy(to: hideIcon ? .accessory : .regular)
                        }
                }.frame(width: objectWidth, alignment: .topLeading)
                
            }
            .padding(.trailing, 100)

            
        }.padding()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

