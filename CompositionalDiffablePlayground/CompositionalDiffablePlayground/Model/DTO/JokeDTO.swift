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
