//
//  MovieView.swift
//  Categories
//
//  Created by Carson Payne on 5/1/25.
//

import SwiftUI

struct MoviePosterView: View {
    @State private var posters = [MoviePoster]()
    @State private var showingAlert = false
    @State private var greenButtonClickCount = 0
    @State private var redButtonClickCount = 0

    let apiKey = "YOUR_TMDB_API_KEY" // ✅ Replace with your TMDb API key
    let movieQuery = "Inception"     // 🔍 Change to any movie title you want to test

    var preferenceMessage: String {
        if greenButtonClickCount > redButtonClickCount {
            return "You like this movie 🎬"
        } else if redButtonClickCount > greenButtonClickCount {
            return "Not a fan of this one? 👎"
        } else if greenButtonClickCount == 0 && redButtonClickCount == 0 {
            return ""
        } else {
            return "🤔"
        }
    }

    var body: some View {
        VStack {
            Text("Movie Posters")
                .font(.largeTitle)
                .padding(.top)

            List(posters, id: \.id) { poster in
                VStack {
                    // Debug print statement to check if the URL is correct
                    AsyncImage(url: URL(string: poster.fullPosterURL)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(12)
                            .padding(.vertical, 20)
                    } placeholder: {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                }
            }
            .listStyle(PlainListStyle())

            HStack(spacing: 80) {
                VStack {
                    Button {
                        Task { await loadPoster() }
                        greenButtonClickCount += 1
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
                        Task { await loadPoster() }
                        redButtonClickCount += 1
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
                    .padding(.top, 10)
                    .transition(.opacity)
            }
        }
        .task {
            await loadPoster()
        }
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Error"),
                message: Text("Could not load poster."),
                dismissButton: .default(Text("OK"))
            )
        }
        .animation(.easeInOut, value: preferenceMessage)
    }

    func loadPoster() async {
        guard let query = movieQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(query)") else {
            showingAlert = true
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(MovieSearchResponse.self, from: data)

            if let movie = decoded.results.first, let posterPath = movie.poster_path {
                // Print the poster path to verify it's valid
                print("Found Poster Path: \(posterPath)")
                let poster = MoviePoster(id: UUID(), posterPath: posterPath)
                posters = [poster]
            } else {
                print("No poster path found.")
                showingAlert = true
            }

        } catch {
            print("Error loading poster: \(error)")
            showingAlert = true
        }
    }
}

#Preview {
    MoviePosterView()
}

// MARK: - Models

struct MovieSearchResponse: Codable {
    let results: [MovieResult]
}

struct MovieResult: Codable {
    let poster_path: String?
}

struct MoviePoster: Identifiable {
    let id: UUID
    let posterPath: String

    var fullPosterURL: String {
        return "https://image.tmdb.org/t/p/w500\(posterPath)"
    }
}
