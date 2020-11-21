//
//  LayoutType.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 15/11/2020.
//

import UIKit

enum ExampleLayout {
    case list
    case simpleGrid
    case lazyGrid
    case systemList
}

struct LayoutType: Hashable {
    let name: String
    let color: UIColor
    let layout: ExampleLayout
}
