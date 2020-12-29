//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Jiaxin Shou on 2020/12/27.
//

import SwiftUI

class EmojiArtDocument: ObservableObject {
    static let palette: String = "🥎🎾🏐🏉🥏🎱🪀🏓"

    @Published private var emojiArt: EmojiArt {
        didSet {
            UserDefaults.standard.set(emojiArt.json, forKey: EmojiArtDocument.untitled)
        }
    }

    private static let untitled = "EmojiArtDocument.Untitled"

    init() {
        emojiArt = EmojiArt(json: UserDefaults.standard.data(forKey: EmojiArtDocument.untitled)) ?? EmojiArt()
        fetchBackgroundImageData()
    }

    @Published private(set) var backgroundImage: UIImage?

    var emojis: [EmojiArt.Emoji] {
        emojiArt.emojis
    }

    @Published private(set) var selectedEmojis = Set<EmojiArt.Emoji>()

    var hasSelectedEmoji: Bool {
        !selectedEmojis.isEmpty
    }

    // MARK: - Intent(s)

    func addEmoji(_ emoji: String, at location: CGPoint, size: CGFloat) {
        emojiArt.addEmoji(emoji, x: Int(location.x), y: Int(location.y), size: Int(size))
    }

    func moveEmoji(_ emoji: EmojiArt.Emoji, by offset: CGSize) {
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[index].x += Int(offset.width)
            emojiArt.emojis[index].y += Int(offset.height)
        }
    }

    func scaleEmoji(_ emoji: EmojiArt.Emoji, by scale: CGFloat) {
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrEven))
        }
    }

    func setBackgroundURL(_ url: URL?) {
        emojiArt.backgroundURL = url?.imageURL
        fetchBackgroundImageData()
    }

    func selectEmoji(_ emoji: EmojiArt.Emoji) {
        selectedEmojis.insert(emoji)
    }

    func deselectEmoji(_ emoji: EmojiArt.Emoji) {
        selectedEmojis.remove(emoji)
    }

    func reselectEmoji(_ emoji: EmojiArt.Emoji) {
        selectedEmojis.remove(emoji)
        selectedEmojis.insert(emojiArt.emojis.first(where: { $0.id == emoji.id })!)
    }

    func tapOnEmoji(_ emoji: EmojiArt.Emoji) {
        if selectedEmojis.contains(emoji) {
            deselectEmoji(emoji) // Assignment 4.4
        } else {
            selectEmoji(emoji) // Assignment 4.3
        }
    }

    func deselectAllEmojis() {
        selectedEmojis.removeAll()
    }

    func moveSelectedEmojis(by offset: CGSize) {
        for emoji in selectedEmojis {
            moveEmoji(emoji, by: offset)
            reselectEmoji(emoji)
        }
    }

    func scaleSelectedEmoji(by scale: CGFloat) {
        for emoji in selectedEmojis {
            scaleEmoji(emoji, by: scale)
            reselectEmoji(emoji)
        }
    }

    func removeEmoji(_ emoji: EmojiArt.Emoji) {
        emojiArt.emojis.removeAll(where: { $0.id == emoji.id })
    }

    private func fetchBackgroundImageData() {
        backgroundImage = nil
        if let url = emojiArt.backgroundURL {
            DispatchQueue.global(qos: .userInitiated).async {
                if let imageData = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        if url == self.emojiArt.backgroundURL {
                            self.backgroundImage = UIImage(data: imageData)
                        }
                    }
                }
            }
        }
    }
}

extension EmojiArt.Emoji {
    var fontSize: CGFloat {
        CGFloat(size)
    }

    var location: CGPoint {
        CGPoint(x: CGFloat(x), y: CGFloat(y))
    }
}
