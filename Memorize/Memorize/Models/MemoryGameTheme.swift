//
//  MemoryGameTheme.swift
//  Memorize
//
//  Created by Jiaxin Shou on 2020/12/22.
//

import SwiftUI

struct MemoryGameTheme<CardContent>: Codable, Identifiable where CardContent: Codable { // Assignment 2.3
    var name: String

    var contents: [CardContent]

    var numberOfPairsOfCards: Int

    var color: UIColor.RGB

    var json: Data? {
        try? JSONEncoder().encode(self)
    }

    var id: Int

    init?(json: Data?) {
        if let json = json, let newTheme = try? JSONDecoder().decode(MemoryGameTheme.self, from: json) {
            self = newTheme
        } else {
            return nil
        }
    }

    init(_ name: String, id: Int, contents: [CardContent], numberOfPairsOfCards: Int, color: UIColor.RGB) {
        self.name = name
        self.contents = contents
        self.numberOfPairsOfCards = numberOfPairsOfCards
        self.color = color
        self.id = id
    }
}

extension Data {
    // just a simple converter from a Data to a String
    var utf8: String? { String(data: self, encoding: .utf8) }
}
