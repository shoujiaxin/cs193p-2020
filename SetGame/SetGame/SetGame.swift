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

    // MARK: - Intent(s)

    func dealCards(_ num: Int) {
        game.dealCards(num)
    }
}
