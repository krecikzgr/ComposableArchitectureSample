//
//  QueryBuilder.swift
//  TheComposableArchitectureSample
//
//  Created by Adrian Kaleta on 15/01/2024.
//

import Foundation

struct URLQueryBuilder {
    private var base: URL
    private var queryItems: [URLQueryItem] = []

    init(base: URL) {
        self.base = base
    }

    mutating func addParam(name: String, value: String?) {
        queryItems.append(URLQueryItem(name: name, value: value))
    }

    func build() -> URL? {
        var components = URLComponents(url: base, resolvingAgainstBaseURL: true)
        components?.queryItems = queryItems
        return components?.url
    }
}
