//
//  ContentView.swift
//  Categories
//
//  Created by Carson Payne on 4/1/25.
//

import SwiftUI

// here is an example comment
struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                title(text:"Categories")
                    .font(.title).bold()
                    .foregroundColor(.black)
                Spacer()
                NavigationLink("How to Play", destination: InstructionsView())
                    .font(Font.custom("Marker Felt", size: 31))
                    .padding()
            }
        }
    }
}

    


#Preview {
    ContentView()
}
struct title: View {
    let text: String
    var body: some View {
        Text(text).font(.custom("Marker Felt", size: 55))
    }
}
