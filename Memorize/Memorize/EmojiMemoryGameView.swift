//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Jiaxin Shou on 2020/12/18.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame

    var body: some View {
        Grid(viewModel.cards) { card in
            CardView(card: card).onTapGesture {
                viewModel.choose(card: card)
            }
            .padding(5)
        }
        .padding()
        .foregroundColor(.orange)
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if card.isFaceUp {
                    // Front
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Color.white)
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(lineWidth: edgelineWidth)
                    Text(card.content)
                } else if !card.isMatched {
                    // Back
                    RoundedRectangle(cornerRadius: 10)
                        .fill()
                }
            }
            .font(Font.system(size: fontSize(for: geometry.size)))
        }
    }

    // MARK: - Drawing Constants

    let cornerRadius: CGFloat = 10
    let edgelineWidth: CGFloat = 3

    func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.75
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}
