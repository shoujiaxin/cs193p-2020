//
//  EmojiMemoryGameThemeRow.swift
//  Memorize
//
//  Created by Jiaxin Shou on 2021/1/6.
//

import SwiftUI

// Assignment 6.3
struct EmojiMemoryGameThemeRow: View {
    var theme: MemoryGameTheme<String>
    var isEditing: Bool

    @State private var showThemeEditor: Bool = false

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(theme.name)
                    .padding(.vertical, 1.0)

                Text("All of \(theme.contents.joined())")
                    .font(.footnote)
                    .foregroundColor(.primary)
            }

            if isEditing {
                Spacer()

                // Assignment 6.8
                Image(systemName: "pencil.circle.fill")
                    .onTapGesture {
                        showThemeEditor = true
                    }
            }
        }
        .font(.title)
        .foregroundColor(Color(theme.color))
        .sheet(isPresented: $showThemeEditor, content: {
            EmojiMemoryGameEditor(theme, isShowing: $showThemeEditor)
        })
    }
}

struct EmojiMemoryGameThemeRow_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameThemeRow(theme: MemoryGameTheme<String>("Halloween", id: 0, contents: ["👻", "🎃", "🕷", "🍬", "💀"], numberOfPairsOfCards: 4, color: UIColor.systemOrange.rgb), isEditing: true)
            .previewLayout(.sizeThatFits)
    }
}
