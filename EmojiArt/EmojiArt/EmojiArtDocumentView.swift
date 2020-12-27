//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by Jiaxin Shou on 2020/12/27.
//

import SwiftUI
import UniformTypeIdentifiers

struct EmojiArtDocumentView: View {
    @ObservedObject var document: EmojiArtDocument

    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(EmojiArtDocument.palette.map { String($0) }, id: \.self) { emoji in
                        Text(emoji)
                            .font(Font.system(size: defaultEmojiSize))
                            .onDrag { NSItemProvider(object: emoji as NSString) }
                    }
                }
            }
            .padding(.horizontal)

            GeometryReader { geometry in
                ZStack {
                    Color.white
                        .overlay(
                            Group {
                                if let backgroundImage = document.backgroundImage {
                                    Image(uiImage: backgroundImage)
                                }
                            }
                        )
                        .edgesIgnoringSafeArea([.horizontal, .bottom])
                        .onDrop(of: [UTType.image, UTType.text], isTargeted: nil) { (providers, location) -> Bool in
                            var location = geometry.convert(location, from: .global)
                            location = CGPoint(x: location.x - geometry.size.width / 2, y: location.y - geometry.size.height / 2)
                            return drop(providres: providers, at: location)
                        }

                    ForEach(document.emojis) { emoji in
                        Text(emoji.text)
                            .font(font(for: emoji))
                            .position(position(for: emoji, in: geometry.size))
                    }
                }
            }
        }
    }

    private func font(for emoji: EmojiArt.Emoji) -> Font {
        Font.system(size: emoji.fontSize)
    }

    private func position(for emoji: EmojiArt.Emoji, in size: CGSize) -> CGPoint {
        CGPoint(x: emoji.location.x + size.width / 2, y: emoji.location.y + size.height / 2)
    }

    private func drop(providres: [NSItemProvider], at location: CGPoint) -> Bool {
        var found = providres.loadFirstObject(ofType: URL.self) { url in
            print("dropped \(url)")
            document.setBackgroundURL(url)
        }
        if !found {
            found = providres.loadObjects(ofType: String.self) { string in
                document.addEmoji(string, at: location, size: defaultEmojiSize)
            }
        }
        return found
    }

    private let defaultEmojiSize: CGFloat = 40
}

// struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        EmojiArtDocumentView(document: EmojiArtDocument())
//    }
// }
