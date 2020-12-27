//
//  Game.swift
//  SetGame
//
//  Created by Jiaxin Shou on 2020/12/25.
//

import Foundation

struct Game {
    private(set) var cardsInDeck: [Card] = []
    private(set) var cardsOnTable: [Card] = []
    private(set) var indicesOfSelectedCards: Set<Int> = Set()
    private(set) var score: Int = 0

    init() {
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

    mutating func dealCards(to num: Int) {
        while !cardsInDeck.isEmpty, cardsOnTable.count < num {
            let index = Int.random(in: 0 ..< cardsInDeck.count)
            cardsOnTable.append(cardsInDeck.remove(at: index))
        }
    }

    mutating func removeMatched() {
        cardsOnTable.removeAll(where: { $0.isMatch == true })
        indicesOfSelectedCards.removeAll()
    }

    mutating func deselectAll() {
        for index in cardsOnTable.indices {
            cardsOnTable[index].isSelected = false
        }
        indicesOfSelectedCards.removeAll()
    }

    mutating func select(_ card: Card) {
        let index = cardsOnTable.firstIndex(where: { $0.id == card.id })!
        cardsOnTable[index].isSelected = true

        indicesOfSelectedCards.insert(index)
        if indicesOfSelectedCards.count == 3 {
            let res = checkSet()
            for index in indicesOfSelectedCards {
                cardsOnTable[index].isMatch = res
            }
        }
    }

    // Assignment 3.8
    mutating func deselect(_ card: Card) {
        let index = cardsOnTable.firstIndex(where: { $0.id == card.id })!
        cardsOnTable[index].isSelected = false

        indicesOfSelectedCards.remove(index)
        if indicesOfSelectedCards.count < 3 {
            for index in cardsOnTable.indices {
                if cardsOnTable[index].isMatch != nil {
                    cardsOnTable[index].isMatch = nil
                }
            }
        }
    }

    // MARK: - Private functions

    private func checkSet() -> Bool {
        return checkNumberOfShapes() && checkShape() && checkShading() && checkColor()
    }

    private func checkNumberOfShapes() -> Bool {
        var set = Set<Card.NumberOfShapes>()
        for index in indicesOfSelectedCards {
            set.insert(cardsOnTable[index].numberOfShapes)
        }
        return set.count == 1 || set.count == 3
    }

    private func checkShape() -> Bool {
        var set = Set<Card.Shape>()
        for index in indicesOfSelectedCards {
            set.insert(cardsOnTable[index].shape)
        }
        return set.count == 1 || set.count == 3
    }

    private func checkShading() -> Bool {
        var set = Set<Card.Shading>()
        for index in indicesOfSelectedCards {
            set.insert(cardsOnTable[index].shading)
        }
        return set.count == 1 || set.count == 3
    }

    private func checkColor() -> Bool {
        var set = Set<Card.Color>()
        for index in indicesOfSelectedCards {
            set.insert(cardsOnTable[index].color)
        }
        return set.count == 1 || set.count == 3
    }
}
