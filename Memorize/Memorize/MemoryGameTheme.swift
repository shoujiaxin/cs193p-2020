//
//  MemoryGameTheme.swift
//  Memorize
//
//  Created by Jiaxin Shou on 2020/12/22.
//

import SwiftUI

struct MemoryGameTheme<CardContent>: Codable where CardContent: Codable { // Assignment 2.3
    var name: String

    var contents: [CardContent]

    var numberOfPairsOfCards: Int

    var color: ThemeColor

    enum ThemeColor: String, Codable {
        case orange
        case red
        case green
        case yellow
        case pink
        case blue

        func toColor() -> Color {
            switch self {
            case .orange: return .orange
            case .red: return .red
            case .green: return .green
            case .yellow: return .yellow
            case .pink: return .pink
            case .blue: return .blue
            }
        }
    }

    var json: Data? {
        try? JSONEncoder().encode(self)
    }
}
