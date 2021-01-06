//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Jiaxin Shou on 2020/12/18.
//

import SwiftUI

@main
struct MemorizeApp: App {
    var body: some Scene {
        WindowGroup {
            // Assignment 6.1
            EmojiMemoryGameThemeChooser()
                .environmentObject(EmojiMemoryGameThemeStore())
        }
    }
}
