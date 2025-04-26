//
//  CategoriesView.swift
//  Categories
//
//  Created by Carson Payne on 4/21/25.
//

import SwiftUI

struct CategoriesView: View {
    let categories: [String] = categoriesList

    var body: some View {
        NavigationView {
            List(categories, id: \.self) { category in
                NavigationLink(destination: destinationView(for: category)) {
                    HStack {
                        categoryIcon(for: category)
                        Text(category)
                    }
                    .padding(.vertical, 5)
                }
            }
            .navigationTitle("Categories")
        }
    }
    @ViewBuilder
    func destinationView(for category: String) -> some View {
        if category == "Cats" {
            CatView()
        }
    }
    func categoryIcon(for category: String) -> some View {
           let iconName: String
        let iconColor: Color
           switch category {
           case "Cats":
               iconName = "cat.fill"
               iconColor = Color.gray
           case "Months":
               iconName = "calendar"
               iconColor = Color.green
           case "Food":
               iconName = "fork.knife"
               iconColor = Color.red
           case "Cities":
               iconName = "building"
               iconColor = Color.blue
           case "Dogs":
               iconName = "dog.fill"
               iconColor = Color.yellow
           default:
               iconName = "airplane"
               iconColor = Color.blue
           }
           return Image(systemName: iconName)
               .padding(10)
               .background(iconColor)
               .foregroundColor(.white)
               .clipShape(Circle())
       }
   }
#Preview {
    CategoriesView()
}
