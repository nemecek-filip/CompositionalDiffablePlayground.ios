//
//  JokesViewController.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 28/11/2020.
//

import UIKit

class JokesViewController: CompositionalCollectionViewViewController {
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Sections, Item>
    
    var datasource: UICollectionViewDiffableDataSource<Sections, Item>!
    
    enum Sections: Hashable {
        case jokes
    }
    
    enum Item: Hashable {
        case loading(UUID)
        case joke(JokeDTO)
        
        static var loadings: [Item] {
            return [.loading(UUID()), .loading(UUID()), .loading(UUID()), .loading(UUID()), .loading(UUID()), .loading(UUID())]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Jokes"
        
        collectionView.register(JokeCell.nib, forCellWithReuseIdentifier: JokeCell.reuseIdentifier)
        collectionView.contentInset.top = 10
        
        configureDatasource()
        
        loadJokes()
    }
    
    func configureDatasource() {
        datasource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JokeCell.reuseIdentifier, for: indexPath) as! JokeCell
            
            switch item {
            case .joke(let jokeDto):
                cell.configure(withJoke: jokeDto)
                
            case .loading(_):
                cell.showLoading()
            }
            
            
            return cell
        })
        
        var snapshot = Snapshot()
        snapshot.appendSections([.jokes])
        snapshot.appendItems(Item.loadings)
        datasource.apply(snapshot)
    }
    
    func loadJokes() {
        SimpleNetworkHelper.shared.getJokes { (jokes) in
            if let jokes = jokes {
                var snapshot = Snapshot()
                snapshot.appendSections([.jokes])
                snapshot.appendItems(jokes.map{ Item.joke($0) })
                
                DispatchQueue.main.async {
                    self.datasource.apply(snapshot, animatingDifferences: true)
                }
                
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
