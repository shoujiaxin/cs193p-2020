//
//  Stripes.swift
//  SetGame
//
//  Created by Jiaxin Shou on 2020/12/25.
//

import SwiftUI

struct Stripes: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        var x = rect.minX
        while x < rect.maxX {
            path.move(to: CGPoint(x: x, y: rect.minY))
            path.addLine(to: CGPoint(x: x, y: rect.maxY))

            x += stripeSpacing
        }

        return path
    }

    // MARK: - Drawing Constants

    private let stripeSpacing: CGFloat = 6
}
