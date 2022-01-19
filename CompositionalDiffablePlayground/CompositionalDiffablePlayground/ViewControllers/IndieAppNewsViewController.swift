//
//  IndieAppNewsViewController.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 02.01.2022.
//

import UIKit
import SafariServices

class IndieAppNewsViewController: CompositionalCollectionViewViewController {
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    typealias Datasource = UICollectionViewDiffableDataSource<Section, Item>
    
    enum Section: Hashable {
        case news
    }
    
    enum Item: Hashable {
        case loading(UUID)
        case news(AppNewsDTO)
        
        var isLoading: Bool {
            switch self {
            case .loading(_):
                return true
            default:
                return false
            }
        }
        
        static var loadingItems: [Item] {
            return Array(repeatingExpression: Item.loading(UUID()), count: 5)
        }
    }
    
    private var appNewsResults: AppNewsResultsDTO? {
        didSet {
            datasource.apply(snapshot(), animatingDifferences: true)
        }
    }
    
    var datasource: Datasource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        configureDatasource()
        
        loadData()
    }
    
    private func loadData() {
        // Delay to see the shimmer effect for a bit
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            SimpleNetworkHelper.shared.getAppNews { results in
                self.appNewsResults = results
            }
        }
    }
    
    private func setupView() {
        title = "Indie App News"
        
        collectionView.register(cellFromNib: IndieAppNewsCell.self)
        collectionView.contentInset.top = 15
        collectionView.delegate = self
    }
    
    private func configureDatasource() {
        datasource = Datasource(collectionView: collectionView, cellProvider: { [unowned self] collectionView, indexPath, item in
            return self.cell(collectionView: collectionView, indexPath: indexPath, item: item)
        })
        
        datasource.apply(snapshot(), animatingDifferences: false)
    }
    
    private func snapshot() -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([.news])
        
        if let appNewsResults = appNewsResults {
            snapshot.appendItems(appNewsResults.results.map(Item.news), toSection: .news)
        } else {
            snapshot.appendItems(Item.loadingItems, toSection: .news)
        }
        
        return snapshot
    }
    
    private func cell(collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell {
        switch item {
        case .loading(_):
            let cell: IndieAppNewsCell = collectionView.dequeue(for: indexPath)
            cell.showLoading()
            return cell
            
        case .news(let news):
            let cell: IndieAppNewsCell = collectionView.dequeue(for: indexPath)
            cell.configure(with: news)
            return cell
        }
    }
    
    override func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout(section: .listSection(withEstimatedHeight: 200))
        
        return layout
    }
}

extension IndieAppNewsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = datasource.itemIdentifier(for: indexPath) else { return }
        
        switch item {
        case .news(let news):
            if let url = URL(string: news.detailUrl) {
                let svc = SFSafariViewController(url: url)
                present(svc, animated: true, completion: nil)
            }
            
        case .loading(_):
            break
        }
    }
}
