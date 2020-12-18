//
//  ContentView.swift
//  Memorize
//
//  Created by Jiaxin Shou on 2020/12/18.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HStack {
            ForEach(0 ..< 4) { _ in
                CardView(isFaceUp: false)
            }
        }
        .padding()
        .foregroundColor(.orange)
        .font(.largeTitle)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CardView: View {
    var isFaceUp: Bool

    var body: some View {
        ZStack {
            if isFaceUp {
                // Front
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 3)
                Text("👻")
            } else {
                // Back
                RoundedRectangle(cornerRadius: 10)
                    .fill()
            }
        }
    }
}
