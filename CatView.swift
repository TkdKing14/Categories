//
//  CatView.swift
//  Categories
//
//  Created by Carson Payne on 4/23/25.
//

import SwiftUI

struct CatView: View {
    @State private var photos = [Photo]()
    @State private var showingAlert = false

    var body: some View {
        NavigationView {
            VStack {
                List(photos, id: \.id) { photo in
                    VStack {
                        AsyncImage(url: URL(string: photo.photourl)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(maxHeight: 300)
                    }
                    .padding(.vertical)
                }
                .listStyle(PlainListStyle())

                HStack {
                    Button {
                        Task {
                            await loadData()
                        }
                    } label: {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                            .font(.system(size: 75))
                            .position(x:125, y:10)
                    }

                    Spacer()

                    Button {
                        Task {
                            await loadData()
                        }
                    } label: {
                        Image(systemName: "x.circle.fill")
                            .foregroundStyle(.red)
                            .font(.system(size: 75))
                            .position(x:150, y:10)
                    }
                    Image("Paws")
                        .resizable()
                        .frame(width: 500, height: 175)
                        .position(x:1, y:250)
                }
                .padding()
            }
            .navigationTitle("Cats!")
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
    }

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
    CatView()
}

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
