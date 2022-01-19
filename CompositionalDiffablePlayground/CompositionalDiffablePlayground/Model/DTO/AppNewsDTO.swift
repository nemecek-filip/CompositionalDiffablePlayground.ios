//
//  AppNewsDTO.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 02.01.2022.
//

import Foundation

struct AppNewsDTO: Decodable, Hashable, Equatable {
    let title: String
    let thumbnailUrl: String
    let detailUrl: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(detailUrl)
    }
    
    static func ==(lhs: AppNewsDTO, rhs: AppNewsDTO) -> Bool {
        return lhs.detailUrl == rhs.detailUrl
    }
}
