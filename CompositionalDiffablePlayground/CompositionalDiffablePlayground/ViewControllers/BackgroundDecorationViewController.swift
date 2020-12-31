//
//  BackgroundDecorationViewController.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 28/12/2020.
//

import UIKit

class BackgroundDecorationViewController: CompositionalCollectionViewViewController {
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>
    
    var datasource: ItemsDiffableDataSource!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Background decoration"
        
        collectionView.register(ItemCell.self, forCellWithReuseIdentifier: ItemCell.reuseIdentifier)
        collectionView.contentInset.top = 10
        
        datasource = ItemsDiffableDataSource(collectionView: collectionView)
        
        datasource.apply(snapshot(), animatingDifferences: false)
    }
    
    func snapshot() -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([1, 2])
        
        var count = 1
        for _ in 1...15 {
            snapshot.appendItems(["Item #\(count)"], toSection: 1)
            count += 1
        }
        
        count = 1
        for _ in 1...7 {
            snapshot.appendItems(["Item no.\(count)"], toSection: 2)
            count += 1
        }
        
        return snapshot
    }
    
    override func createLayout() -> UICollectionViewLayout {
        let section: NSCollectionLayoutSection = .listSection()
        
        section.decorationItems = [
            NSCollectionLayoutDecorationItem.background(elementKind: RoundedBackgroundView.reuseIdentifier)
        ]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        layout.register(RoundedBackgroundView.self, forDecorationViewOfKind: RoundedBackgroundView.reuseIdentifier)
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 15
        layout.configuration = config
        
        return layout
    }
    
}
