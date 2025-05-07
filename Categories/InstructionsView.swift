//
//  InstructionsView.swift
//  Categories
//
//  Created by Rohan Patel on 4/15/25.
//

import SwiftUI

struct InstructionsView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Image("contentbackground")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .mask(
                        RadialGradient(
                            gradient: Gradient(colors: [.white, .clear]),
                            center: .center,
                            startRadius: 100,
                            endRadius: 415
                        )
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    )
                    .ignoresSafeArea()
                VStack {
                    Text("Instructions")
                        .font(.custom("Marker Felt", size: 70))
                        .padding()
                    spacer(text: "")
                    spacer(text: "")
                    spacer(text: "")
                    about(text: "1.) First Click Play to Start")
                    about(text: "2.) Choose Your Gamemode To Play.")
                    about(text: "3.) Choose if You Like Category or Not.")
                    about(text: "4.) Click Checkmark If You Like The Picture.")
                    about(text: "5.) Click X If You Dont Like The Picture.")
                }
                .padding()
            }
        }
    }
}

#Preview {
    InstructionsView()
}

struct about: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.custom("Marker Felt", size: 22))
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.8))
                    .shadow(radius: 4)
            )
            .foregroundColor(.black)
    }
}
struct spacer: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.custom("Marker Felt", size: 22))
            .padding()
    }
}
