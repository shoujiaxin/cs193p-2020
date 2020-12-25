//
//  Card.swift
//  SetGame
//
//  Created by Jiaxin Shou on 2020/12/25.
//

import Foundation

struct Card {
    enum NumberOfShapes: CaseIterable {
        case one
        case two
        case three
    }

    enum Shape: CaseIterable {
        case diamond
        case squiggle
        case oval
    }

    enum Shading: CaseIterable {
        case solid
        case striped
        case open
    }

    enum Color: CaseIterable {
        case red
        case green
        case purple
    }

    var numberOfShapes: NumberOfShapes
    var shape: Shape
    var shading: Shading
    var color: Color
}
