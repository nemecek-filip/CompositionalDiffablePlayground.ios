//
//  NSCollectionLayoutItem+Extension.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 13/11/2020.
//

import UIKit

extension NSCollectionLayoutItem {
    static func withEntireSize() -> NSCollectionLayoutItem {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        return NSCollectionLayoutItem(layoutSize: itemSize)
    }
}
