//
//  ItemsDiffableDatasource.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 27/12/2020.
//

import UIKit

class ItemsDiffableDataSource: UICollectionViewDiffableDataSource<Int, String> {
    init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView) { (collectionView, indexPath, text) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.reuseIdentifier, for: indexPath) as! ItemCell
            cell.configure(with: text)
            return cell
        }
    }
}
