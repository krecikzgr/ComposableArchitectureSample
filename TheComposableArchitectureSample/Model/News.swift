//
//  News.swift
//  TheComposableArchitectureSample
//
//  Created by Adrian Kaleta on 14/01/2024.
//

import Foundation

// MARK: - ArticlesResponse
struct ArticlesResponse: Codable, Equatable {
   var status: String?
   var totalResults: Int
   var articles: [Article]
    
    init(status: String?, totalResults: Int, articles: [Article]) {
        self.status = status
        self.totalResults = totalResults
        self.articles = articles
    }
}

// MARK: - Article
struct Article: Codable, Equatable, Identifiable {
    //TODO: Work on proper id
    var id: String  {
        return (source.id ?? "") + source.name
    }
    
    var isLiked: Bool = false
    
    let source: Source
    let author, title, description: String?
    let url: String
    let urlToImage: String?
    let content: String
    
    private enum CodingKeys: String, CodingKey {
        case source
        case author
        case title
        case description
        case url
        case urlToImage
        case content
    }
}

// MARK: - Source
struct Source: Codable, Equatable {
    let id: String?
    let name: String
}
