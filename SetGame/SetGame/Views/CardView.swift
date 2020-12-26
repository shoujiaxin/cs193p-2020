//
//  CardView.swift
//  SetGame
//
//  Created by Jiaxin Shou on 2020/12/25.
//

import SwiftUI

struct CardView: View {
    var card: Card

    init(of card: Card) {
        self.card = card
    }

    var body: some View {
        VStack {
            ForEach(0 ..< card.numberOfShapes.rawValue) { _ in
                CardShape(of: card)
                    .shading()
            }
        }
        .padding()
        .cardify(isSelected: card.isSelected)
        .foregroundColor(card.color.toViewColor())
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let card = Card(
            numberOfShapes: .three,
            shape: .squiggle,
            shading: .striped,
            color: .red
        )
        return CardView(of: card)
            .previewLayout(.fixed(width: 130, height: 100))
    }
}
