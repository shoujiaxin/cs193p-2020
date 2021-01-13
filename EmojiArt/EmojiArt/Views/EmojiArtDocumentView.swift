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

    @State private var chosenPalette: String

    init(document: EmojiArtDocument) {
        self.document = document
        _chosenPalette = State(initialValue: document.defaultPalette)
    }

    var body: some View {
        VStack {
            HStack {
                PaletteChooser(document: document, chosenPalette: $chosenPalette)

                ScrollView(.horizontal) {
                    HStack {
                        ForEach(chosenPalette.map { String($0) }, id: \.self) { emoji in
                            Text(emoji)
                                .font(Font.system(size: defaultEmojiSize))
                                .onDrag { NSItemProvider(object: emoji as NSString) }
                        }
                    }
                }
            }

            GeometryReader { geometry in
                ZStack {
                    Color.white
                        .overlay(
                            OptionalImage(uiImage: document.backgroundImage)
                                .scaleEffect(zoomScale)
                                .offset(panOffset)
                        )
                        .gesture(doubleTapToZoom(in: geometry.size))

                    if isLoading {
                        Image(systemName: "hourglass")
                            .imageScale(.large)
                            .spinning()
                    } else {
                        ForEach(document.emojis) { emoji in
                            Text(emoji.text)
                                .font(animatableWithSize: emoji.fontSize * zoomScale)
                                .position(position(for: emoji, in: geometry.size))
                        }
                    }
                }
                .clipped()
                .gesture(panGesture())
                .gesture(zoomGesture())
                .edgesIgnoringSafeArea([.horizontal, .bottom])
                .onReceive(document.$backgroundImage) { image in
                    zoomToFit(image, in: geometry.size)
                }
                .onDrop(of: [UTType.image, UTType.text], isTargeted: nil) { (providers, location) -> Bool in
                    var location = geometry.convert(location, from: .global)
                    location = CGPoint(x: location.x - geometry.size.width / 2, y: location.y - geometry.size.height / 2)
                    location = CGPoint(x: location.x - panOffset.width, y: location.y - panOffset.height)
                    location = CGPoint(x: location.x / zoomScale, y: location.y / zoomScale)
                    return drop(providres: providers, at: location)
                }
                .navigationBarItems(leading: pickImage, trailing:
                    Button(action: {
                        if UIPasteboard.general.url != nil {
                            confirmBackgroundPaste = true
                        } else {
                            explainBackgroundPaste = true
                        }
                    }) {
                        Image(systemName: "doc.on.clipboard")
                            .imageScale(.large)
                            .alert(isPresented: $explainBackgroundPaste) {
                                Alert(
                                    title: Text("Paste Background"),
                                    message: Text("Copy the URL of an image to the clip board and touch this button to make it the background of your document."),
                                    dismissButton: .default(Text("OK"))
                                )
                            }
                    }
                    .alert(isPresented: $confirmBackgroundPaste) {
                        Alert(
                            title: Text("Paste Background"),
                            message: Text("Replace your background with \(UIPasteboard.general.url?.absoluteString ?? "nothing")?."),
                            primaryButton: .default(Text("OK")) {
                                document.backgroundURL = UIPasteboard.general.url
                            },
                            secondaryButton: .cancel()
                        )
                    })
            }
            .zIndex(-1)
        }
    }

    @State private var showImagePicker: Bool = false
    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary

    private var pickImage: some View {
        HStack {
            Image(systemName: "photo")
                .imageScale(.large)
                .foregroundColor(.accentColor)
                .onTapGesture {
                    self.imagePickerSourceType = .photoLibrary
                    self.showImagePicker = true
                }

            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                Image(systemName: "camera")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                    .onTapGesture {
                        self.imagePickerSourceType = .camera
                        self.showImagePicker = true
                    }
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: imagePickerSourceType) { image in
                if let image = image {
                    DispatchQueue.main.async {
                        self.document.backgroundURL = image.storeInFilesystem()
                    }
                }
                self.showImagePicker = false
            }
        }
    }

    @State private var explainBackgroundPaste: Bool = false
    @State private var confirmBackgroundPaste: Bool = false

    var isLoading: Bool {
        document.backgroundURL != nil && document.backgroundImage == nil
    }

    // MARK: - Zoom Gesture

    @GestureState private var gestureZoomScale: CGFloat = 1.0

    private var zoomScale: CGFloat {
        document.steadyStateZoomScale * gestureZoomScale
    }

    private func zoomGesture() -> some Gesture {
        MagnificationGesture()
            .updating($gestureZoomScale) { latestGestureScale, gestureZoomScale, _ in
                gestureZoomScale = latestGestureScale
            }
            .onEnded { finalGestureScale in
                document.steadyStateZoomScale *= finalGestureScale
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
        // iOS 14 中从 NavigationView 跳转后 size 不会为 0，无需检查
        // 且由于 .onReceive(document.$backgroundImage)
        // 跳转后会重新 zoomToFit，因此无法保存 steadyStateZoomScale 和 steadyStatePanOffset
        if let image = image, image.size.width > 0, image.size.height > 0, size.width > 0, size.height > 0 {
            let hZoom = size.width / image.size.width
            let vZoom = size.height / image.size.height
            document.steadyStatePanOffset = .zero
            document.steadyStateZoomScale = min(hZoom, vZoom)
        }
    }

    // MARK: - Pan Gesture

    @GestureState private var gesturePanOffset: CGSize = .zero

    private var panOffset: CGSize {
        (document.steadyStatePanOffset + gesturePanOffset) * zoomScale
    }

    private func panGesture() -> some Gesture {
        DragGesture()
            .updating($gesturePanOffset) { latestDragGestureValue, gesturePanOffset, _ in
                gesturePanOffset = latestDragGestureValue.translation / zoomScale
            }
            .onEnded { finalDragGestureValue in
                document.steadyStatePanOffset = document.steadyStatePanOffset + (finalDragGestureValue.translation / zoomScale)
            }
    }

    // MARK: - Layout

    private func position(for emoji: EmojiArt.Emoji, in size: CGSize) -> CGPoint {
        var location = emoji.location
        location = CGPoint(x: location.x * zoomScale, y: location.y * zoomScale)
        location = CGPoint(x: location.x + size.width / 2, y: location.y + size.height / 2)
        location = CGPoint(x: location.x + panOffset.width, y: location.y + panOffset.height)
        return location
    }

    // MARK: - Drag & Drop

    private func drop(providres: [NSItemProvider], at location: CGPoint) -> Bool {
        var found = providres.loadFirstObject(ofType: URL.self) { url in
            print("dropped \(url)")
            document.backgroundURL = url
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
}

// struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        EmojiArtDocumentView(document: EmojiArtDocument())
//    }
// }
