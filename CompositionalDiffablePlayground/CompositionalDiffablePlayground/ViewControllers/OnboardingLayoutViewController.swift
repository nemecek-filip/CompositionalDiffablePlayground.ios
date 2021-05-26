//
//  OnboardingLayoutViewController.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 29/01/2021.
//

import UIKit

class OnboardingLayoutViewController: CompositionalCollectionViewViewController {
    typealias Datasource = UICollectionViewDiffableDataSource<Int, Color>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Color>
    
    private var datasource: Datasource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "forward.end"), style: .plain, target: self, action: #selector(skipTapped))
    }
    
    @objc func skipTapped() {
        // there is a bug in UICollectionView in iOS 14, scrollToItem does not work if the orthogonalScrollingBehavior is set to paging
        collectionView.setContentOffset(CGPoint(x: collectionView.bounds.width * 5, y: 0), animated: true)
    }
    
    private func setupView() {
        title = "Onboarding example"

        collectionView.register(cell: ColorCell.self)
        collectionView.register(header: SimpleHeaderView.self)
        collectionView.alwaysBounceVertical = false
        
        datasource = Datasource(collectionView: collectionView, cellProvider: { [unowned self] collectionView, indexPath, item in
            return self.cell(collectionView: collectionView, indexPath: indexPath, item: item)
        })
        
        datasource.apply(snapshot(), animatingDifferences: false)
    }
    
    func snapshot() -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(Array(repeatingExpression: Color(), count: 6))
        return snapshot
    }
    
    func cell(collectionView: UICollectionView, indexPath: IndexPath, item: Color) -> UICollectionViewCell {
        //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.reuseIdentifier, for: indexPath) as! ColorCell
        
        let cell: ColorCell = collectionView.dequeue(for: indexPath)
        
        cell.contentView.backgroundColor = item.color
        return cell
    }
    
    override func createLayout() -> UICollectionViewLayout {
        let item = NSCollectionLayoutItem.withEntireSize()
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.95))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(horizontal: 15, vertical: 5)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
}
