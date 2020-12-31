//
//  BadgesViewController.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 31/12/2020.
//

import UIKit

class BadgesViewController: CompositionalCollectionViewViewController {
    
    private var datasource: ColoredDiffableDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.reuseIdentifier)
        
        datasource = ColoredDiffableDataSource(collectionView: collectionView)
        
        datasource.apply(ColorsSnapshot.random())
    }
    
    override func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout(section: .largeGridSection(itemInsets: .uniform(size: 15)))
    }
}
