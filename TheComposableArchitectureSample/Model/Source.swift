//
//  Source.swift
//  TheComposableArchitectureSample
//
//  Created by Adrian Kaleta on 15/01/2024.
//

import Foundation

// MARK: - NewsSourceReesponse
struct NewsSourceReesponse: Codable, Equatable {
    let status: String
    let sources: [NewsSource]
}

// MARK: - Source
struct NewsSource: Codable, Equatable, Identifiable {
    let id, name, description: String
    let url: String
    let category, language, country: String
}
