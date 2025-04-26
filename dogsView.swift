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
    @State private var imageUrl: String?
    @State private var isLoading = false

    var body: some View {
        VStack(spacing: 20) {
            Text("🐶 Random Dog")
                .font(.largeTitle)

            if let imageUrl, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case.empty: ProgressView()
                    case.success(let image): image.resizable().scaledToFit().frame(maxHeight: 300).cornerRadius(12)
                    case.failure: Text("Failed to load image")
                    @unknown default: EmptyView()
                    }
                }
            } else if isLoading {
                ProgressView()
            }
            Button(action: {
                fetchDogImage()
                print("Checkmark button tapped")
            }) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                    .font(.system(size: 50))
                    .padding()
            }
            .position(x: 300, y: 320)
            .padding()
            Button(action: {
                fetchDogImage()
                print("X button tapped")
            }) {
                Image(systemName: "x.circle.fill")
                    .foregroundStyle(.red)
                    .font(.system(size: 50))
                    .padding()
            }
            .position(x: 300, y: 100)
            
           
        }
        .padding()
        .onAppear(perform: fetchDogImage)
    }

    func fetchDogImage() {
        isLoading = true
        guard let url = URL(string: "https://dog.ceo/api/breeds/image/random") else { return }

        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let result = try JSONDecoder().decode(DogImageResponse.self, from: data)
                imageUrl = result.message
            } catch {
                print("Error: \(error)")
            }
            isLoading = false
        }
    }
}

#Preview {
    dogsView()
}
