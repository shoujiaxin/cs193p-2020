//
//  EmojiMemoryGameThemeStore.swift
//  Memorize
//
//  Created by Jiaxin Shou on 2021/1/6.
//

import Combine
import SwiftUI

class EmojiMemoryGameThemeStore: ObservableObject {
    typealias EmojiMemoryGameTheme = MemoryGameTheme<String>

    @Published private(set) var themes: [EmojiMemoryGameTheme] = []

    private var autosaveCancellable: AnyCancellable?

    init() {
        let defaultsKey = "EmojiMemoryGameThemeStore"
        if let jsonData = UserDefaults.standard.dictionary(forKey: defaultsKey) as? [String: Data] {
            // Assignment 6.11
            for (_, json) in jsonData {
                if let theme = EmojiMemoryGameTheme(json: json) {
                    themes.append(theme)
                }
            }
            themes.sort { $0.id < $1.id }
        } else {
            // Default themes
            themes.append(EmojiMemoryGameTheme("Halloween", id: 0, contents: ["👻", "🎃", "🕷", "🍬", "💀"], numberOfPairsOfCards: 4, color: UIColor.systemOrange.rgb))
            themes.append(EmojiMemoryGameTheme("Christmas", id: 1, contents: ["🛷", "🎅🏼", "🎄", "🎁", "❄️"], numberOfPairsOfCards: 4, color: UIColor.systemRed.rgb))
            themes.append(EmojiMemoryGameTheme("Animals", id: 2, contents: ["🐱", "🐶", "🐼", "🐵", "🐷"], numberOfPairsOfCards: 4, color: UIColor.systemGreen.rgb))
            themes.append(EmojiMemoryGameTheme("Food", id: 3, contents: ["🍎", "🍞", "🍕", "🌭", "🍗", "🍤", "🍩"], numberOfPairsOfCards: 4, color: UIColor.systemYellow.rgb))
            themes.append(EmojiMemoryGameTheme("Objects", id: 4, contents: ["⌚️", "📱", "💻", "☎️", "📺", "⏱", "🪣"], numberOfPairsOfCards: 4, color: UIColor.systemPink.rgb))
            themes.append(EmojiMemoryGameTheme("Activity", id: 5, contents: ["⚽️", "🏀", "🏈", "⚾️", "🏓", "🏸", "🛹"], numberOfPairsOfCards: 4, color: UIColor.systemBlue.rgb))
        }

        // Auto save
        autosaveCancellable = $themes.sink { themes in
            var data: [String: Data?] = [:]
            for index in 0 ..< themes.count {
                data[String(index)] = themes[index].json // re-order the id from 0
            }
            UserDefaults.standard.set(data, forKey: defaultsKey)
        }
    }

    func removeTheme(at index: Int) {
        themes.remove(at: index)
    }

    func addTheme() {
        let maxId = themes.max { $0.id < $1.id }?.id ?? -1
        themes.append(EmojiMemoryGameTheme("Untitled", id: maxId + 1, contents: ["😂", "😜", "😎"], numberOfPairsOfCards: 3, color: UIColor.systemBlue.rgb))
    }

    func updateTheme(_ theme: EmojiMemoryGameTheme, name: String, contents: [String], numberOfPairsOfCards: Int, color: UIColor.RGB) {
        let index = themes.firstIndex { $0.id == theme.id }!
        themes[index].name = name
        themes[index].contents = contents
        themes[index].numberOfPairsOfCards = numberOfPairsOfCards
        themes[index].color = color
    }
}
