//
//  CatView.swift
//  Categories
//
//  Created by Carson Payne on 4/23/25.
//

import SwiftUI

struct CatView: View {
    @ObservedObject var CategoryCounters: categoryCounters
    @State private var photos = [Photo]()
    @State private var showingAlert = false
    @State private var greenButtonClickCount = 0
    @State private var redButtonClickCount = 0
//displays text bases on the number of times each buttom was clicked
    var preferenceMessage: String {
        if greenButtonClickCount > redButtonClickCount {
            return "You like cats 😃"
        } else if redButtonClickCount > greenButtonClickCount {
            return "Not a fan of cats?😢"
        } else if greenButtonClickCount == 0 && redButtonClickCount == 0 {
            return ""
        } else {
            return "🤔"
        }
    }

    var body: some View {
        ZStack {
            // Background image
            Image("catBackground")
                .resizable()
                .scaledToFill()
                .blur(radius: 5)
                .opacity(0.25)
                .ignoresSafeArea()

            VStack {
                Text("Cats")
                    .font(.largeTitle)
                    .padding(.top)
//gives a scrollable list of the following images that were generated. the list is not visible as only one picture is generated
                List(photos, id: \.id) { photo in
                    VStack {
                        AsyncImage(url: URL(string: photo.photourl)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(12)
                                .padding(.vertical, 20)
                        } placeholder: {
                            ProgressView()
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                        }
                    }
                    .listRowBackground(Color.clear)
                }
                .listStyle(PlainListStyle())
                .background(Color.clear)

                HStack(spacing: 80) {
                    //buttons that are displayed can be clicked based on if you like the image or not
                    VStack {
                        Button {
                            Task {
                                await loadData()
                            }
                            greenButtonClickCount += 1
                            CategoryCounters.catGreenCount += 1
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
                            Task {
                                await loadData()
                            }
                            redButtonClickCount += 1
                            CategoryCounters.catRedCount += 1
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
//this code displays text based on what the user has selected
                if !preferenceMessage.isEmpty {
                    Text(preferenceMessage)
                        .font(.headline)
                        .padding(.top, 10)
                        .transition(.opacity)
                }
            }
            .padding()
        }
        .task {
            await loadData()
        }
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Loading Error"),
                message: Text("There was a problem loading cat images."),
                dismissButton: .default(Text("OK"))
            )
        }
        .animation(.easeInOut, value: preferenceMessage)
    }
//gets the cat image from the api and displays it on the screen.
    func loadData() async {
        if let url = URL(string: "https://api.thecatapi.com/v1/images/search?limit=1") {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let decodedResponse = try? JSONDecoder().decode([Photo].self, from: data) {
                    photos = decodedResponse
                    return
                }
            } catch {
                print("Fetch error: \(error)")
            }
        }
        showingAlert = true
    }
}

#Preview {
    CatView(CategoryCounters: categoryCounters())
}
//sets up the given requiremenes for the cat image to be generated
struct Photo: Identifiable, Codable {
    var id = UUID()
    var api_id: String
    var width: Int
    var height: Int
    var photourl: String

    enum CodingKeys: String, CodingKey {
        case api_id = "id"
        case width
        case height
        case photourl = "url"
    }
}
