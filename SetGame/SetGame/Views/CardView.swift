//
//  CardView.swift
//  SetGame
//
//  Created by Jiaxin Shou on 2020/12/25.
//

import SwiftUI

struct CardView: View {
    var card: Card

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(lineWidth: edgelineWidth)

            VStack {
                ForEach(0 ..< card.numberOfShapes.rawValue) { _ in
                    CardShape(of: card)
                }
            }
            .padding()
            .foregroundColor(card.color.toViewColor())
        }
    }

    // MARK: - Drawing Constants

    private let cornerRadius: CGFloat = 10
    private let edgelineWidth: CGFloat = 3
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let card = Card(
            numberOfShapes: Card.NumberOfShapes.allCases.randomElement()!,
            shape: Card.Shape.allCases.randomElement()!,
            shading: Card.Shading.allCases.randomElement()!,
            color: Card.Color.allCases.randomElement()!
        )
        return CardView(card: card)
            .previewLayout(.fixed(width: 130, height: 200))
    }
}
