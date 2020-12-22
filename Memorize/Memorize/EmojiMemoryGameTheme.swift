//
//  EmojiMemoryGameTheme.swift
//  Memorize
//
//  Created by Jiaxin Shou on 2020/12/22.
//

import SwiftUI

struct EmojiMemoryGameTheme { // Assignment 2.3
    var name: String

    var emojis: [String]

    var game: MemoryGame<String>

    var cards: [MemoryGame<String>.Card] {
        game.cards
    }

    var score: Int {
        game.score
    }

    var color: Color

    // Assignment 2.4
    static let halloween = EmojiMemoryGameTheme("Halloween", emojis: ["👻", "🎃", "🕷", "🍬", "💀"], color: .orange)
    static let christmas = EmojiMemoryGameTheme("Christmas", emojis: ["🛷", "🎅🏼", "🎄", "🎁", "❄️"], color: .red)
    static let animals = EmojiMemoryGameTheme("Animals", emojis: ["🐱", "🐶", "🐼", "🐵", "🐷"], color: .green)
    static let food = EmojiMemoryGameTheme("Food", emojis: ["🍎", "🍞", "🍕", "🌭", "🍗", "🍤", "🍩"], color: .yellow)
    static let objects = EmojiMemoryGameTheme("Objects", emojis: ["⌚️", "📱", "💻", "☎️", "📺", "⏱", "🪣"], color: .pink)
    static let activity = EmojiMemoryGameTheme("Activity", emojis: ["⚽️", "🏀", "🏈", "⚾️", "🏓", "🏸", "🛹"], color: .blue)

    // Assignment 2.5
    init(_ name: String, emojis: [String], color: Color) {
        self.name = name
        self.emojis = emojis
        self.color = color

        game = MemoryGame<String>(numberOfPairsOfCards: Int.random(in: 2 ... 5)) { pairIndex in // Assignment 1.4
            emojis[pairIndex]
        }
    }
}
