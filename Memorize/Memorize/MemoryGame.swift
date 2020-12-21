//
//  MemoryGame.swift
//  Memorize
//
//  Created by Jiaxin Shou on 2020/12/19.
//

import Foundation

struct MemoryGame<CardContent> {
    var cards: [Card]

    mutating func choose(card: Card) {
        print("card chosen: \(card)")
        let chosenIndex = cards.firstIndex(matching: card)
        cards[chosenIndex].isFaceUp = !cards[chosenIndex].isFaceUp
    }

    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = []
        for pairIndex in 0 ..< numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(id: pairIndex * 2, content: content))
            cards.append(Card(id: pairIndex * 2 + 1, content: content))
        }
    }

    struct Card: Identifiable {
        var id: Int
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
    }
}
