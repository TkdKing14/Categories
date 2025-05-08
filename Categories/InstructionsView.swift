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
                Image("contentbackground") //shows background
                    .resizable() //make it resizeable
                    .aspectRatio(contentMode: .fill) //shows full screen
                    .mask(
                        RadialGradient( //makes the view more faded as go out to side
                            gradient: Gradient(colors: [.white, .clear]), //color
                            center: .center,
                            startRadius: 100,//where it starts fadding
                            endRadius: 490 //where it endes fadding
                        )
                        .frame(maxWidth: .infinity, maxHeight: .infinity) //so it goes on infinity
                    )
                    .ignoresSafeArea() //shows entire screeen
                VStack {
                    Text("Instructions") //shpes title
                        .font(.custom("Marker Felt", size: 70)) //custom font and size
                        .padding()//placeholder
                    spacer(text: "")//spacing
                    spacer(text: "")//spacing
                    spacer(text: "")//spacing
                    about(text: "1.) First Click Play to Start")//steps
                    about(text: "2.) Choose Your Gamemode To Play.")//steps
                    about(text: "3.) Choose if You Like Category or Not.")//steps
                    about(text: "4.) Click Checkmark If You Like The Picture.")//steps
                    about(text: "5.) Click X If You Dont Like The Picture.")//steps
                }
                .padding()//placeholder
            }
        }
    }
}

#Preview {
    InstructionsView()
}

struct about: View { //custom fonts for writing
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
struct spacer: View { //custom font to space it out
    let text: String
    var body: some View {
        Text(text)
            .font(.custom("Marker Felt", size: 22))
            .padding()
    }
}
