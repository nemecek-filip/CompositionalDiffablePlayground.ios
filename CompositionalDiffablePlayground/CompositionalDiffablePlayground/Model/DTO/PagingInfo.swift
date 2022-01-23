//
//  PagingInfo.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 23.01.2022.
//

import Foundation

struct PagingInfo: Equatable, Hashable {
    let sectionIndex: Int
    let currentPage: Int
}
