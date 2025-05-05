//
//  PokemonView.swift
//  Categories
//
//  Created by Carson Payne on 5/2/25.
//

import SwiftUI

// Pokémon model
struct Pokemon: Decodable {
    let name: String
    let sprites: Sprites
}

struct Sprites: Decodable {
    let front_default: String?
}

// ObservableObject class for tracking category counts
class CategoryCounters: ObservableObject {
    @Published var pokemonGreenCount = 0
    @Published var pokemonRedCount = 0
}

struct PokemonView: View {
    @ObservedObject var categoryCounters: CategoryCounters
    @State private var pokemonName: String = "Loading..."
    @State private var pokemonImageURL: String?
    @State private var greenButtonClickCount = 0
    @State private var redButtonClickCount = 0
    @State private var showingAlert = false

    // Random Pokémon ID between 1 and 898 (Gen 1–8)
    func randomPokemonURL() -> URL {
        let randomID = Int.random(in: 1...898)
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(randomID)") else {
            fatalError("Invalid URL")
        }
        return url
    }

    var preferenceMessage: String {
        if greenButtonClickCount > redButtonClickCount {
            return "You like Pokémon 😃"
        } else if redButtonClickCount > greenButtonClickCount {
            return "Not a fan of Pokémon? 😢"
        } else if greenButtonClickCount == 0 && redButtonClickCount == 0 {
            return ""
        } else {
            return "🤔"
        }
    }

    var body: some View {
        VStack {
            Text("Pokémon")
                .font(.largeTitle)
                .padding(.top)

            if let imageUrl = pokemonImageURL, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .padding()
                } placeholder: {
                    ProgressView()
                        .frame(width: 200, height: 200)
                }
            } else {
                ProgressView()
                    .frame(width: 200, height: 200)
            }

            Text(pokemonName.capitalized)
                .font(.title2)
                .padding(.bottom)

            HStack(spacing: 80) {
                VStack {
                    Button {
                        greenButtonClickCount += 1
                        categoryCounters.pokemonGreenCount += 1
                        fetchPokemon()
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
                        categoryCounters.pokemonRedCount += 1
                        fetchPokemon()
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

            if !preferenceMessage.isEmpty {
                Text(preferenceMessage)
                    .font(.headline)
                    .padding(.top)
                    .transition(.opacity)
            }
        }
        .padding()
        .onAppear {
            fetchPokemon()
        }
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Error"),
                message: Text("Couldn't load Pokémon data."),
                dismissButton: .default(Text("OK"))
            )
        }
        .animation(.easeInOut, value: preferenceMessage)
    }

    func fetchPokemon() {
        let url = randomPokemonURL()

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode(Pokemon.self, from: data)
                    DispatchQueue.main.async {
                        self.pokemonName = decoded.name
                        self.pokemonImageURL = decoded.sprites.front_default
                    }
                } catch {
                    DispatchQueue.main.async {
                        showingAlert = true
                    }
                }
            } else {
                DispatchQueue.main.async {
                    showingAlert = true
                }
            }
        }.resume()
    }
}

#Preview {
    PokemonView(categoryCounters: CategoryCounters())
}
