//
//  NSCollectionLayoutDimension+Extension.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 12.02.2021.
//

import UIKit

extension NSCollectionLayoutDimension {
    static func fractionalWidth(forTargetSize size: CGFloat, inEnvironment environment: NSCollectionLayoutEnvironment) -> Self {
        let containerWidth = environment.container.effectiveContentSize.width
        
        let itemCount = containerWidth / size
        
        let fractionWidth: CGFloat = 1 / (itemCount.rounded())
        
        return Self.fractionalWidth(fractionWidth)
    }
}
