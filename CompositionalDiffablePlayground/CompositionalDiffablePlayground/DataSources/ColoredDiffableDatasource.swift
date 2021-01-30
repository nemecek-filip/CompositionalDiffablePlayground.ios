//
//  ColoredDiffableDatasource.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 14/11/2020.
//

import UIKit

class ColoredDiffableDataSource: UICollectionViewDiffableDataSource<Int, UIColor> {
    init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView) { (collectionView, indexPath, color) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.reuseIdentifier, for: indexPath)
            cell.contentView.backgroundColor = color
            return cell
        }
    }
}
