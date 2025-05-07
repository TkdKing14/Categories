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
        if greenButtonClickCount > redButtonClickCount {
            return "You like dogs 😃"
        } else if redButtonClickCount > greenButtonClickCount {
            return "Not a fan of dogs? 😢"
        } else if greenButtonClickCount == 0 && redButtonClickCount == 0 {
            return ""
        } else {
            return "🤔"
        }
    }

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
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(12)
                            .padding()
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
                VStack {
                    Button {
                        fetchDogImage()
                        greenButtonClickCount += 1
                        CategoryCounters.dogGreenCount += 1
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
                        fetchDogImage()
                        redButtonClickCount += 1
                        CategoryCounters.dogRedCount += 1
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
            .padding(.bottom, 10)

            if !preferenceMessage.isEmpty {
                Text(preferenceMessage)
                    .font(.headline)
                    .padding(.top, 10)
                    .transition(.opacity)
            }
        }
        .padding()
        .onAppear(perform: fetchDogImage)
        .animation(.easeInOut, value: preferenceMessage)
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
    dogsView(CategoryCounters: categoryCounters())
}
