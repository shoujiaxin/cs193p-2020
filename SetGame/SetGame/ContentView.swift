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
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: Int(ceil(Double(setGame.cards.count) / 4)))) {
                ForEach(setGame.cards) { card in
                    CardView(of: card)
                }
            }
            .padding()

            Spacer()
        }
        .onAppear {
            setGame.dealCards(12)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(setGame: SetGame())
    }
}
