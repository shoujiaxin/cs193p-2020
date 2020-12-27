//
//  ContentView.swift
//  SetGame
//
//  Created by Jiaxin Shou on 2020/12/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var setGame: SetGame

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Remaining: \(setGame.numberOfRemainingCards)")
                    Text("Score: \(setGame.score)")
                }
                Spacer()

                // Assignment 3.12
                Button("New Game") {
                    withAnimation(.easeInOut(duration: animationDuration)) {
                        setGame.resetGame()
                    }
                }
            }
            .padding()
            .font(.headline)

            // Assignment 3.3
            Grid(setGame.cards) { card in
                CardView(of: card)
                    .padding(6)
                    .transition(AnyTransition.offset(x: CGFloat.random(in: -1000 ... 1000), y: CGFloat.random(in: -1000 ... 1000)))
                    .onTapGesture {
                        if card.isSelected {
                            setGame.deselect(card)
                        } else {
                            if setGame.numberOfSelectedCards == 3 {
                                if setGame.hasMatched {
                                    withAnimation(.easeInOut(duration: animationDuration)) {
                                        setGame.removeMatched()
                                        setGame.dealCards(to: 12)
                                    }
                                } else {
                                    setGame.deselectAll()
                                }
                            }
                            setGame.select(card)
                        }
                    }
            }
            .onAppear {
                // Assignment 3.2
                withAnimation(.easeInOut(duration: animationDuration)) {
                    setGame.dealCards(to: 12)
                }
            }

            // Assignment 3.11
            Button("Deal 3 More Cards") {
                withAnimation(.easeInOut(duration: animationDuration)) {
                    if setGame.hasMatched {
                        setGame.removeMatched()
                    }
                    setGame.dealCards(to: setGame.cards.count + 3)
                }
            }
            .disabled(setGame.numberOfRemainingCards == 0)
        }
    }

    private let animationDuration: Double = 1.5
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(setGame: SetGame())
    }
}
