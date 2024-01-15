//
//  LikedFeature.swift
//  TheComposableArchitectureSample
//
//  Created by Adrian Kaleta on 15/01/2024.
//

import SwiftUI
import ComposableArchitecture
//TODO: Maybe we could use one Feature for both states?. For now using two to use compose property

@Reducer
struct LikedFeature  {
    struct State: Equatable {
        var items: [Article] = []
        var isLoading: Bool = false
    }
    
    enum Action {
        case fetchLikedArticles
        case likeArticle(article: Article)
        case articlesResponse(Result<[Article], Error>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce{ state, action in
            
            switch action {
            case .fetchLikedArticles:
                state.isLoading = true
                return .run { send in
                    let articles = APIClient.shared.fetchLikedArticles()
                    await send(.articlesResponse(.success(articles )))
                }
            case .likeArticle(let article):
                return .run { send in
                    APIClient.shared.updateStoredArticles(article)
                    await send(.fetchLikedArticles)
                }
            case let .articlesResponse(.success(items)):
                state.items = items
                state.isLoading = false
                return .none
                
            case .articlesResponse(.failure(_)):
                state.isLoading = false
                return .none
            }
        }
    }
}

struct LikedItemsView: View {
    let store: StoreOf<LikedFeature>
    
    var body: some View {
        //TODO: Move list to separate view
        WithViewStore(self.store, observe: {$0}) { viewStore in
            List(viewStore.items ) { item in
                ArticleView(item: item) {
                    viewStore.send(.likeArticle(article: item))
                }
                
            }.onAppear {
                viewStore.send(.fetchLikedArticles)
            }
        }
    }
}

struct LikedItemsPreview: PreviewProvider {
    static var previews: some View {
        NewsView(
            store: Store(initialState: NewsFeature.State()) {
                NewsFeature()
            }
        )
    }
}

