//
//  FeedsService.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 26.02.2021.
//

import Foundation

class FeedsService {
    static let shared = FeedsService()
    
    @Published private(set) var articles: [ArticleDTO]?
    
    func loadArticles() {
        SimpleNetworkHelper.shared.getArticles { (articles) in
            if let articles = articles {
                self.articles = Array(articles.prefix(60))
            }
        }
    }
}
