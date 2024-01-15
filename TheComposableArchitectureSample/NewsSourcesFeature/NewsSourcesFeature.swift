import SwiftUI
import ComposableArchitecture

// Define the reducer to handle state changes

@Reducer
struct NewsSourcesFeature  {
    struct State: Equatable {
        @PresentationState var articleDetails: ArticleDetailsFeature.State?
        var items: [NewsSource] = []
        var isLoading: Bool = false
    }
    
    enum Action {
        case fetchSources
        case setSource(NewsSource)
        case sourcesResponse(Result<[NewsSource], Error>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce{ state, action in
            
            switch action {
            case .fetchSources:
                state.isLoading = true
                return .run { send in
                    let sources = try? await APIClient.shared.fetchSources()
                    await send(.sourcesResponse(.success(sources ?? [])))
                }
            case .setSource(let source):
                APIClient.shared.sourceQuery = source.id
                return .none
            case let .sourcesResponse(.success(items)):
                state.items = items
                state.isLoading = false
                return .none
            case .sourcesResponse(.failure(_)):
                state.isLoading = false
                return .none
            }
        }
    }
}

struct NewsSourceListView: View {
    let store: StoreOf<NewsSourcesFeature>
    
    var body: some View {
        NavigationStack{
            WithViewStore(self.store, observe: {$0}) { viewStore in
                List(viewStore.items ) { item in
                    NewsSourceListItemView(item: item)
                        .onTapGesture {
                            viewStore.send(.setSource(item))
                        }
                }.onAppear {
                    viewStore.send(.fetchSources)
                }
            }
            .navigationTitle("News Sources")
        }
    }
}

struct NewsSourcesPreview: PreviewProvider {
    static var previews: some View {
        NewsSourceListView(
            store: Store(initialState: NewsSourcesFeature.State()) {
                NewsSourcesFeature()
            }
        )
    }
}
