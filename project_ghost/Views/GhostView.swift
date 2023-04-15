//
//  GIFView.swift
//  project_wingman2
//
//  Created by John Perez on 4/11/23.
//

import SwiftUI
import AppKit

//https://gfycat.com/grimygrandioseafricanwildcat
struct GhostView: View {
    var body: some View {
        GifView(gifName: "ghost")
            .frame(maxWidth: 30, maxHeight: 55)
    }
}
struct GhostView_Previews: PreviewProvider {
    static var previews: some View {
        GhostView()
    }
}

struct GifView: NSViewRepresentable {
    let gifName: String

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeNSView(context: Context) -> NSImageView {
        let imageView = NSImageView()
        imageView.imageScaling = .scaleProportionallyDown
        context.coordinator.loadGif(named: gifName, for: imageView)
        return imageView
    }

    func updateNSView(_ nsView: NSImageView, context: Context) {}

    class Coordinator {
        var gifView: GifView

        init(_ gifView: GifView) {
            self.gifView = gifView
        }

        func loadGif(named name: String, for imageView: NSImageView) {
            guard let url = Bundle.main.url(forResource: name, withExtension: "gif") else {
                print("GIF not found")
                return
            }

            guard let image = NSImage(contentsOf: url) else {
                print("Unable to load GIF")
                return
            }

            imageView.image = image
            imageView.animates = true
        }
    }
}
