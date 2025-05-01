//
//  FoodView.swift
//  Categories
//
//  Created by Carson Payne on 4/30/25.
//

import SwiftUI

// Meal data structure based on TheMealDB API response
struct Meal: Decodable {
    let meals: [MealDetail]
}

struct MealDetail: Decodable {
    let strMeal: String
    let strMealThumb: String // URL for the meal thumbnail
}

struct FoodView: View {
    @State private var mealImageUrl: String?
    @State private var mealName: String = "Loading..."
    
    let apiURL = "https://www.themealdb.com/api/json/v1/1/random.php" // Random meal endpoint
    
    var body: some View {
        VStack {
            if let mealImageUrl = mealImageUrl, let url = URL(string: mealImageUrl) {
                // Using AsyncImage for loading the image
                AsyncImage(url: url) { image in
                    image.resizable()
                         .scaledToFill()
                         .frame(width: 300, height: 200)
                         .cornerRadius(12)
                } placeholder: {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                }
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }

            Text(mealName)
                .font(.title)
                .padding(.top, 20)
        }
        .onAppear {
            fetchMealData()
        }
    }
    
    // Function to fetch meal data from the API
    func fetchMealData() {
        guard let url = URL(string: apiURL) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode(Meal.self, from: data)
                    DispatchQueue.main.async {
                        if let meal = decodedResponse.meals.first {
                            self.mealImageUrl = meal.strMealThumb
                            self.mealName = meal.strMeal
                        }
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            }
        }
        task.resume()
    }
}

struct FoodView_Previews: PreviewProvider {
    static var previews: some View {
        FoodView()
    }
}
