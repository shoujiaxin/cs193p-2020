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
                Text("Remaining: \(setGame.numberOfRemainingCards)")

                Spacer()

                Text("Score: \(setGame.score)")
            }
            .padding()
            .font(.headline)

            Grid(setGame.cards) { card in
                CardView(of: card)
                    .padding(6)
                    .onTapGesture {
                        setGame.select(card: card)
                    }
            }
            .onAppear {
                withAnimation(.easeInOut) {
                    setGame.dealCards(to: 12)
                }
            }

            Button("New Game") {
                withAnimation(.easeInOut) {
                    setGame.newGame()
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
