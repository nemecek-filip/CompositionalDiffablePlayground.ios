//
//  JokesViewController.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 28/11/2020.
//

import UIKit
import CoreData

class JokesViewController: CompositionalCollectionViewViewController {
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    typealias Datasource = UICollectionViewDiffableDataSource<Section, Item>
    
    var datasource: Datasource!
    var fetchedResultsController: NSFetchedResultsController<Joke>!
    
    enum Section: Hashable {
        case favoriteJokes
        case jokes
    }
    
    enum Item: Hashable {
        case loading(UUID)
        case joke(JokeDTO)
        case favorite(Joke)
        
        static var loadingItems: [Item] {
            return Array(repeatingExpression: Item.loading(UUID()), count: 8)
        }
    }
    
    private var isLoading = false
    
    var fetchedJokes: [JokeDTO]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        configureDatasource()
        initFetchedResultsController()
        
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
        fetchedJokes = nil
        datasource.apply(snapshot(), animatingDifferences: true)
        loadJokes()
    }
    
    func configureDatasource() {
        datasource = Datasource(collectionView: collectionView, cellProvider: cell(collectionView:indexPath:item:))
    }
    
    func initFetchedResultsController() {
        fetchedResultsController = NSFetchedResultsController(fetchRequest: Joke.sortedFetchRequest, managedObjectContext: Database.shared.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        try! fetchedResultsController.performFetch()
    }
    
    func snapshot() -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([.favoriteJokes, .jokes])
        let favorites: [Joke] = fetchedResultsController.fetchedObjects ?? []
        snapshot.appendItems(favorites.map({ Item.favorite($0) }), toSection: .favoriteJokes)
        
        if let fetched = fetchedJokes {
            snapshot.appendItems(fetched.map({ Item.joke($0)}), toSection: .jokes)
        } else {
            snapshot.appendItems(Item.loadingItems, toSection: .jokes)
        }
        
        return snapshot
    }

    func favoriteJoke(_ joke: JokeDTO) {
        let existing = try? Database.shared.context.fetch(Joke.byIdFetchRequest(id: joke.id)).first
        
        guard existing == nil else { return }
        
        let new = Joke(context: Database.shared.context)
        new.configure(with: joke)
        Database.shared.saveContext()
    }
    
    func cell(collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell? {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JokeCell.reuseIdentifier, for: indexPath) as! JokeCell
        
        switch item {
        case .joke(let jokeDto):
            cell.configure(withJoke: jokeDto)
            cell.favoriteAction = { [weak self] in
                self?.favoriteJoke(jokeDto)
            }
            
        case .favorite(let joke):
            cell.configure(with: joke)
            
        case .loading(_):
            cell.showLoading()
        }
        
        return cell
    }
    
    func loadJokes() {
        isLoading = true
        SimpleNetworkHelper.shared.getJokes { (jokes) in
            if let jokes = jokes {
                self.fetchedJokes = jokes
                
                DispatchQueue.main.async {
                    self.datasource.apply(self.snapshot(), animatingDifferences: true)
                }
                
            } else {
                self.fetchedJokes = []
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
        
        let layout = UICollectionViewCompositionalLayout(section: layoutSection)
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        
        return layout
    }
}

extension JokesViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        datasource.apply(self.snapshot(), animatingDifferences: true)
    }
}
