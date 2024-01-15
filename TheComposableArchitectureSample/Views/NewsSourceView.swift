//
//  NewsSourceView.swift
//  TheComposableArchitectureSample
//
//  Created by Adrian Kaleta on 15/01/2024.
//

import SwiftUI

struct NewsSourceView: View {
    var item: NewsSource

    init(item: NewsSource) {
        self.item = item
    }
    
    var body: some View {
        VStack {
            Text(item.name)
            Spacer()
            Text(item.category)
            
        }
    }
}
