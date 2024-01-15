import SwiftUI
import ComposableArchitecture

// Define the reducer to handle state changes

struct Item: Equatable {
    let id: Int
    let name: String
}

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
                    let (data, _) = try await URLSession.shared
                        .data(from:URL(string: "https://newsapi.org/v2/everything?q=apple&from=2023-12-19&sortBy=publishedAt&apiKey=ab1a59d01b5c41f09a9bab0e29ac5d65")!)
                    let articlesResponse = try? JSONDecoder().decode(ArticlesResponse.self, from: data)
                    var articles = articlesResponse?.articles ?? []
                    articles.enumerated().forEach({ index, article in
                        articles[index].isLiked = UserDefaultsProvider.shared.isArticleLiked(article)
                    })
                    await send(.articlesResponse(.success(articles)))
                }
            case .likeArticle(let article):
                return .run { send in
                    UserDefaultsProvider.shared.updateStoredArticles(article)
                    await send(.fetchArticles)
                }
            case let .articlesResponse(.success(items)):
                state.items = items
                state.isLoading = false
                return .none
                
            case let .articlesResponse(.failure(error)):
                // Handle the error here, for example, display an error message.
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
                        viewStore.send(.likeArticle(article: item))
                        }) {
                            Image(systemName: item.isLiked ? "heart.fill" : "heart")
                                .foregroundColor(item.isLiked ? .red : .gray)
                        }
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
