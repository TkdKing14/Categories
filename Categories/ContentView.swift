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
        VStack {
            CustomText(text:"Categories")
                .font(.title).bold()
                .foregroundColor(.black)
            Spacer()
        }
       
    }
}

#Preview {
    ContentView()
}
struct CustomText: View {
    let text: String
    var body: some View {
        Text(text).font(.custom("Marker Felt", size: 55))
    }
}
