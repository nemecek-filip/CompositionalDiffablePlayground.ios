//
//  ColorsSnapshot+Extension.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 15/11/2020.
//

import UIKit

extension ColorsSnapshot {
    mutating func addRandomItems(count: Int = 10) {
        var items = [UIColor]()
        for _ in 0..<count {
            items.append(UIColor.random())
        }
        self.appendItems(items)
    }
    
    static func random() -> ColorsSnapshot {
        var snapshot = ColorsSnapshot()
        snapshot.appendSections([0])
        snapshot.addRandomItems()
        return snapshot
    }
}
