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
        Button(action: {
            // put action here i think
            print("Checkmark button tapped")
        }) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
                .font(.system(size: 50))
                .padding()
        }
        .position(x: 75, y: 448)

        .padding()
        Button(action: {
            // put action here i think
            print("X button tapped")
        }) {
            Image(systemName: "x.circle.fill")
                .foregroundStyle(.red)
                .font(.system(size: 50))
                .padding()
        }
        .position(x: 300, y: 100)

    }
}

#Preview {
    SelectionView()
}
struct CustomText: View {
    let text: String
    var body: some View {
        Text(text).font(.custom("Marker Felt", size: 30))
    }
}

