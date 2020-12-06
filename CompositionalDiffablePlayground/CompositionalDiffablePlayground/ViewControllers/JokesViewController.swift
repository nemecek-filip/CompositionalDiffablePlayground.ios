//
//  JokesViewController.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 28/11/2020.
//

import UIKit

class JokesViewController: CompositionalCollectionViewViewController {
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    typealias Datasource = UICollectionViewDiffableDataSource<Section, Item>
    
    var datasource: Datasource!
    
    enum Section: Hashable {
        case jokes
    }
    
    enum Item: Hashable {
        case loading(UUID)
        case joke(JokeDTO)
        
        static var loadingItems: [Item] {
            return Array(repeatingExpression: Item.loading(UUID()), count: 8)
        }
    }
    
    private var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        configureDatasource()
        
        loadJokes()
    }
    
    func setupView() {
        title = "Jokes"
        
        collectionView.register(JokeCell.nib, forCellWithReuseIdentifier: JokeCell.reuseIdentifier)
        collectionView.contentInset.top = 10
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.counterclockwise"), style: .plain, target: self, action: #selector(refreshTapped))
    }
    
    @objc func refreshTapped() {
        guard !isLoading else { return }
        datasource.apply(loadingSnapshot(), animatingDifferences: true)
        loadJokes()
    }
    
    func configureDatasource() {
        datasource = Datasource(collectionView: collectionView, cellProvider: cell(collectionView:indexPath:item:))
        
        datasource.apply(loadingSnapshot())
    }
    
    func cell(collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell? {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JokeCell.reuseIdentifier, for: indexPath) as! JokeCell
        
        switch item {
        case .joke(let jokeDto):
            cell.configure(withJoke: jokeDto)
            
        case .loading(_):
            cell.showLoading()
        }
        
        return cell
    }
    
    func loadingSnapshot() -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([.jokes])
        snapshot.appendItems(Item.loadingItems)
        return snapshot
    }
    
    func loadJokes() {
        isLoading = true
        SimpleNetworkHelper.shared.getJokes { (jokes) in
            if let jokes = jokes {
                var snapshot = Snapshot()
                snapshot.appendSections([.jokes])
                snapshot.appendItems(jokes.map{ Item.joke($0) })
                
                DispatchQueue.main.async {
                    self.datasource.apply(snapshot, animatingDifferences: true)
                }
                
            }
            
            self.isLoading = false
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
