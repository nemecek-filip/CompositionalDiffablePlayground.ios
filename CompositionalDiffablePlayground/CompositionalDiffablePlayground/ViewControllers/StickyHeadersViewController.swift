//
//  StickyHeadersViewController.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 09.02.2021.
//

import UIKit

class StickyHeadersViewController: BackgroundDecorationViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Sticky headers"
        
        collectionView.contentInset.top = 0
        collectionView.register(header: StickyHeaderView.self)
    }
    
    override func configureDatasource() {
        datasource = ItemsDiffableDataSource(collectionView: collectionView)
        datasource.supplementaryViewProvider = supplementary(collectionView:kind:indexPath:)
        
        datasource.apply(snapshot(), animatingDifferences: false)
    }
    
    func supplementary(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: StickyHeaderView.reuseIdentifier, for: indexPath) as! StickyHeaderView
        
        header.configure(with: "Sticky header \(indexPath.section + 1)")
        
        return header
    }
    
    override func createLayout() -> UICollectionViewLayout {
        let section: NSCollectionLayoutSection = .listSection()
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        // this activates the "sticky" behaviour
        headerElement.pinToVisibleBounds = true
        
        section.boundarySupplementaryItems = [headerElement]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 15
        layout.configuration = config
        
        return layout
    }
    
    override func snapshot() -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([1, 2, 3, 4])
        
        var count = 1
        for _ in 1...7 {
            snapshot.appendItems(["Item #\(count)"], toSection: 1)
            count += 1
        }
        
        count = 1
        for _ in 1...6 {
            snapshot.appendItems(["Item no.\(count)"], toSection: 2)
            count += 1
        }
        
        for _ in 1...6 {
            snapshot.appendItems(["Item n.\(count)"], toSection: 3)
            count += 1
        }
        
        for _ in 1...6 {
            snapshot.appendItems(["#\(count) Item"], toSection: 4)
            count += 1
        }
        
        return snapshot
    }
    
}
