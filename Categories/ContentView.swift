//
//  ContentView.swift
//  Categories
//
//  Created by Carson Payne on 4/1/25.
//

import SwiftUI

struct ContentView: View {
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
                        .frame(maxWidth: .infinity, maxHeight: .infinity) //it fully fill everything
                    )
                    .ignoresSafeArea() //ignore safe area
                VStack {
                    title(text:"Categories") //title
                        .font(.title).bold() //font
                        .foregroundColor(.black) //color
                    Spacer() //placeholder
                    NavigationLink(destination: CategoriesView(CategoryCounters: CategoryCounters)) { //link to cateroriges view
                        Text("Play") //what it says
                            .font(Font.custom("Marker Felt", size: 53)) //font
                            .foregroundColor(.black) //color
                    }
                    NavigationLink(destination: InstructionsView()) { //link to instructions view
                        Text("How To Play") //what it says
                            .font(Font.custom("Marker Felt", size: 53)) //size and font
                            .foregroundColor(.black) //color
                            .padding() //spaceholder
                    }
                }
            }
        }
    }
}
#Preview {
    ContentView()
}
struct title: View { //custom text
    let text: String
    var body: some View {
        Text(text).font(.custom("Marker Felt", size: 65))
    }
}

