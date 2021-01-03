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
        // Assignment 2.4, 2.5
        var defaultThemes: [MemoryGameTheme<String>] = []
        defaultThemes.append(MemoryGameTheme<String>(name: "Halloween", contents: ["👻", "🎃", "🕷", "🍬", "💀"], numberOfPairsOfCards: Int.random(in: 2 ... 5), color: .orange))
        defaultThemes.append(MemoryGameTheme<String>(name: "Christmas", contents: ["🛷", "🎅🏼", "🎄", "🎁", "❄️"], numberOfPairsOfCards: Int.random(in: 2 ... 5), color: .red))
        defaultThemes.append(MemoryGameTheme<String>(name: "Animals", contents: ["🐱", "🐶", "🐼", "🐵", "🐷"], numberOfPairsOfCards: Int.random(in: 2 ... 5), color: .green))
        defaultThemes.append(MemoryGameTheme<String>(name: "Food", contents: ["🍎", "🍞", "🍕", "🌭", "🍗", "🍤", "🍩"], numberOfPairsOfCards: Int.random(in: 2 ... 5), color: .yellow))
        defaultThemes.append(MemoryGameTheme<String>(name: "Objects", contents: ["⌚️", "📱", "💻", "☎️", "📺", "⏱", "🪣"], numberOfPairsOfCards: Int.random(in: 2 ... 5), color: .pink))
        defaultThemes.append(MemoryGameTheme<String>(name: "Activity", contents: ["⚽️", "🏀", "🏈", "⚾️", "🏓", "🏸", "🛹"], numberOfPairsOfCards: Int.random(in: 2 ... 5), color: .blue))

        return MemoryGame<String>(with: defaultThemes.randomElement()!)
    }

    // MARK: - Access to the Model

    var cards: [MemoryGame<String>.Card] {
        model.cards
    }

    var score: Int {
        model.score
    }

    var themeColor: Color {
        model.theme?.color ?? .accentColor
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
