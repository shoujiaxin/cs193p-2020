//
//  EmojiMemoryGameEditor.swift
//  Memorize
//
//  Created by Jiaxin Shou on 2021/1/7.
//

import SwiftUI

struct EmojiMemoryGameEditor: View {
    private var theme: MemoryGameTheme<String>
    @EnvironmentObject var store: EmojiMemoryGameThemeStore

    @Binding var isShowing: Bool
    @State private var themeName: String = ""
    @State private var addedEmoji: String = ""
    @State private var emojis: [String] = []
    @State private var numberOfPairs: Int = 0
    @State private var selectedColor: Color = .accentColor

    init(_ theme: MemoryGameTheme<String>, isShowing: Binding<Bool>) {
        self.theme = theme
        _isShowing = isShowing
        _themeName = State(initialValue: theme.name)
        _emojis = State(initialValue: theme.contents)
        _numberOfPairs = State(initialValue: theme.numberOfPairsOfCards)
        _selectedColor = State(initialValue: Color(theme.color))
    }

    // Assignment 6.10
    var body: some View {
        VStack {
            ZStack {
                Text("Theme Editor")
                    .font(.headline)
                    .padding()

                HStack {
                    Button(action: {
                        isShowing = false
                    }, label: {
                        Text("Cancel")
                    })
                        .padding()

                    Spacer()

                    Button(action: {
                        store.updateTheme(theme, name: themeName, contents: emojis, numberOfPairsOfCards: numberOfPairs, color: UIColor(selectedColor).rgb)
                        isShowing = false
                    }, label: {
                        Text("Done")
                    })
                        .padding()
                }
            }

            Form { // Assignment 6.9
                TextField("Theme Name", text: $themeName)

                Section(header: Text("Add Emoji")) {
                    HStack {
                        TextField("Emoji", text: $addedEmoji)

                        Spacer()

                        HStack {
                            Spacer()

                            Button(action: {
                                for ch in addedEmoji {
                                    let emoji = String(ch)
                                    if !emojis.contains(emoji) {
                                        emojis.append(emoji)
                                    }
                                }
                                addedEmoji = ""
                            }, label: {
                                Text("Add")
                            })
                        }
                    }
                }

                Section(header:
                    HStack {
                        Text("Emojis")

                        Spacer()

                        Text("tap emoji to exclude")
                            .font(.caption)
                    }
                ) {
                    Grid(emojis, id: \.self) { emoji in
                        Text(emoji)
                            .font(.title)
                            .onTapGesture {
                                guard emojis.count > 2 else {
                                    return
                                }
                                emojis.removeAll {
                                    $0 == emoji
                                }
                            }
                    }
                }

                Section(header: Text("Card Count")) {
                    Stepper(value: $numberOfPairs, in: 2 ... emojis.count) {
                        Text("\(numberOfPairs) Pairs")
                    }
                }

                Section(header: Text("Color")) {
                    ColorPicker(selection: $selectedColor, label: {
                        Text("Set the card color")
                    })
                }
            }
        }
    }
}

struct EmojiMemoryGameEditor_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameEditor(MemoryGameTheme<String>("Halloween", id: 0, contents: ["👻", "🎃", "🕷", "🍬", "💀"], numberOfPairsOfCards: 4, color: UIColor.systemOrange.rgb), isShowing: .constant(true))
            .previewLayout(.sizeThatFits)
    }
}
