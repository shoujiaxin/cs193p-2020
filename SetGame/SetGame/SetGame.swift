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

    var numberOfSelectedCards: Int {
        game.indicesOfSelectedCards.count
    }

    var hasMatched: Bool {
        game.cardsOnTable.filter { $0.isMatch == true }.count > 0
    }

    var score: Int {
        game.score
    }

    func removeMatched() {
        game.removeMatched()
    }

    func deselectAll() {
        game.deselectAll()
    }

    // MARK: - Intent(s)

    func dealCards(to num: Int) {
        game.dealCards(to: num)
    }

    func select(_ card: Card) {
        game.select(card)
    }

    func deselect(_ card: Card) {
        game.deselect(card)
    }

    func resetGame() {
        game = Game()
        game.dealCards(to: 12)
    }
}
