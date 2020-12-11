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
        datasource.apply(loadingSnapshot(), animatingDifferences: true)
        loadJokes()
    }
    
    func configureDatasource() {
        datasource = Datasource(collectionView: collectionView, cellProvider: cell(collectionView:indexPath:item:))
        
        datasource.apply(loadingSnapshot())
    }
    
    func initFetchedResultsController() {
        fetchedResultsController = NSFetchedResultsController(fetchRequest: Joke.sortedFetchRequest, managedObjectContext: Database.shared.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        try! fetchedResultsController.performFetch()
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
                var snapshot = self.datasource.snapshot()
                snapshot.deleteSections([.jokes])
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
        
        let layout = UICollectionViewCompositionalLayout(section: layoutSection)
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        
        return layout
    }
}

extension JokesViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        var snapshot = datasource.snapshot()
        snapshot.deleteSections([.favoriteJokes])
        snapshot.appendSections([.favoriteJokes])
        
        // FIXME - Please let me know if you have more elegant code for this. Mixing FRC and Diffable feels weird at times
        
        let jokes: [Item] = fetchedResultsController.fetchedObjects?.map({ Item.favorite($0)}) ?? []
        
        snapshot.appendItems(jokes, toSection: .favoriteJokes)
        datasource.apply(snapshot, animatingDifferences: true)
    }
}
