//
//  ArticleDTO.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 26.02.2021.
//

import Foundation

struct ArticleDTO: Decodable {
    let title: String
    let guid: String
    let url: String
}

extension ArticleDTO: Hashable, Equatable {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.guid == rhs.guid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(guid)
    }
}
