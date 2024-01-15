//
//  ContentView.swift
//  TheComposableArchitectureSample
//
//  Created by Adrian Kaleta on 13/01/2024.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    var body: some View {
        NewsView(
            store: Store(initialState: NewsFeature.State()) {
            NewsFeature()
          })
    }
}

#Preview {
    ContentView()
}
