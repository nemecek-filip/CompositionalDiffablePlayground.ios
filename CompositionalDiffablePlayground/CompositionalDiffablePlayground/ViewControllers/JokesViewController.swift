//
//  JokesViewController.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 28/11/2020.
//

import UIKit
import CoreData
import AVFoundation

class JokesViewController: CompositionalCollectionViewViewController {
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    typealias Datasource = UICollectionViewDiffableDataSource<Section, Item>
    
    var datasource: Datasource!
    var fetchedResultsController: NSFetchedResultsController<Joke>!
    
    var speechSynthesizer = AVSpeechSynthesizer()
    
    enum Section: Hashable {
        case favoriteJokes(count: Int)
        case jokes
    }
    
    enum Item: Hashable {
        case loading(UUID)
        case joke(JokeDTO)
        case favorite(Joke)
        
        var isLoading: Bool {
            switch self {
            case .loading(_):
                return true
            default:
                return false
            }
        }
        
        var jokeData: JokeProtocol? {
            switch self {
            case .loading(_):
                return nil
            case .favorite(let favorite):
                return favorite
            case .joke(let data):
                return data
            }
        }
        
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
        
        collectionView.register(SimpleHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SimpleHeaderView.reuseIdentifier)
        collectionView.register(JokeCell.nib, forCellWithReuseIdentifier: JokeCell.reuseIdentifier)
        collectionView.contentInset.top = 10
        collectionView.delegate = self
        
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
        
        datasource.supplementaryViewProvider = supplementary(collectionView:kind:indexPath:)
    }
    
    func initFetchedResultsController() {
        fetchedResultsController = NSFetchedResultsController(fetchRequest: Joke.sortedFetchRequest, managedObjectContext: Database.shared.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        try! fetchedResultsController.performFetch()
    }
    
    // MARK: snapshot()
    func snapshot() -> Snapshot {
        var snapshot = Snapshot()
        
        let favorites: [Joke] = fetchedResultsController.fetchedObjects ?? []
        let favoritesSection: Section = .favoriteJokes(count: favorites.count)
        snapshot.appendSections([favoritesSection, .jokes])
        
        snapshot.appendItems(favorites.map({ Item.favorite($0) }), toSection: favoritesSection)
        
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
    
    func unfavoriteJoke(withId id: Int) {
        if let joke = try? Database.shared.context.fetch(Joke.byIdFetchRequest(id: id)).first {
            Database.shared.context.delete(joke)
            Database.shared.saveContext()
        }
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
            let jokeId = joke.id
            cell.favoriteAction = { [weak self] in
                self?.unfavoriteJoke(withId: jokeId)
            }
            
        case .loading(_):
            cell.showLoading()
        }
        
        return cell
    }
    
    func supplementary(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? {
        guard kind == UICollectionView.elementKindSectionHeader else { return nil }
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SimpleHeaderView.reuseIdentifier, for: indexPath) as! SimpleHeaderView
        
        let section = datasource.snapshot().sectionIdentifiers[indexPath.section]
        
        switch section {
        case .favoriteJokes(let count):
            header.configure(with: "Favorites (\(count))")
        case .jokes:
            header.configure(with: "Random")
        }
        
        return header
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
        
        addStandardHeader(toSection: layoutSection)
        
        let layout = UICollectionViewCompositionalLayout(section: layoutSection)
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        
        return layout
    }
    
    private func addStandardHeader(toSection section: NSCollectionLayoutSection) {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [headerElement]
    }
}

extension JokesViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        datasource.apply(self.snapshot(), animatingDifferences: true)
    }
}

extension JokesViewController: UICollectionViewDelegate {
    func speak(joke: JokeProtocol) {
        let utterance = AVSpeechUtterance(string: "\(joke.setup)::: \(joke.punchline)")
        
        speechSynthesizer.speak(utterance)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let item = datasource.itemIdentifier(for: indexPath) else { return nil }
        guard !item.isLoading else { return nil }
        
        var actions = [UIAction]()
        
        let speak = UIAction(title: "Hear", image: UIImage(systemName: "ear")) {_ in
            if let joke = item.jokeData {
                self.speak(joke: joke)
            }
        }
        
        actions.append(speak)
        
        switch item {
        case .favorite(let favorite):
            let id = favorite.id
            let unfavorite = UIAction(title: "Unfavorite", image: UIImage(systemName: "star.slash")) { _ in
                self.unfavoriteJoke(withId: id)
            }
            actions.append(unfavorite)
        default:
            break
        }
        
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil) { _ in
            UIMenu(title: "Actions", children: actions)
        }
    }
}
