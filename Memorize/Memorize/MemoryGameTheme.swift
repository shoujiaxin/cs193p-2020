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

    var color: UIColor.RGB

    var json: Data? {
        try? JSONEncoder().encode(self)
    }
}

extension Data {
    // just a simple converter from a Data to a String
    var utf8: String? { String(data: self, encoding: .utf8) }
}
