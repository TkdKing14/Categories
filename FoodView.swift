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
    @ObservedObject var CategoryCounters: categoryCounters
    @State private var mealImageUrl: String?
    @State private var mealName: String = "Loading..."
    @State private var greenButtonClickCount = 0
    @State private var redButtonClickCount = 0
    @State private var showingAlert = false

    let apiURL = "https://www.themealdb.com/api/json/v1/1/random.php"
    //sets up the text based on the users choices
    var preferenceMessage: String {
        if greenButtonClickCount > redButtonClickCount {
            return "😃"
        } else if redButtonClickCount > greenButtonClickCount {
            return "Picky eater? 😢"
        } else if greenButtonClickCount == 0 && redButtonClickCount == 0 {
            return ""
        } else {
            return "🤔"
        }
    }

    var body: some View {
        ZStack {
            // Background Image
            Image("foodBackground")
                .resizable()
                .scaledToFill()
                .blur(radius: 5)
                .opacity(0.25)
                .ignoresSafeArea()

            VStack {
                Text("Food!")
                    .font(.largeTitle)
                    .padding(.top)
//displays the image that was grabbed from the api
                if let mealImageUrl = mealImageUrl, let url = URL(string: mealImageUrl) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 200)
                            .cornerRadius(12)
                            .padding(.vertical)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 300, height: 200)
                    }
                } else {
                    ProgressView()
                        .frame(width: 300, height: 200)
                }

                Text(mealName)
                    .font(.title2)
                    .padding(.bottom)

                HStack(spacing: 80) {
                    //makes the buttons that the user can play with
                    VStack {
                        Button {
                            greenButtonClickCount += 1
                            CategoryCounters.foodGreenCount += 1
                            fetchMealData()
                        } label: {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                                .font(.system(size: 75))
                        }
                        Text("\(greenButtonClickCount)")
                            .font(.title2)
                            .foregroundColor(.green)
                    }

                    VStack {
                        Button {
                            redButtonClickCount += 1
                            CategoryCounters.foodRedCount += 1
                            fetchMealData()
                        } label: {
                            Image(systemName: "x.circle.fill")
                                .foregroundStyle(.red)
                                .font(.system(size: 75))
                        }
                        Text("\(redButtonClickCount)")
                            .font(.title2)
                            .foregroundColor(.red)
                    }
                }
                .padding(.bottom)
//displays the text that was grabbed from the code above and displayes it below the buttons
                if !preferenceMessage.isEmpty {
                    Text(preferenceMessage)
                        .font(.headline)
                        .padding(.top)
                        .transition(.opacity)
                }
            }
            .padding()
        }
        //when the text appears fetch meal data is called
        .onAppear {
            fetchMealData()
        }
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Error"),
                message: Text("Could not load meal data."),
                dismissButton: .default(Text("OK"))
            )
        }
        .animation(.easeInOut, value: preferenceMessage)
    }

    // Fetch random meal from TheMealDB API
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
                    //shows if the code was able to display or not by showing an error message
                } catch {
                    DispatchQueue.main.async {
                        showingAlert = true
                    }
                    print("Decoding error: \(error)")
                }
                //if any other thing was selected, it would result in the following code that shows a network error
            } else {
                DispatchQueue.main.async {
                    showingAlert = true
                }
                print("Network error: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
        task.resume()
    }
}
//allows the code to be previwed
struct FoodView_Previews: PreviewProvider {
    static var previews: some View {
        FoodView(CategoryCounters: categoryCounters())
    }
}
