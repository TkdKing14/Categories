//
//  SelectionView.swift
//  Categories
//
//  Created by Carson Payne on 4/15/25.
//

import SwiftUI

struct SelectionView: View {
    var body: some View {
        VStack {
            CustomText(text:"Categories")
                .font(.title).bold()
                .foregroundColor(.black)
        }
        Image(systemName: "checkmark.circle.fill")
            .foregroundStyle(.green)
            .foregroundStyle(.tint)
            .position(x: 75, y: 100)
        .padding()
        
        Image(systemName: "x.circle.fill")
            .foregroundStyle(.red)
            .foregroundStyle(.tint)
            .position(x: 300, y: -260)
        .padding()
    }
}

#Preview {
    ContentView()
}
struct CustomText: View {
    let text: String
    var body: some View {
        Text(text).font(.custom("Marker Felt", size: 30))
    }
}

