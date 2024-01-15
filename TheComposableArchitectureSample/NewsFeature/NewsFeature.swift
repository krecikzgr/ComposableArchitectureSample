import SwiftUI
import ComposableArchitecture

// Define the reducer to handle state changes

@Reducer
struct NewsFeature  {
    struct State: Equatable {
        @PresentationState var articleDetails: ArticleDetailsFeature.State?
        var items: [Article] = []
        var isLoading: Bool = false
    }
    
    enum Action {
        case fetchArticles
        case likeArticle(article: Article)
        case articlesResponse(Result<[Article], Error>)
        case articleSelected(article: Article)
        case articleDetails(PresentationAction<ArticleDetailsFeature.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce{ state, action in
            
            switch action {
            case .fetchArticles:
                state.isLoading = true
                return .run { send in
                    let articles = try? await APIClient.shared.fetchData()
                    await send(.articlesResponse(.success(articles ?? [])))
                }
            case .likeArticle(let article):
                return .run { send in
                    APIClient.shared.updateStoredArticles(article)
                    await send(.fetchArticles)
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

struct NewsView: View {
    let store: StoreOf<NewsFeature>
    
    var body: some View {
        NavigationStack{
            WithViewStore(self.store, observe: {$0}) { viewStore in
                List(viewStore.items ) { item in
                    ArticleView(item: item) {
                        viewStore.send(.likeArticle(article: item))
                    }.onTapGesture {
                        viewStore.send(.articleSelected(article: item))
                    }
                }.onAppear {
                    viewStore.send(.fetchArticles)
                }
            }
            .navigationTitle("News")
        }
        .sheet(store: self.store.scope(state: \.$articleDetails,
                                       action: \.articleDetails)) { store in
            NavigationStack {
                ArticleDetailView(store: store)
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
