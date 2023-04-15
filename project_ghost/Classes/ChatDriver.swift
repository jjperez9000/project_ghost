//
//  ChatDriver.swift
//  project_wingman2
//
//  Created by John Perez on 4/6/23.
//

import OpenAISwift
import AppKit

class ChatDriver {
    private let typer = Typer()
    
    private var chat: [ChatMessage] = [ChatMessage(role: .system, content: "You are a helpful assistant")]
    private var codeChat: [ChatMessage]
    
    init() {
        self.codeChat = [ChatMessage(role: .system, content: codingProompt)]
    }
    
    func performResponse(codeMode: Bool = false) {
        // Define an actor to safely handle concurrent updates to answer and isLoading properties
        actor AnswerLoader {
            private(set) var answer: String = ""
            private(set) var isLoading: Bool = true
            
            func setAnswer(_ value: String) {
                self.answer = value
            }
            
            func setLoading(_ value: Bool) {
                self.isLoading = value
            }
        }
        
        let pasteboard = NSPasteboard.general
        if let string = pasteboard.string(forType: .string) {
            
            let loadingAnimation = Defaults.shared.get(forKey: "loadingAnimation") ?? 0
            
            // get the answer
            if loadingAnimation == 0 {
                //ghost animation
                Task {
                    if loadingAnimation == 0 {
                        AppDelegate.shared?.summonGhost()
                        let fetchedAnswer = await self.submitOpenAiPrompt(question: string, codeMode: codeMode)
                        pasteboard.clearContents()
                        pasteboard.setString(fetchedAnswer, forType: .string)
                        AppDelegate.shared?.hideGhost() // what does this code do?
                    }
                }
            } else {
                // send prompt
                // Create an instance of the AnswerLoader actor
                let answerLoader = AnswerLoader()
                Task {
                    let fetchedAnswer = await self.submitOpenAiPrompt(question: string, codeMode: codeMode)
                    await answerLoader.setAnswer(fetchedAnswer)
                    await answerLoader.setLoading(false)
                }
                // start typing animation
                Task {
                    // while the answer is still loading, print the loading animation
                    while await answerLoader.isLoading {
                        for _ in 0..<3 {
                            self.typer.typeOutAnswer(answer: ".")
                            try await Task.sleep(for: .seconds(0.2))
                        }
                        // Delete the previous animation frame
                        self.typer.typeOutAnswer(answer: "\u{7f}\u{7f}\u{7f}")
                        try await Task.sleep(for: .seconds(0.2))
                    }
                    self.typer.typeOutAnswer(answer: await answerLoader.answer)
                }
            }
        }
    }
    
    // function to verify if the given API Key works
    // this was easier than adding a special caveat to the defaults function.
    // surely this will never be an issue in the future :D
    static func setToken() async -> Bool {
        let openAI = OpenAISwift(authToken: Defaults.shared.get(forKey: "token") ?? "")
        let chat: [ChatMessage] = [ChatMessage(role: .system, content: "You are a helpful assistant")]
        do {
            let _ = try await openAI.sendChat(with: chat)
            return true
        } catch {
            return false
        }
    }
    
    private func submitOpenAiPrompt(question: String, codeMode: Bool = false) async -> String {
        let openAI: OpenAISwift = OpenAISwift(authToken: Defaults.shared.get(forKey: "token") ?? "")
        do {
            var result: OpenAI<MessageResult>
            if codeMode {
                codeChat.append(ChatMessage(role: .user, content: question))
                result = try await openAI.sendChat(with: codeChat)
                codeChat.append(ChatMessage(role: .assistant, content: result.choices?.first?.message.content ?? "(there is no response)"))
            } else {
                chat.append(ChatMessage(role: .user, content: question))
                result = try await openAI.sendChat(
                    with: chat,
                    temperature: Defaults.shared.get(forKey: "temperature") ?? 1.0,
                    topProbabilityMass: Defaults.shared.get(forKey: "top_p") ?? 1.0,
                    maxTokens: Defaults.shared.get(forKey: "maxTokens") ?? 5000 == 5000 ? nil : Int(Defaults.shared.get(forKey: "maxTokens") ?? 5000),
                    presencePenalty: Defaults.shared.get(forKey: "enablePP") ?? false ? Defaults.shared.get(forKey: "presencePenalty") : nil,
                    frequencyPenalty: Defaults.shared.get(forKey: "enableFP") ?? false ? Defaults.shared.get(forKey: "fequencyPenalty") : nil
                )
                chat.append(ChatMessage(role: .assistant, content: result.choices?.first?.message.content ?? "(there is no response)"))
            }
            
            return result.choices?.first?.message.content ?? "something bronk"
        } catch {
            return "invalid api token"
        }
    }
    
    private let codingProompt: String = """
                            You are an AI who solves coding problems.
                            Do your best to respond in the language that the question was asked in.
                            You will be given code. Solve the problem presented to the best of your knowledge. Respond only with code.
                            for example:
                            prompt: // write hello world in c++
                            resopnse:
                            // write hello world in c++
                            #include <iostream>
                            #include <string>
                            
                            int main() {
                                std::string input;
                                std::cout << "Enter a string: ";
                                std::cin >> input;
                                std::cout << "You entered: " << input << std::endl;
                                return 0;
                            }
                            prompt:
                            // add comments to this code file:
                            struct AboutView: View {
                            var body: some View {
                                VStack{
                                    Text("Welcome to Haunted Mac")
                                        .font(.system(.title))
                                        .padding(.bottom, 20)
                                    Text("This app allows you to get answers from GPT anywhere on your Mac by reading and writing to your clipboard.")
                                        .font(.system(size:15))
                                        .padding(.bottom, 10)
                                }
                            }
                            }
                            
                            struct AboutView_Previews: PreviewProvider {
                            static var previews: some View {
                                AboutView()
                            }
                            }
                            response:
                            // AboutView is a SwiftUI view that displays information about the Haunted Mac app.
                            struct AboutView: View {
                                // The main body of the view is defined here.
                                var body: some View {
                                    VStack {
                                        // Display a welcome message with the app's title.
                                        Text("Welcome to Haunted Mac")
                                            .font(.system(.title))
                                            .padding(.bottom, 20)
                            
                                        // Display a brief description of the app's purpose.
                                        Text("This app allows you to get answers from GPT anywhere on your Mac by reading and writing to your clipboard.")
                                            .font(.system(size:15))
                                            .padding(.bottom, 10)
                                    }
                                }
                            }
                            
                            // AboutView_Previews is a SwiftUI preview provider for the AboutView.
                            struct AboutView_Previews: PreviewProvider {
                                // Define the previews of the AboutView.
                                static var previews: some View {
                                    AboutView()
                                }
                            }
                            prompt:
                            """
}
