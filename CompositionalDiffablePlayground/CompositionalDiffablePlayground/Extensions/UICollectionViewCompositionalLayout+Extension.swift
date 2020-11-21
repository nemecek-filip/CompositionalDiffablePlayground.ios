//
//  UICollectionViewCompositionalLayout+Extension.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 21/11/2020.
//

import UIKit

extension UICollectionViewCompositionalLayout {
    static func listLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout(section: .listSection())
    }
}

