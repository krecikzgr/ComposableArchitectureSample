//
//  ArticleView.swift
//  TheComposableArchitectureSample
//
//  Created by Adrian Kaleta on 15/01/2024.
//

import SwiftUI

struct ArticleListItemView: View {
    var item: Article
    var action: ()->Void
    init(item: Article, action: @escaping () -> Void) {
        self.item = item
        self.action = action
    }
    
    var body: some View {
        HStack {
            AsyncImage(
                url: URL(string: item.urlToImage ?? ""),
                content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 60, maxHeight: 60)
                },
                placeholder: {
                    ProgressView()
                }
            )
            Text(item.title ?? "")
            Spacer()
            Button(action: {
                action()
            }) {
                Image(systemName: item.isLiked ? "heart.fill" : "heart")
                    .foregroundColor(item.isLiked ? .red : .gray)
            }
            .buttonStyle(.plain)
        }
    }
}
