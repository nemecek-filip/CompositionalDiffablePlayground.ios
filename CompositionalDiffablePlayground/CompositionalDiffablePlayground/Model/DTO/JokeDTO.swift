//
//  JokeDTO.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 27/11/2020.
//

import Foundation

struct JokeDTO: Decodable {
    let id: Int
    let setup: String
    let punchline: String
}

extension JokeDTO: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: JokeDTO, rhs: JokeDTO) -> Bool {
        return lhs.id == rhs.id
    }
}
