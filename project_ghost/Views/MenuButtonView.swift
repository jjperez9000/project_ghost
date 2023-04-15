//
//  HoverButton.swift
//  project_wingman2
//
//  Created by John Perez on 4/8/23.
//

import SwiftUI



struct MenuButtonView: View {
    @Environment(\.colorScheme) var colorScheme
    let info: String
    @State var showHelp = false
    @State private var textHeight: CGFloat = 0
    
    var body: some View {
        Label("", systemImage: "info.circle").labelStyle(.iconOnly)
            .background(GeometryReader { iconGeo in
                if showHelp {
                    Text(info)
                        .padding(10)
                        .padding(.leading, 25)
                        .background(colorScheme == .dark ? Color(red:0.3, green: 0.3, blue: 0.3).opacity(0.8) : Color.white.opacity(0.8))
                        .cornerRadius(10)
                        .shadow(radius: 10)
                        .offset(x: -10, y: iconGeo.size.height/2 - textHeight/2)
                        .fixedSize()
                        .font(.system(size: 12))
                        .background(GeometryReader { textGeo in
                            Color.clear.onAppear {
                                self.textHeight = textGeo.size.height
                            }
                        })
                }
            })
            .onHover { hovering in
                showHelp = hovering
            }
        
    }
}

struct MenuButtonView_Previews: PreviewProvider {
    static var previews: some View {
        MenuButtonView(info: "Little says when done\n Some animates loading\n Everything types the answer", showHelp: true ).padding(.trailing, 300).padding(100)
    }
}
