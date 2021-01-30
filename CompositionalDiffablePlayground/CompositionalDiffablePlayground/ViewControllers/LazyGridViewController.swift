//
//  LazyGridViewController.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 18/11/2020.
//

import UIKit

class LazyGridViewController: CompositionalCollectionViewViewController {
    
    private let maxItemCount = 100
    private var loadedCount = 0
    
    private var loadingInProgress = false
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        indicator.hidesWhenStopped = true
        
        return indicator
    }()
    
    var datasource: ColoredDiffableDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        datasource = ColoredDiffableDataSource(collectionView: collectionView)
        
        loadData(isInitialLoad: true)
        
        updateTitle()
    }
    
    private func setupView() {
        let layoutGuide = view.safeAreaLayoutGuide
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            layoutGuide.centerXAnchor.constraint(equalTo: loadingIndicator.centerXAnchor),
            layoutGuide.bottomAnchor.constraint(equalTo: loadingIndicator.bottomAnchor, constant: 10)
        ])
        
        collectionView.register(cell: ColorCell.self)
        collectionView.delegate = self
        collectionView.contentInset.bottom = 50
    }
    
    private func updateTitle() {
        if loadedCount >= maxItemCount {
            title = "All items loaded"
        } else {
            title = "Loaded \(loadedCount) items"
        }
    }
    
    func loadData(isInitialLoad: Bool = false) {
        guard datasource.snapshot().numberOfItems < maxItemCount else { return }
        guard !loadingInProgress else { return }
        loadingInProgress = true
        loadingIndicator.startAnimating()
        
        var snapshot = datasource.snapshot()
        if snapshot.numberOfSections == 0 {
            snapshot.appendSections([0])
        }
        
        snapshot.addRandomItems(count: 12)
        
        let loadTime: TimeInterval = isInitialLoad ? 0 : 1.4
        DispatchQueue.main.asyncAfter(deadline: .now() + loadTime) {
            self.datasource.apply(snapshot, animatingDifferences: true)
            
            self.loadedCount = snapshot.numberOfItems
            self.updateTitle()
            self.loadingInProgress = false
            self.loadingIndicator.stopAnimating()
        }
    }
    
    override func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .uniform(size: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
}

extension LazyGridViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard loadedCount != 0 else { return }
        
        // displaying last item
        if indexPath.row == loadedCount - 1 {
            loadData()
        }
    }
}
