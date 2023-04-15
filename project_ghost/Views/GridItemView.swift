//
//  GridItemView.swift
//  project_wingman2
//
//  Created by John Perez on 4/8/23.
//

import SwiftUI

enum IconType {
    case system(name: String)
    case custom(name: String)
}

struct GridItemView: View {
    let index: Int
    let selected: Bool
    let icons: [IconType] = [
        .custom(name: "ghost.spooky"),
        .system(name: "gearshape"),
        .system(name: "gearshape.2")
    ]
    let titles = ["About", "Settings", "Advanced"]
    
    @State private var isHovered = false
    
    var body: some View {
        VStack {
            iconView(for: icons[index])
                .font(.system(size: 24))
                .foregroundColor(.accentColor)
            
            Text(titles[index])
                .font(.headline)
        }
        .padding(5)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(isHovered && !selected ?
                        Color.gray.opacity(0.1) :
                        selected ?
                            Color.gray.opacity(0.3) :
                            Color.clear)
        )
        .onHover { hovering in
            isHovered = hovering
        }
    }
    
    private func iconView(for iconType: IconType) -> some View {
        switch iconType {
        case .system(let name):
            return AnyView(Image(systemName: name))
        case .custom(let name):
            return AnyView(Image(name))
        }
    }
}
struct GridItemView_Previews: PreviewProvider {
    static var previews: some View {
        GridItemView(index: 0, selected: true)
        GridItemView(index: 1, selected: true)
        GridItemView(index: 2, selected: true)
    }
}
