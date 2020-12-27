//
//  ItemsDiffableDatasource.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 27/12/2020.
//

import UIKit

class ItemsDiffableDataSource: UICollectionViewDiffableDataSource<Int, String> {
    init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView) { (collectionView, indexPath, color) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath)
            
            return cell
        }
    }
}
