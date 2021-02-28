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
    case onboarding
    case systemList
    case insetList
    case stickyHeaders
    case responsiveLayout
}

struct LayoutType: Hashable {
    let name: String
    let color: UIColor
    let layout: ExampleLayout
}

extension LayoutType {
    static let available: [LayoutType] = [
        LayoutType(name: "List Layout", color: .random(), layout: .list),
        LayoutType(name: "Simple Grid Layout", color: .random(), layout: .simpleGrid),
        LayoutType(name: "Lazy Grid Layout", color: .random(), layout: .lazyGrid),
        LayoutType(name: "Onboarding layout", color: .random(), layout: .onboarding),
        LayoutType(name: "Background decoration", color: .random(), layout: .insetList),
        LayoutType(name: "Sticky headers", color: .random(), layout: .stickyHeaders),
        LayoutType(name: "System List Layout", color: .random(), layout: .systemList),
        LayoutType(name: "Responsive layout", color: .random(), layout: .responsiveLayout),
    ]
}
