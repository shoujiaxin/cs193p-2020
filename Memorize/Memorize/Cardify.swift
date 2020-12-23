//
//  Cardify.swift
//  Memorize
//
//  Created by Jiaxin Shou on 2020/12/23.
//

import SwiftUI

struct Cardify: ViewModifier {
    var isFaceUp: Bool

    func body(content: Content) -> some View {
        ZStack {
            if isFaceUp {
                // Front
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(lineWidth: edgelineWidth)
                content
            } else {
                // Back
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill()
            }
        }
    }

    private let cornerRadius: CGFloat = 10
    private let edgelineWidth: CGFloat = 3
}

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        modifier(Cardify(isFaceUp: isFaceUp))
    }
}
