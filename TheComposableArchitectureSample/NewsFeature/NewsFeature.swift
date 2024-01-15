import SwiftUI
import ComposableArchitecture

// Define the reducer to handle state changes

@Reducer
struct NewsFeature  {
    struct State: Equatable {
        var items: [Article] = []
        var isLoading: Bool = false
    }
    
    enum Action {
        case fetchArticles
        case likeArticle(article: Article)
        case articlesResponse(Result<[Article], Error>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce{ state, action in
            
            switch action {
            case .fetchArticles:
                state.isLoading = true
                return .run { send in
                    let articles = try? await NewsRepository.shared.fetchData()
                    await send(.articlesResponse(.success(articles ?? [])))
                }
            case .likeArticle(let article):
                return .run { send in
                    NewsRepository.shared.updateStoredArticles(article)
                    await send(.fetchArticles)
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

struct NewsView: View {
    let store: StoreOf<NewsFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: {$0}) { viewStore in
            List(viewStore.items ) { item in
                ArticleView(item: item) {
                    viewStore.send(.likeArticle(article: item))
                }
            }.onAppear {
                viewStore.send(.fetchArticles)
            }
        }
    }
}

struct NewsPreview: PreviewProvider {
    static var previews: some View {
        NewsView(
            store: Store(initialState: NewsFeature.State()) {
                NewsFeature()
            }
        )
    }
}
