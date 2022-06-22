//
//  NSCollectionLayoutSection+Extension.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 14/11/2020.
//

import UIKit

extension NSCollectionLayoutSection {
    
    static func listSection(withEstimatedHeight estimatedHeight: CGFloat = 100) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 15, bottom: 10, trailing: 15)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(estimatedHeight))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        layoutGroup.interItemSpacing = .fixed(10)
        
        return NSCollectionLayoutSection(group: layoutGroup)
    }
    
    static func largeGridSection(itemInsets: NSDirectionalEdgeInsets = .uniform(size: 5)) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = itemInsets
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        return NSCollectionLayoutSection(group: group)
    }
}
