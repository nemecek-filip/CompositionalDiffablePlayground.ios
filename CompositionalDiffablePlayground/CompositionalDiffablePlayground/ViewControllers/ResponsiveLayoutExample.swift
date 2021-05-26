//
//  ResponsiveLayoutExample.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 10.02.2021.
//

import UIKit

class ResponsiveLayoutViewController: CompositionalCollectionViewViewController {
    
    var datasource: ColoredDiffableDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Responsive layout"
        
        collectionView.register(cell: ColorCell.self)
        
        configureDatasource()
    }
    
    private func configureDatasource() {
        datasource = ColoredDiffableDataSource(collectionView: collectionView)
        
        datasource.apply(ColorsSnapshot.random(), animatingDifferences: false)
    }
    
    private func layoutSection(forIndex index: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        
        // approximate width we want to base our calculations on
        let desiredWidth: CGFloat = 230
        
        let itemCount = environment.container.effectiveContentSize.width / desiredWidth
        
        let fractionWidth: CGFloat = 1 / (itemCount.rounded())
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fractionWidth),                                      heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .small()
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),                                               heightDimension: .fractionalWidth(fractionWidth))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        return NSCollectionLayoutSection(group: group)
    }
    
    override func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [unowned self] index, env in
            return self.layoutSection(forIndex: index, environment: env)
        }
    }
}
