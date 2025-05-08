//
//  PokemonView.swift
//  Categories
//
//  Created by Carson Payne on 5/2/25.
//

import SwiftUI

// Represents a single Pokémon's data fetched from the API
struct Pokemon: Decodable {
    let name: String      // Shows Pokémon name
    let sprites: Sprites  // Shows Sprites or Pictures
}

// Represents the sprites object, containing image URLs
struct Sprites: Decodable {
    let front_default: String?    // Default front image URL
}

struct PokemonView: View {
    @ObservedObject var categoryCounters: categoryCounters // Shared counters for user input
    @State private var pokemonName: String = "Loading..."  // Stores current Pokémon's name
    @State private var pokemonImageURL: String?            // URL of the current Pokémon image
    @State private var greenButtonClickCount = 0           // User likes count
    @State private var redButtonClickCount = 0             // User dislikes count
    @State private var showingAlert = false                // Alert toggle for errors
    
    func randomPokemonURL() -> URL { //gets the random pokemon
        let randomID = Int.random(in: 1...898) //chooses 1 random pokemon
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(randomID)") else { //url for api
            fatalError("Invalid URL") //if not connected to internet this shows
        }
        return url //makes it so the image changes
    }
    
    var preferenceMessage: String {
        if greenButtonClickCount > redButtonClickCount { //decides if you like it more than dont like
            return "You like Pokémon 😃" //result
        } else if redButtonClickCount > greenButtonClickCount {// //decides if you dont like it more than like it
            return "Not a fan of Pokémon? 😢"//result
        } else if greenButtonClickCount == 0 && redButtonClickCount == 0 { //if nothing
            return "" //result
        } else { //even tie
            return "🤔" //result
        }
    }
    
    
    var body: some View {
        ZStack {
            Image("pokemonBackground") //  Creates Background Image
                .resizable()  //makes it able to change
                .scaledToFill() //makes background
                .blur(radius: 5) //adds blury affect
                .opacity(0.25) //makes it a little blurry
                .ignoresSafeArea() //so it the entire screen
            
            VStack {
                Text("Pokémon") //title
                    .font(.largeTitle) //font
                    .padding(.top)//makes it on the top
                
                if let imageUrl = pokemonImageURL, let url = URL(string: imageUrl) { //display pokemon sprite
                    AsyncImage(url: url) { image in
                        image.resizable() //makes so image move with pokemon to look natural
                            .scaledToFit() // changes it to fit screen if to big
                            .frame(width: 200, height: 200) //where it loaded
                            .padding() //spaceholder
                    } placeholder: {
                        ProgressView() //view that loads while pokemon is being generated
                            .frame(width: 200, height: 200) //where it loaded
                    }
                } else {
                    ProgressView() // Placeholder while image loads
                        .frame(width: 200, height: 200) //where it loaded
                }
                
                Text(pokemonName.capitalized) // Show Pokémon name in a capitalized form
                    .font(.title2) //font
                    .padding(.bottom) //make space between it an buttons
                
                // Buttons: Like (green) and Dislike (red)
                HStack(spacing: 80) { //spacing in between bettons
                    VStack {
                        Button {         // Like Button
                            greenButtonClickCount += 1 //adds to variable to show +1 under button
                            categoryCounters.pokemonGreenCount += 1 //adds to variable to show +1 in life time score
                            fetchPokemon() //makes the pokemon actully spawn in
                        } label: {
                            Image(systemName: "checkmark.circle.fill") //the buttins system name so it is actully a checkmark
                                .foregroundStyle(.green) //color
                                .font(.system(size: 75)) //size
                        }
                        Text("\(greenButtonClickCount)") //number under checkmark button
                            .font(.title2) //size
                            .foregroundColor(.green) //color
                    }
                    
                    VStack {
                        Button {      // Dislike Button
                            redButtonClickCount += 1 //adds to variable to show +1 under button
                            categoryCounters.pokemonRedCount += 1 //adds to variable to show +1 in life time score
                            fetchPokemon() //makes the pokemon actully spawn in
                        } label: {
                            Image(systemName: "x.circle.fill") //the buttins system name so it is actully a x
                                .foregroundStyle(.red) //color
                                .font(.system(size: 75)) //size
                        }
                        Text("\(redButtonClickCount)") //number under x button
                            .font(.title2) //size
                            .foregroundColor(.red) //color
                    }
                }
                .padding(.bottom)
                
                
                if !preferenceMessage.isEmpty { // Display user's preference
                    Text(preferenceMessage) //writes the text
                        .font(.headline) //font
                        .padding(.top) //spot
                        .transition(.opacity) //transpacercy
                }
            }
            .padding()
        }
        .onAppear {
            fetchPokemon()   // Fetch first Pokémon when the view appears
        }
        .alert(isPresented: $showingAlert) { //shows alert
            Alert( // Alert if there is an error loading data
                title: Text("Error"), //error messages title
                message: Text("Couldn't load Pokémon data."), //error messages text
                dismissButton: .default(Text("OK")) //button for people to click okay if code dosent work
            )
        }
        .animation(.easeInOut, value: preferenceMessage) // Smooth animation for message change
    }
    func fetchPokemon() { // Function to fetch a random Pokémon from the API
        let url = randomPokemonURL() // Generate a random Pokémon API URL
        URLSession.shared.dataTask(with: url) { data, _, error in // Create a data task to fetch data from the API
            if let data = data { // If data is successfully received
                do {
                    let decoded = try JSONDecoder().decode(Pokemon.self, from: data)  // Tries decoding the JSON data into our Pokemon model
                    DispatchQueue.main.async { // Update UI on the main thread
                        self.pokemonName = decoded.name // Set the Pokémon's name
                        self.pokemonImageURL = decoded.sprites.front_default // Set the image URL
                    }
                } catch {
                    DispatchQueue.main.async { // If decoding fails it shows an alert on the main thread
                        showingAlert = true //sets to show alert
                    }
                }
            } else {
                DispatchQueue.main.async {    // If no data is received it shows an alert on the main thread
                    showingAlert = true //sets to show alert
                }
            }
        }.resume() // Start the network request
    }
}

#Preview {
    PokemonView(categoryCounters: categoryCounters())
}
