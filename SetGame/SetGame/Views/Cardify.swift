//
//  Cardify.swift
//  SetGame
//
//  Created by Jiaxin Shou on 2020/12/26.
//

import SwiftUI

struct Cardify: ViewModifier {
    var isSelected: Bool
    var isMatch: Bool?

    func body(content: Content) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(lineWidth: edgelineWidth)
                .foregroundColor(isMatch == nil ? .primary : (isMatch! ? .accentColor : .red)) // Assignment 3.7

            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(isSelected ? Color.gray : Color("CardBackgroundColor")) // Assignment 3.6

            content
        }
    }

    // MARK: - Drawing Constants

    private let cornerRadius: CGFloat = 10
    private let edgelineWidth: CGFloat = 4
}

extension View {
    func cardify(isSelected: Bool, isMatch: Bool?) -> some View {
        modifier(Cardify(isSelected: isSelected, isMatch: isMatch))
    }
}
