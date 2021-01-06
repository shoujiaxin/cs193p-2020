//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Jiaxin Shou on 2020/12/19.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published private var model: MemoryGame<String>

    init(with theme: MemoryGameTheme<String>) {
        model = MemoryGame<String>(with: theme)
    }

    // MARK: - Access to the Model

    var cards: [MemoryGame<String>.Card] {
        model.cards
    }

    var score: Int {
        model.score
    }

    var themeColor: Color {
        Color(model.theme!.color)
    }

    var themeName: String {
        model.theme!.name
    }

    // MARK: - Intent(s)

    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }

    func newGame() {
        model = MemoryGame<String>(with: model.theme!)
    }
}
