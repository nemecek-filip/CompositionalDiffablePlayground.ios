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
    
    private var datasource: Datasource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        datasource.apply(snapshot(), animatingDifferences: true)
    }
    
    private func setupView() {
        title = "Modern Collection Views"
        
        collectionView.contentInset.top = 15
        collectionView.register(cell: LetterCell.self)
        
        datasource = Datasource(collectionView: collectionView, cellProvider: { [unowned self] collectionView, indexPath, item in
            return self.cell(collectionView: collectionView, indexPath: indexPath, item: item)
        })
    }
    
    private func snapshot() -> Snapshot {
        var snapshot = Snapshot()
        
        let words = ["Modern", "Collection", "Views"]
        
        for word in words {
            let section: Section = .word(word)
            snapshot.appendSections([section])
            
            for char in word {
                snapshot.appendItems([.letter(char as Character, UUID())], toSection: section)
            }
        }
        
        return snapshot
    }
    
    private func cell(collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LetterCell.reuseIdentifier, for: indexPath) as! LetterCell
        
        switch item {
        case .letter(let character, _):
            cell.configure(with: character)
        }
        
        return cell
    }
    
    
    override func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.165),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .uniform(size: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.165))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 15
        layout.configuration = config
        
        return layout
    }
    
}
