//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Jiaxin Shou on 2020/12/19.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published private var model: EmojiMemoryGameTheme = EmojiMemoryGame.createMemoryGame()

    static func createMemoryGame() -> EmojiMemoryGameTheme {
        let themes: [EmojiMemoryGameTheme] = [
            EmojiMemoryGameTheme.halloween,
            EmojiMemoryGameTheme.christmas,
            EmojiMemoryGameTheme.animals,
            EmojiMemoryGameTheme.food,
            EmojiMemoryGameTheme.objects,
            EmojiMemoryGameTheme.activity,
        ]
        return themes.randomElement()!
    }

    // MARK: - Access to the Model

    var cards: [MemoryGame<String>.Card] {
        model.cards
    }

    var score: Int {
        model.score
    }

    var themeColor: Color {
        model.color
    }

    var themeName: String {
        model.name
    }

    // MARK: - Intent(s)

    func choose(card: MemoryGame<String>.Card) {
        model.game.choose(card: card)
    }

    func newGame() {
        model = EmojiMemoryGame.createMemoryGame()
    }
}
