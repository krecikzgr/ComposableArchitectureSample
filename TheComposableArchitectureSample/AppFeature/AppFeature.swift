//
//  AppFeature.swift
//  TheComposableArchitectureSample
//
//  Created by Adrian Kaleta on 15/01/2024.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct AppFeature {
    struct State {
        var tab1 = NewsFeature.State()
        var tab2 = LikedFeature.State()
        var tab3 = NewsSourcesFeature.State()
    }
    enum Action {
        case tab1(NewsFeature.Action)
        case tab2(LikedFeature.Action)
        case tab3(NewsSourcesFeature.Action)
    }
    var body: some ReducerOf<Self> {
        Scope(state: \.tab1, action: \.tab1) {
            NewsFeature()
        }
        Scope(state: \.tab2, action: \.tab2) {
            LikedFeature()
        }
        Scope(state: \.tab3, action: \.tab3) {
            NewsSourcesFeature()
        }
        Reduce { state, action in
            // Core logic of the app feature
            return .none
        }
    }
}

struct AppView: View {
    let store: StoreOf<AppFeature>
    
    var body: some View {
        TabView {
            NewsView(store: store.scope(state: \.tab1, action: \.tab1))
                .tabItem {
                    Text("News")
                }
            
            LikedItemsView(store: store.scope(state: \.tab2, action: \.tab2))
                .tabItem {
                    Text("Liked")
                }
            NewsSourceListView(store: store.scope(state: \.tab3, action: \.tab3))
                .tabItem {
                    Text("Sources")
                }
        }
    }
}
