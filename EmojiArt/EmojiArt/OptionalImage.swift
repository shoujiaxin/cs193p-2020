//
//  OptionalImage.swift
//  EmojiArt
//
//  Created by Jiaxin Shou on 2020/12/29.
//

import SwiftUI

struct OptionalImage: View {
    var uiImage: UIImage?

    var body: some View {
        Group {
            if let uiImage = uiImage {
                Image(uiImage: uiImage)
            }
        }
    }
}
