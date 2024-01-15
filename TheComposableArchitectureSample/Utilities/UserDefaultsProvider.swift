//
//  UserDefaultsProvider.swift
//  TheComposableArchitectureSample
//
//  Created by Adrian Kaleta on 15/01/2024.
//

import Foundation

class UserDefaultsProvider {
    static let shared: UserDefaultsProvider = UserDefaultsProvider()
    enum Keys: String {
        case articlesKeys
    }
    
    func retrieveArticles()-> ArticlesResponse? {
        guard let data = UserDefaults.standard.object(forKey: Keys.articlesKeys.rawValue) as? Data else {
            return nil
        }
        let decoder = JSONDecoder()
        guard let loadedObject = try? decoder.decode(ArticlesResponse.self, from: data) else {
            return nil
        }
        return loadedObject
    }
    
    func isArticleLiked(_ article: Article) -> Bool {
        let response = retrieveArticles()
        
        return response?.articles.contains(where: { oldArticle in
            oldArticle.id == article.id
        }) ?? false
    }
    //TODO: Could be moved to two methods
    func updateStoredArticles(_ article: Article) {
        let encoder = JSONEncoder()
        
        var response = self.retrieveArticles() ?? ArticlesResponse(status: "",
                                                                   totalResults: 0,
                                                                   articles: [])
            var articles = response.articles
        if isArticleLiked(article) {
            articles.removeAll(where: { scannedArticle in
                scannedArticle.id == article.id
            })
        } else {
            articles.append(article)
        }
        response.articles = articles
        
        if let encoded = try? encoder.encode(response) {
            UserDefaults.standard.set(encoded, forKey: Keys.articlesKeys.rawValue)
        }
    }
}
