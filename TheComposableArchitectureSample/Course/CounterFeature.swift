//
//  CounterFeature.swift
//  TheComposableArchitectureSample
//
//  Created by Adrian Kaleta on 13/01/2024.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct CounterFeature {
    struct State: Equatable {
        var count = 0
    }
    
    enum Action {
        case incrementAction
        case decrementAction
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .decrementAction:
                state.count -= 1
                return .none
            case .incrementAction:
                state.count += 1
                return .none
            }
            
        }
    }
}

struct CounterView: View {
    let store: StoreOf<CounterFeature>
    
  var body: some View {
      WithViewStore(self.store, observe: {$0}) { viewStore in
          VStack {
              Text("\(viewStore.state.count)")
                  .font(.largeTitle)
                  .padding()
                  .background(Color.black.opacity(0.1))
                  .cornerRadius(10)
              HStack {
                  Button("-") {
                      viewStore.send(.decrementAction)
                  }
                  .font(.largeTitle)
                  .padding()
                  .background(Color.black.opacity(0.1))
                  .cornerRadius(10)
                  
                  Button("+") {
                      viewStore.send(.incrementAction)
                  }
                  .font(.largeTitle)
                  .padding()
                  .background(Color.black.opacity(0.1))
                  .cornerRadius(10)
              }
          }
      }
  }
}

struct CounterPreview: PreviewProvider {
  static var previews: some View {
    CounterView(
      store: Store(initialState: CounterFeature.State()) {
        CounterFeature()
      }
    )
  }
}
