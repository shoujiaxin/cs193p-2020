//
//  EmojiMemoryGameThemeChooser.swift
//  Memorize
//
//  Created by Jiaxin Shou on 2021/1/6.
//

import SwiftUI

struct EmojiMemoryGameThemeChooser: View {
    @Environment(\.presentationMode) var presentation
    @EnvironmentObject var store: EmojiMemoryGameThemeStore

    @State private var editMode: EditMode = .inactive

    var body: some View {
        NavigationView {
            // Assignment 6.2
            List {
                ForEach(store.themes) { theme in
                    // Assignment 6.4
                    NavigationLink(
                        destination: EmojiMemoryGameView(with: theme),
                        label: {
                            EmojiMemoryGameThemeRow(theme: theme, isEditing: editMode.isEditing)
                        }
                    )
                }
                .onDelete { indexSet in // Assignment 6.8
                    indexSet.forEach { index in
                        store.removeTheme(at: index)
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle(Text("Memorize"))
            .navigationBarItems(leading:
                Button(action: {
                    store.addTheme() // Assignment 6.7
                }) {
                    Image(systemName: "plus")
                },
                trailing: EditButton())
            .environment(\.editMode, $editMode)
        }
    }
}

struct EmojiMemoryGameThemeChooser_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameThemeChooser()
            .environmentObject(EmojiMemoryGameThemeStore())
    }
}
