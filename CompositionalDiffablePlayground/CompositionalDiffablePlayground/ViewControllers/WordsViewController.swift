//
//  WordsViewController.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 12/01/2021.
//

import UIKit

class WordsViewController: CompositionalCollectionViewViewController {
    
    typealias Datasource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    enum Section: Hashable {
        case word(String)
    }
    
    enum Item: Hashable {
        case letter(Character, UUID)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Modern Collection Views"
    }
    
    
    override func createLayout() -> UICollectionViewLayout {
        fatalError()
    }
    
}
