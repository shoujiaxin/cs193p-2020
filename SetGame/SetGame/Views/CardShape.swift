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

        var path = Path()
        path.move(to: top)
        path.addLine(to: left)
        path.addLine(to: bottom)
        path.addLine(to: right)
        path.addLine(to: top)

        return path
    }

    func pathOfSquiggle(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: 104.0, y: 15.0))
        path.addCurve(to: CGPoint(x: 63.0, y: 54.0),
                      control1: CGPoint(x: 112.4, y: 36.9),
                      control2: CGPoint(x: 89.7, y: 60.8))
        path.addCurve(to: CGPoint(x: 27.0, y: 53.0),
                      control1: CGPoint(x: 52.3, y: 51.3),
                      control2: CGPoint(x: 42.2, y: 42.0))
        path.addCurve(to: CGPoint(x: 5.0, y: 40.0),
                      control1: CGPoint(x: 9.6, y: 65.6),
                      control2: CGPoint(x: 5.4, y: 58.3))
        path.addCurve(to: CGPoint(x: 36.0, y: 12.0),
                      control1: CGPoint(x: 4.6, y: 22.0),
                      control2: CGPoint(x: 19.1, y: 9.7))
        path.addCurve(to: CGPoint(x: 89.0, y: 14.0),
                      control1: CGPoint(x: 59.2, y: 15.2),
                      control2: CGPoint(x: 61.9, y: 31.5))
        path.addCurve(to: CGPoint(x: 104.0, y: 15.0),
                      control1: CGPoint(x: 95.3, y: 10.0),
                      control2: CGPoint(x: 100.9, y: 6.9))

        let pathRect = path.boundingRect
        let scale: CGFloat = rect.width / pathRect.width
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        path = path.applying(transform)

        return path
            .offsetBy(dx: rect.minX - path.boundingRect.minX, dy: rect.midY - path.boundingRect.midY)
    }

    // MARK: - Drawing Constants

    private let aspectRatio: CGFloat = 2
}

extension CardShape {
    func shading() -> some View {
        Group {
            switch card.shading {
            case .solid:
                self
                    .fill()

            case .striped:
                ZStack {
                    self
                        .stroke()
                    self
                        .mask(Stripes().stroke())
                }

            case .open:
                self
                    .stroke()
            }
        }
    }
}
