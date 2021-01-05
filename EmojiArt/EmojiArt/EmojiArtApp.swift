//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Jiaxin Shou on 2020/12/27.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    var body: some Scene {
        let store = EmojiArtDocumentStore(named: "Emoji Art")
//        store.addDocument()
//        store.addDocument(named: "Hello World")

        return WindowGroup {
//            EmojiArtDocumentView(document: EmojiArtDocument())

            EmojiArtDocumentChooser()
                .environmentObject(store)
        }
    }
}
