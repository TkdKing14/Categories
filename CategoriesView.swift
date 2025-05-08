//
//  CategoriesView.swift
//  Categories
//
//  Created by Carson Payne on 4/21/25.
//

import SwiftUI
import Combine // helps when transfering data

class categoryCounters: ObservableObject {
    @Published var catGreenCount: Int = 0
    @Published var catRedCount: Int = 0
    @Published var dogGreenCount: Int = 0
    @Published var dogRedCount: Int = 0
    @Published var foodGreenCount: Int = 0
    @Published var foodRedCount: Int = 0
    @Published var pokemonGreenCount: Int = 0
    @Published var pokemonRedCount: Int = 0
}
// sets up view for data transfer
let CategoryCounters = categoryCounters()
struct CategoriesView: View {
    @ObservedObject var CategoryCounters: categoryCounters
    let categories: [String] = categoriesList
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background Image
                Image("contentbackground")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .opacity(0.2)
                
                // Scrollable Content
                ScrollView {
                    VStack(spacing: 20) {
                        // Category List
                        ForEach(categories, id: \.self) { category in
                            NavigationLink(destination: destinationView(for: category)) {
                                HStack {
                                    categoryIcon(for: category)
                                    Text(category)
                                        .font(.headline)
                                }
                                .padding()
                                .background(Color.white.opacity(0.7))
                                .cornerRadius(10)
                                .shadow(radius: 2)
                                .padding(.horizontal)
                            }
                        }
                        // Score Section that displayes the all time score. (The in view numbers will be reset to zero if the view is left. the ifetiem scire will still be accumulated.)
                        VStack(spacing: 17.5) {
                            Text("Lifetime Score (👍 to 👎)")
                                .bold()
                                .font(.headline)
                                .underline(true, color: .gray)

                            Text("Food Score: \(CategoryCounters.foodGreenCount) to \(CategoryCounters.foodRedCount)")
                            Text("Cat Score: \(CategoryCounters.catGreenCount) to \(CategoryCounters.catRedCount)")
                            Text("Dog Score: \(CategoryCounters.dogGreenCount) to \(CategoryCounters.dogRedCount)")
                            Text("Pokemon Score: \(CategoryCounters.pokemonGreenCount) to \(CategoryCounters.pokemonRedCount)")
                        }
                        .padding()
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                    .padding(.top)
                }
            }
            .navigationTitle("Categories")
        }
    }
// takes you to trhe specific view and destination based on the text and icon
    @ViewBuilder   // allows each view to be refereced while still remaining in one
    func destinationView(for category: String) -> some View {
        if category == "Cats" {
            CatView(CategoryCounters: CategoryCounters)
        } else if category == "Dogs" {
            dogsView(CategoryCounters: CategoryCounters)
        } else if category == "Food" {
            FoodView(CategoryCounters: CategoryCounters)
        } else if category == "Pokemon" {
            PokemonView(categoryCounters: CategoryCounters)
        }
    }
//the following code sets up how each icon looks depending on the gamemode. the let iconName and Color allow each variable to be changed induvidually
    func categoryIcon(for category: String) -> some View {
        let iconName: String
        let iconColor: Color
        switch category {
        case "Cats":
            iconName = "cat.fill"
            iconColor = .green
        case "Food":
            iconName = "fork.knife"
            iconColor = .red
        case "Dogs":
            iconName = "dog.fill"
            iconColor = .blue
        case "Pokemon":
            iconName = "bolt.fill"
            iconColor = .yellow
        default:
            iconName = "airplane"
            iconColor = .blue
        }
        return Image(systemName: iconName)
            .padding(10)
            .background(iconColor)
            .foregroundColor(.white)
            .clipShape(Circle())
    }
}


#Preview {
    CategoriesView(CategoryCounters: CategoryCounters)
}
