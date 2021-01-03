//
//  MemoryGameTheme.swift
//  Memorize
//
//  Created by Jiaxin Shou on 2020/12/22.
//

import SwiftUI

struct MemoryGameTheme<CardContent> { // Assignment 2.3
    var name: String

    var contents: [CardContent]

    var numberOfPairsOfCards: Int

    var color: Color
}
