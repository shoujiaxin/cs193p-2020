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
    private(set) var score: Int = 0

    private var indicesOfSelectedCards: Set<Int> = Set()

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
        while cardsOnTable.count < num {
            let index = Int.random(in: 0 ..< cardsInDeck.count)
            cardsOnTable.append(cardsInDeck.remove(at: index))
        }
    }

    mutating func select(card: Card) {
        let index = cardsOnTable.firstIndex(where: { $0.id == card.id })!
        if card.isSelected {
            indicesOfSelectedCards.remove(index)
        } else {
            indicesOfSelectedCards.insert(index)
        }
        cardsOnTable[index].isSelected.toggle()

        if indicesOfSelectedCards.count == 3 {
            if checkSet() {
                score += 1
                cardsOnTable.removeAll(where: { $0.isSelected })
                dealCards(to: 12)
            } else {
                score -= 1
                for i in indicesOfSelectedCards {
                    cardsOnTable[i].isSelected = false
                }
            }

            indicesOfSelectedCards.removeAll()
        }
    }

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
