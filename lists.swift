//
//  lists.swift
//  Categories
//
//  Created by Rohan Patel on 4/24/25.
//

import SwiftUI

struct ListItem {
    let image: UIImage
    let text: String
}

let items: [ListItem] = [
    ListItem(image: UIImage(named: "cat") ?? UIImage(), text: "Cute cat"),
    ListItem(image: UIImage(named: "dog") ?? UIImage(), text: "Happy dog"),
    ListItem(image: UIImage(named: "bird") ?? UIImage(), text: "Colorful bird")
]

struct ItemView: View {
    let item: ListItem

    var body: some View {
        HStack {
            Image(uiImage: item.image)
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            Text(item.text)
        }
    }
}

#Preview {
    ItemView(item: items[0])
}
