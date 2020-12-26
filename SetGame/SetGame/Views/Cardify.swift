//
//  Cardify.swift
//  SetGame
//
//  Created by Jiaxin Shou on 2020/12/26.
//

import SwiftUI

struct Cardify: ViewModifier {
    var isSelected: Bool

    func body(content: Content) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(lineWidth: edgelineWidth)
                .foregroundColor(.primary)

            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(isSelected ? Color.gray : Color.white)

            content
        }
//        .aspectRatio(0.65, contentMode: .fit)
    }

    // MARK: - Drawing Constants

    private let cornerRadius: CGFloat = 10
    private let edgelineWidth: CGFloat = 3
}

extension View {
    func cardify(isSelected: Bool) -> some View {
        modifier(Cardify(isSelected: isSelected))
    }
}
