//
//  Spinning.swift
//  EmojiArt
//
//  Created by Jiaxin Shou on 2021/1/4.
//

import SwiftUI

struct Spinning: ViewModifier {
    @State var isVisible: Bool = false

    func body(content: Content) -> some View {
        content
            .rotationEffect(Angle(degrees: isVisible ? 360 : 0))
            .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
            .onAppear {
                isVisible = true
            }
    }
}

extension View {
    func spinning() -> some View {
        modifier(Spinning())
    }
}
