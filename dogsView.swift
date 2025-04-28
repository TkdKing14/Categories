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
        VStack {
            Text("Dogs")
                .font(.largeTitle)
                .padding(.top)
            Spacer()
            if let imageUrl, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image): image
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 300)
                            .cornerRadius(12)
                            .padding(.top, 30)
                    case .failure:
                        Text("Failed to load image")
                    @unknown default:
                        EmptyView()
                    }
                }
            } else if isLoading {
                ProgressView()
            }
            Spacer()
            HStack(spacing: 80) {
                Button(action: {
                    fetchDogImage()
                    print("Checkmark button tapped")
                }) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                        .font(.system(size: 75))
                }
                Button(action: {
                    fetchDogImage()
                    print("X button tapped")
                }) {
                    Image(systemName: "x.circle.fill")
                        .foregroundStyle(.red)
                        .font(.system(size: 75))
                }
            }
            .padding(.bottom, 30)
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
