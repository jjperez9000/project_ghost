//
//  AboutView.swift
//  project_wingman2
//
//  Created by John Perez on 4/8/23.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack{
            Text("Welcome to SpiritAI")
                .font(.system(.title))
                .padding(.bottom, 20)
            Text("This app allows you to get answers from GPT anywhere on your Mac by reading and writing to your clipboard.")
                .font(.system(size:15))
                .padding(.bottom, 10)
            Text("To get stared, add your API key to the settings tab.")
                .font(.system(size:15))
                .padding(.bottom, 10)
            Text("If you want more control of your prompting, the advanced tab allows you to modify your question parameters.")
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

