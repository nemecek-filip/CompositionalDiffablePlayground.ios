//
//  GroupExampleController.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 02/01/2021.
//

import UIKit

// this is not available via the app, I used it for one of my blogposts
// https://nemecek.be/blog/66/detailed-look-at-the-nscollectionlayoutgroup
class GroupExampleController: CompositionalCollectionViewViewController {
    
    var datasource: ColoredDiffableDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Group example"
        
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.reuseIdentifier)
        
        datasource = ColoredDiffableDataSource(collectionView: collectionView)
        
        datasource.apply(ColorsSnapshot.random())
    }
    
    override func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.5))
        
        //let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let subgroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(0.5)), subitem: item, count: 2)
        
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: subgroup, count: 2)
        
        //let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, subgroup])
        
        
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: subgroup, count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 30
        
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
