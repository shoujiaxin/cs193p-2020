//
//  CardShape.swift
//  SetGame
//
//  Created by Jiaxin Shou on 2020/12/25.
//

import SwiftUI

struct CardShape: Shape {
    var card: Card

    init(of card: Card) {
        self.card = card
    }

    func path(in rect: CGRect) -> Path {
        let shapeWidth = rect.width
        let shapeHeight = shapeWidth / aspectRatio
        let originX = rect.origin.x
        let originY = (rect.height - shapeHeight) / 2
        let shapeRect = CGRect(x: originX, y: originY, width: shapeWidth, height: shapeHeight)

        switch card.shape {
        case .diamond: return pathOfDiamond(in: shapeRect)
        case .oval: return Capsule().path(in: shapeRect)
        case .squiggle: return pathOfSquiggle(in: shapeRect)
        }
    }

    func pathOfDiamond(in rect: CGRect) -> Path {
        let top = CGPoint(x: rect.midX, y: rect.minY)
        let left = CGPoint(x: rect.minX, y: rect.midY)
        let bottom = CGPoint(x: rect.midX, y: rect.maxY)
        let right = CGPoint(x: rect.maxX, y: rect.midY)

        var p = Path()
        p.move(to: top)
        p.addLine(to: left)
        p.addLine(to: bottom)
        p.addLine(to: right)
        p.addLine(to: top)

        return p
    }

    func pathOfSquiggle(in _: CGRect) -> Path {
        var p = Path()

        return p
    }

    // MARK: - Drawing Constants

    private let aspectRatio: CGFloat = 2
}
