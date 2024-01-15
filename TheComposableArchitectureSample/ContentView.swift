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
        let store = Store(initialState: AppFeature.State()) {
          AppFeature()
        }
        AppView(store: store)
    }
}

#Preview {
    ContentView()
}
