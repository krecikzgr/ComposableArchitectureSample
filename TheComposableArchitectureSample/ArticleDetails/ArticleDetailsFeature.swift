//
//  ArticleDetailsFeature.swift
//  TheComposableArchitectureSample
//
//  Created by Adrian Kaleta on 15/01/2024.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct ArticleDetailsFeature {
  struct State: Equatable {
      var article: Article
  }
  enum Action {
    case fetchData
  }
  var body: some ReducerOf<Self> {
    Reduce { state, action in
        switch action {
        case .fetchData:
            return .none
        }
        //return .none
//      switch action {
//      case .addButtonTapped:
//        // TODO: Handle action
//        return .none
//      }
    }
  }
}

struct ArticleDetailView: View {
    let store: StoreOf<ArticleDetailsFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: {$0}) { viewStore in
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text(viewStore.article.title ?? "")
                        .font(.title)
                        .fontWeight(.bold)

                    AsyncImage(
                        url: URL(string: viewStore.article.urlToImage ?? ""),
                        content: { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 300, maxHeight: 200)
                        },
                        placeholder: {
                            ProgressView()
                        }
                    )

                    Text(viewStore.article.author ?? "")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    Text(viewStore.article.content )
                        .font(.body)
                }
                .padding()
            }
            .navigationTitle("News Details")
        }
        .navigationTitle("Item Details")
    }
}
