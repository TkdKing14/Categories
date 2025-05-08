//
//  dogsView.swift
//  Categories
//
//  Created by Rohan Patel on 4/24/25.
//

import SwiftUI

struct DogImageResponse: Codable {
    let message: String
}

struct dogsView: View {
    @ObservedObject var CategoryCounters: categoryCounters
    @State private var imageUrl: String?
    @State private var isLoading = false
    @State private var greenButtonClickCount = 0
    @State private var redButtonClickCount = 0
    
    var preferenceMessage: String {
        if greenButtonClickCount > redButtonClickCount { //if u like it more than dont
            return "You like dogs 😃" //result
        } else if redButtonClickCount > greenButtonClickCount { //if u dont like it more than u do
            return "Not a fan of dogs? 😢" //result
        } else if greenButtonClickCount == 0 && redButtonClickCount == 0 { //if havent pushed button
            return "" //result
        } else { //if tied
            return "🤔" //result
        }
    }
    
    var body: some View {
        ZStack {
            Image("dogBackground")//background image
                .resizable()//makes it resizeable
                .scaledToFill() //so it fit the entire screen
                .blur(radius: 5)// where the blurring starts
                .opacity(0.25) //how much blur
                .ignoresSafeArea() //so entire screen counting safe area
            
            VStack {
                Text("Dogs") //title
                    .font(.largeTitle)//font
                    .padding(.top)//space
                Spacer() //placeholder
                if let imageUrl, let url = URL(string: imageUrl) {   // Check imageUrl to make sure it works and then try to create a URL object from it
                    AsyncImage(url: url) { phase in  // Load the image asynchronously from the URL
                        switch phase { // Handle the different loading phases
                            
                        case .empty:
                            ProgressView() // Show a loading spinner
                            
                            // When the image successfully loads
                        case .success(let image):
                            image
                                .resizable() // Make resizable
                                .scaledToFit() // Scale the image to fit
                                .cornerRadius(12) // Apply rounded corners
                                .padding() // placeholder
                            
                            
                        case .failure:  // If the image fails to load
                            Text("Failed to load image") // Show an error message
                        @unknown default: // Handle any future unknown cases
                            EmptyView() // Display an empty view for safety
                        }
                    }
                } else if isLoading { //loads image if all passes
                    ProgressView() // Show a loading spinner
                }
                Spacer() //placeholder
                HStack(spacing: 80) { //space between buttons
                    VStack {
                        Button { //shows checkmark button
                            fetchDogImage() //generates image
                            greenButtonClickCount += 1 //adds to counter below checkmark
                            CategoryCounters.dogGreenCount += 1 //adds to life time counter
                        } label: {
                            Image(systemName: "checkmark.circle.fill") //the buttons system name so it is actully a checkmark
                                .foregroundStyle(.green) //color
                                .font(.system(size: 75))//size
                        }
                        Text("\(greenButtonClickCount)") //displays text below button
                            .font(.title2) //font
                            .foregroundColor(.green) //color
                    }
                    VStack {
                        Button { //shows x button
                            fetchDogImage() //generates image
                            redButtonClickCount += 1 //adds to counter below x
                            CategoryCounters.dogRedCount += 1 //adds to life time counter
                        } label: {
                            Image(systemName: "x.circle.fill") //the buttons system name so it is actully a x
                                .foregroundStyle(.red) //color
                                .font(.system(size: 75)) //size
                        }
                        Text("\(redButtonClickCount)") //displays text below button
                            .font(.title2) //font
                            .foregroundColor(.red) //color
                    }
                }
                .padding(.bottom, 10) //spacer
                
                if !preferenceMessage.isEmpty { //displays varabile for if like or not
                    Text(preferenceMessage) //text
                        .font(.headline) //location
                        .padding(.top, 10) //space
                        .transition(.opacity) //opacity
                }
            }
            .padding()
        }
        .onAppear(perform: fetchDogImage)
        .animation(.easeInOut, value: preferenceMessage)  //shows smooth animation
    }
    
    func fetchDogImage() { //gets image
        isLoading = true //so no eroor
        guard let url = URL(string: "https://dog.ceo/api/breeds/image/random") else { return } //url for api
        Task {  // Start a new task
            do {
                let (data, _) = try await URLSession.shared.data(from: url) // Try to fetch data from the given URL
                let result = try JSONDecoder().decode(DogImageResponse.self, from: data)  // Try to decode the JSON response
                imageUrl = result.message  // Assign the decoded image URL
            } catch {
                print("Error: \(error)") // If an error occurs in fetching or decoding, print the error to the console
            }
            isLoading = false  // Set the loading state to false
        }
    }
}
#Preview {
    dogsView(CategoryCounters: categoryCounters())
}
