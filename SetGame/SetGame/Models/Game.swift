//
//  Game.swift
//  SetGame
//
//  Created by Jiaxin Shou on 2020/12/25.
//

import Foundation

struct Game {
    var cardsInDeck: [Card]
    var cardsOnTable: [Card]

    init() {
        cardsInDeck = []
        cardsOnTable = []

        for numberOfShapes in Card.NumberOfShapes.allCases {
            for shape in Card.Shape.allCases {
                for shading in Card.Shading.allCases {
                    for color in Card.Color.allCases {
                        cardsInDeck.append(Card(numberOfShapes: numberOfShapes, shape: shape, shading: shading, color: color))
                    }
                }
            }
        }
    }

    mutating func dealCards(_ num: Int) {
        while cardsOnTable.count < num {
            let index = Int.random(in: 0 ..< cardsInDeck.count)
            let card = cardsInDeck.remove(at: index)
            cardsOnTable.append(card)
        }
    }
}
