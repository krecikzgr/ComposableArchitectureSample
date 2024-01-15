//
//  NewsRepository.swift
//  TheComposableArchitectureSample
//
//  Created by Adrian Kaleta on 15/01/2024.
//

import Foundation

class APIClient {
    static let shared = APIClient()
    
    var sourceQuery: String = "tesla"
    
    private let apiKey: String = "ab1a59d01b5c41f09a9bab0e29ac5d65"

    private init() {}

    func fetchData() async throws -> [Article] {
        //TODO: Move links and api key to separate static fields in some query builder
        let (data, response) = try await URLSession.shared
            .data(from:URL(string: "https://newsapi.org/v2/everything?q=\(sourceQuery)&from=2023-12-19&sortBy=publishedAt&apiKey=\(apiKey)")!)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            // Handle HTTP errors here
            throw URLError(.badServerResponse) // Use an appropriate error
        }
        let articlesResponse = try? JSONDecoder().decode(ArticlesResponse.self, from: data)
        var articles = articlesResponse?.articles ?? []
        articles.enumerated().forEach({ index, article in
            articles[index].isLiked = UserDefaultsProvider.shared.isArticleLiked(article)
        })
        return articles
    }
    
    
    func isArticleLiked(_ article: Article) -> Bool {
        return UserDefaultsProvider.shared.isArticleLiked(article)
    }
    
    func fetchLikedArticles() -> [Article] {
        var articles = UserDefaultsProvider.shared.retrieveArticles()?.articles ?? []
        articles.enumerated().forEach({ index, article in
            articles[index].isLiked = UserDefaultsProvider.shared.isArticleLiked(article)
        })
        return articles
    }
    
    func updateStoredArticles(_ article: Article) {
        UserDefaultsProvider.shared.updateStoredArticles(article)
    }
    
    func fetchSources() async throws ->[NewsSource] {
        let (data, response) = try await URLSession.shared
            .data(from:URL(string: "https://newsapi.org/v2/top-headlines/sources?apiKey=\(apiKey)")!)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            // Handle HTTP errors here
            throw URLError(.badServerResponse) // Use an appropriate error
        }
        let newsResponse = try? JSONDecoder().decode(NewsSourceReesponse.self, from: data)
        return newsResponse?.sources ?? []
    }
}
