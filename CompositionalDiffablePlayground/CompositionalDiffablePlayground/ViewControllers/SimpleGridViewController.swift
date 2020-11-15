//
//  SimpleGridViewController.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 15/11/2020.
//

import UIKit

class SimpleGridViewController: CompositionalCollectionViewViewController {
    
    var datasource: ColoredDiffableDataSource!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Simple Grid example"

        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: "ColorCell")
        
        datasource = ColoredDiffableDataSource(collectionView: collectionView)
        
        datasource.apply(ColorsSnapshot.random())
    }
    
    override func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout(section: .listLayout())
    }
}
