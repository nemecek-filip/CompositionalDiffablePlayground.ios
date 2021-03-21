//
//  SelectableItem.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 18.03.2021.
//

import UIKit

class SelectableItem {
    let color = UIColor.random()
    let id = UUID()
    var isSelected = false
}

extension SelectableItem: Hashable {
    static func == (lhs: SelectableItem, rhs: SelectableItem) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
