//
//  LikedFeature.swift
//  TheComposableArchitectureSample
//
//  Created by Adrian Kaleta on 15/01/2024.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct LikedArticlesFeature  {
    struct State: Equatable {
        @PresentationState var articleDetails: ArticleDetailsFeature.State?
        var items: [Article] = []
        var isLoading: Bool = false
    }
    
    enum Action {
        case fetchLikedArticles
        case likeArticle(article: Article)
        case articlesResponse(Result<[Article], Error>)
        case articleSelected(article: Article)
        case articleDetails(PresentationAction<ArticleDetailsFeature.Action>)
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
            case .articleDetails(_):
                return .none
            case .articleSelected(let article):
                state.articleDetails = ArticleDetailsFeature.State(article: article)
                return .none
            }
        }
        .ifLet(\.$articleDetails, action: \.articleDetails) {
            ArticleDetailsFeature()
        }
    }
}

struct LikedArticlesView: View {
    let store: StoreOf<LikedArticlesFeature>
    
    var body: some View {
        NavigationStack {
            WithViewStore(self.store, observe: {$0}) { viewStore in
                List(viewStore.items ) { item in
                    ArticleListItemView(item: item) {
                        viewStore.send(.likeArticle(article: item))
                    }
                    .onTapGesture {
                        viewStore.send(.articleSelected(article: item))
                    }

                }.onAppear {
                    viewStore.send(.fetchLikedArticles)
                }
            }
        }
        .sheet(store: self.store.scope(state: \.$articleDetails,
                                       action: \.articleDetails)) { store in
            NavigationStack {
                ArticleDetailView(store: store)
            }
        }
    }
}

struct LikedArticlesPreview: PreviewProvider {
    static var previews: some View {
        NewsView(
            store: Store(initialState: NewsFeature.State()) {
                NewsFeature()
            }
        )
    }
}

