//
//  Card.swift
//  SetGame
//
//  Created by Jiaxin Shou on 2020/12/25.
//

import SwiftUI

struct Card {
    enum NumberOfShapes: Int, CaseIterable {
        case one = 1
        case two
        case three
    }

    enum Shape: CaseIterable {
        case diamond // 菱形
        case squiggle // 波浪形
        case oval // 椭圆形
    }

    enum Shading: CaseIterable {
        case solid // 实心
        case striped // 条纹
        case open // 空心
    }

    enum Color: CaseIterable {
        case red
        case green
        case purple

        func toViewColor() -> SwiftUI.Color {
            switch self {
            case .red: return .red
            case .green: return .green
            case .purple: return .purple
            }
        }
    }

    var numberOfShapes: NumberOfShapes
    var shape: Shape
    var shading: Shading
    var color: Color
}
