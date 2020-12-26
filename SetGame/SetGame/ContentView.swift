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

                Button("New Game") {
                    withAnimation(.easeInOut) {
                        setGame.newGame()
                    }
                }
            }
            .padding()
            .font(.headline)

            Grid(setGame.cards) { card in
                CardView(of: card)
                    .padding(6)
                    .transition(AnyTransition.offset(x: CGFloat.random(in: -500 ... 500), y: CGFloat.random(in: -500 ... 500)))
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            setGame.select(card: card)
                        }
                    }
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 2)) {
                    setGame.dealCards(to: 12)
                }
            }

            Button("No Set") {
                withAnimation(.easeInOut) {
                    setGame.dealCards(to: setGame.cards.count + 3)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(setGame: SetGame())
    }
}
