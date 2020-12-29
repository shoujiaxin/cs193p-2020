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
                            OptionalImage(uiImage: document.backgroundImage)
                                .scaleEffect(zoomScale)
                                .offset(panOffset)
                        )
                        .gesture(doubleTapToZoom(in: geometry.size))
                        .onTapGesture {
                            document.deselectAllEmojis() // Assignment 4.5
                        }

                    ForEach(document.emojis) { emoji in
                        Text(emoji.text)
                            .font(animatableWithSize: emoji.fontSize * (document.selectedEmojis.contains(emoji) ? emojiScale : zoomScale)) // Assignment 4.8
                            .border(Color.accentColor, width: document.selectedEmojis.contains(emoji) ? selectionBorderWidth : 0)
                            .position(position(for: emoji, in: geometry.size))
                            .onTapGesture {
                                document.tapOnEmoji(emoji) // Assignment 4.2
                            }
                            .gesture(dragGesture(on: emoji))
                            .onLongPressGesture {
                                document.removeEmoji(emoji) // Assignment 4.10
                            }
                    }
                }
                .clipped()
                .gesture(panGesture())
                .gesture(zoomGesture())
                .edgesIgnoringSafeArea([.horizontal, .bottom])
                .onDrop(of: [UTType.image, UTType.text], isTargeted: nil) { (providers, location) -> Bool in
                    var location = geometry.convert(location, from: .global)
                    location = CGPoint(x: location.x - geometry.size.width / 2, y: location.y - geometry.size.height / 2)
                    location = CGPoint(x: location.x - panOffset.width, y: location.y - panOffset.height)
                    location = CGPoint(x: location.x / zoomScale, y: location.y / zoomScale)
                    return drop(providres: providers, at: location)
                }
            }
        }
    }

    // MARK: - Zoom Gesture

    @State private var steadyStateZoomScale: CGFloat = 1.0
    @GestureState private var gestureZoomScale: CGFloat = 1.0

    private var zoomScale: CGFloat {
        if document.hasSelectedEmoji {
            return steadyStateZoomScale
        } else {
            return steadyStateZoomScale * gestureZoomScale
        }
    }

    private var emojiScale: CGFloat {
        steadyStateZoomScale * (document.hasSelectedEmoji ? gestureZoomScale : 1.0)
    }

    private func zoomGesture() -> some Gesture {
        MagnificationGesture()
            .updating($gestureZoomScale) { latestGestureScale, gestureZoomScale, _ in
                gestureZoomScale = latestGestureScale
            }
            .onEnded { finalGestureScale in
                if document.hasSelectedEmoji {
                    document.scaleSelectedEmoji(by: finalGestureScale) // Assignment 4.7
                } else {
                    steadyStateZoomScale *= finalGestureScale // Assignment 4.8
                }
            }
    }

    private func doubleTapToZoom(in size: CGSize) -> some Gesture {
        TapGesture(count: 2)
            .onEnded {
                withAnimation {
                    zoomToFit(document.backgroundImage, in: size)
                }
            }
    }

    private func zoomToFit(_ image: UIImage?, in size: CGSize) {
        if let image = image, image.size.width > 0, image.size.height > 0 {
            let hZoom = size.width / image.size.width
            let vZoom = size.height / image.size.height
            steadyStatePanOffset = .zero
            steadyStateZoomScale = min(hZoom, vZoom)
        }
    }

    // MARK: - Pan Gesture

    @State private var steadyStatePanOffset: CGSize = .zero
    @GestureState private var gesturePanOffset: CGSize = .zero

    private var panOffset: CGSize {
        if document.hasSelectedEmoji {
            return (steadyStatePanOffset + gesturePanOffset - gestureDragOffset) * zoomScale
        } else {
            return (steadyStatePanOffset + gesturePanOffset + gestureDragOffset) * zoomScale
        }
    }

    private func panGesture() -> some Gesture {
        DragGesture()
            .updating($gesturePanOffset) { latestDragGestureValue, gesturePanOffset, _ in
                gesturePanOffset = latestDragGestureValue.translation / zoomScale
            }
            .onEnded { finalDragGestureValue in
                steadyStatePanOffset = steadyStatePanOffset + (finalDragGestureValue.translation / zoomScale)
            }
    }

    // MARK: - Drag Emojis

    @GestureState private var gestureDragOffset: CGSize = .zero

    private func dragGesture(on emoji: EmojiArt.Emoji) -> some Gesture {
        DragGesture()
            .simultaneously(with: panGesture())
            .updating($gestureDragOffset) { latestDragGestureValue, gestureDragOffset, _ in
                if document.selectedEmojis.contains(emoji) {
                    gestureDragOffset = latestDragGestureValue.first!.translation / zoomScale
                }
            }
            .onEnded { finalDragGestureValue in
                if document.selectedEmojis.contains(emoji) {
                    document.moveSelectedEmojis(by: finalDragGestureValue.first!.translation / zoomScale) // Assignment 4.6
                    steadyStatePanOffset = steadyStatePanOffset - (finalDragGestureValue.first!.translation / zoomScale)
                }
            }
    }

    // MARK: - Layout

    private func position(for emoji: EmojiArt.Emoji, in size: CGSize) -> CGPoint {
        var location = emoji.location

        if document.selectedEmojis.contains(emoji) {
            location = CGPoint(x: location.x + gestureDragOffset.width, y: location.y + gestureDragOffset.height)
        }

        location = CGPoint(x: location.x * zoomScale, y: location.y * zoomScale)
        location = CGPoint(x: location.x + size.width / 2, y: location.y + size.height / 2)
        location = CGPoint(x: location.x + panOffset.width, y: location.y + panOffset.height)
        return location
    }

    // MARK: - Drag & Drop

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

    // MARK: - Draw Constants

    private let defaultEmojiSize: CGFloat = 40
    private let selectionBorderWidth: CGFloat = 2
}

// struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        EmojiArtDocumentView(document: EmojiArtDocument())
//    }
// }
