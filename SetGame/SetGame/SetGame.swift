//
//  SetGame.swift
//  SetGame
//
//  Created by Jiaxin Shou on 2020/12/25.
//

import Foundation

class SetGame: ObservableObject {
    @Published private var game = Game()

    // MARK: - Access to the Model

    var cards: [Card] {
        game.cardsOnTable
    }

    var numberOfRemainingCards: Int {
        game.cardsInDeck.count
    }

    var score: Int {
        game.score
    }

    // MARK: - Intent(s)

    func dealCards(to num: Int) {
        game.dealCards(to: num)
    }

    func select(card: Card) {
        game.select(card: card)
    }

    func newGame() {
        game = Game()
        game.dealCards(to: 12)
    }
}
