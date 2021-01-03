//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Jiaxin Shou on 2020/12/19.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()

    static func createMemoryGame() -> MemoryGame<String> {
        // Assignment 2.4, 2.5, 5.1
        var defaultThemes: [MemoryGameTheme<String>] = []
        defaultThemes.append(MemoryGameTheme<String>(name: "Halloween", contents: ["👻", "🎃", "🕷", "🍬", "💀"], numberOfPairsOfCards: 4, color: .orange))
        defaultThemes.append(MemoryGameTheme<String>(name: "Christmas", contents: ["🛷", "🎅🏼", "🎄", "🎁", "❄️"], numberOfPairsOfCards: 4, color: .red))
        defaultThemes.append(MemoryGameTheme<String>(name: "Animals", contents: ["🐱", "🐶", "🐼", "🐵", "🐷"], numberOfPairsOfCards: 4, color: .green))
        defaultThemes.append(MemoryGameTheme<String>(name: "Food", contents: ["🍎", "🍞", "🍕", "🌭", "🍗", "🍤", "🍩"], numberOfPairsOfCards: 4, color: .yellow))
        defaultThemes.append(MemoryGameTheme<String>(name: "Objects", contents: ["⌚️", "📱", "💻", "☎️", "📺", "⏱", "🪣"], numberOfPairsOfCards: 4, color: .pink))
        defaultThemes.append(MemoryGameTheme<String>(name: "Activity", contents: ["⚽️", "🏀", "🏈", "⚾️", "🏓", "🏸", "🛹"], numberOfPairsOfCards: 4, color: .blue))

        let theme = defaultThemes.randomElement()!

        print(String(decoding: theme.json!, as: UTF8.self)) // Assignment 5.2

        return MemoryGame<String>(with: theme)
    }

    // MARK: - Access to the Model

    var cards: [MemoryGame<String>.Card] {
        model.cards
    }

    var score: Int {
        model.score
    }

    var themeColor: Color {
        model.theme?.color.toColor() ?? .accentColor
    }

    var themeName: String {
        model.theme?.name ?? ""
    }

    // MARK: - Intent(s)

    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }

    func newGame() {
        model = EmojiMemoryGame.createMemoryGame()
    }
}
