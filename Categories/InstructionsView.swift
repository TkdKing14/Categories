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
                            endRadius: 490
                        )
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    )
                    .ignoresSafeArea()
                
                VStack  {
                    
                    about(text: " 1.) First Click Play to Start")
                    Spacer()
                    about(text: "2.) Then Choose What Gamemode You")
                    about(text: "To Play.")
                    Spacer()
                    about(text: "3.) Start Playing")
                        .padding()
                }
                Spacer()
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
        Text(text).font(.custom("Marker Felt", size: 25))
    }
}
