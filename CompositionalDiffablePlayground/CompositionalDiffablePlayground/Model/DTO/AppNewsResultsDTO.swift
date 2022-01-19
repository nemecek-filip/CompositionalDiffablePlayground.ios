//
//  AppNewsResultsDTO.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 02.01.2022.
//

import Foundation

struct AppNewsResultsDTO: Decodable {
    let count: Int
    let results: [AppNewsDTO]
}
