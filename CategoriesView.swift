//
//  CategoriesView.swift
//  Categories
//
//  Created by Carson Payne on 4/21/25.
//

import SwiftUI

struct CategoriesView: View {
    let categories = categoriesList
    var body: some View {
        NavigationView {
            List {
                ForEach(categories, id: \.self) { categories in
                    NavigationLink(destination: Text(categories)) {
                        Image(systemName: "gamecontroller.fill")
                        Text(categories)
                    } .padding()
                }
                navigationTitle("Categories")
            }
        }
    }
}

#Preview {
    CategoriesView()
}

        
