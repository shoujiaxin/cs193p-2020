//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Jiaxin Shou on 2020/12/19.
//

import SwiftUI

class EmojiMemoryGame {
    private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()

    static func createMemoryGame() -> MemoryGame<String> {
        let emojis = ["👻", "🎃", "🕷"]
        return MemoryGame<String>(numberOfPairsOfCards: emojis.count) { pairIndex in
            emojis[pairIndex]
        }
    }

    // MARK: - Access to the Model

    var cards: [MemoryGame<String>.Card] {
        model.cards
    }

    // MARK: - Intent(s)

    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
}
