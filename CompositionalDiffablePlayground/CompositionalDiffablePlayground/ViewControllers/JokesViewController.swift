//
//  JokesViewController.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 28/11/2020.
//

import UIKit

class JokesViewController: CompositionalCollectionViewViewController {
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Sections, JokeDTO>
    
    var datasource: UICollectionViewDiffableDataSource<Sections, JokeDTO>!
    
    enum Sections: Hashable {
        case jokes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Jokes"
        
        collectionView.register(JokeCell.nib, forCellWithReuseIdentifier: JokeCell.reuseIdentifier)
        
        configureDatasource()
        
        loadJokes()
    }
    
    func configureDatasource() {
        datasource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, joke) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JokeCell.reuseIdentifier, for: indexPath) as! JokeCell
            cell.configure(withJoke: joke)
            return cell
        })
    }
    
    func loadJokes() {
        SimpleNetworkHelper.shared.getJokes { (jokes) in
            if let jokes = jokes {
                var snapshot = Snapshot()
                snapshot.appendSections([.jokes])
                snapshot.appendItems(jokes)
                
                // it is safe to call apply from background thread. But it must not be mixed with calling from main
                self.datasource.apply(snapshot, animatingDifferences: true)
            }
        }
    }
    
    override func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(120))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [layoutItem])
        layoutGroup.contentInsets = NSDirectionalEdgeInsets(horizontal: 10, vertical: 0)
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.interGroupSpacing = 10
        
        return UICollectionViewCompositionalLayout(section: layoutSection)
    }
}
