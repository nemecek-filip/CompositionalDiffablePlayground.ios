//
//  BadgesViewController.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 31/12/2020.
//

import UIKit

class BadgesViewController: CompositionalCollectionViewViewController {
    
    private var datasource: ColoredDiffableDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Badges example"
        
        setupView()
    }
    
    private func setupView() {
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.reuseIdentifier)
        collectionView.register(BadgeView.self, forSupplementaryViewOfKind: BadgeView.reuseIdentifier, withReuseIdentifier: BadgeView.reuseIdentifier)
        collectionView.register(UpdatedInfoView.self, forSupplementaryViewOfKind: UpdatedInfoView.reuseIdentifier, withReuseIdentifier: UpdatedInfoView.reuseIdentifier)
        
        datasource = ColoredDiffableDataSource(collectionView: collectionView)
        
        datasource.supplementaryViewProvider = { [unowned self] collectionView, kind, indexPath in
            return self.supplementary(collectionView: collectionView, kind: kind, indexPath: indexPath)
        }
        
        datasource.apply(ColorsSnapshot.random())
    }
    
    func supplementary(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? {
        
        switch kind {
        case BadgeView.reuseIdentifier:
            let badge = collectionView.dequeueReusableSupplementaryView(ofKind: BadgeView.reuseIdentifier, withReuseIdentifier: BadgeView.reuseIdentifier, for: indexPath) as! BadgeView
            
            // we must always return a view, so to not show it we need to hide it. In this example randomly
            badge.isHidden = Bool.random()
            
            return badge
            
        case UpdatedInfoView.reuseIdentifier:
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UpdatedInfoView.reuseIdentifier, withReuseIdentifier: UpdatedInfoView.reuseIdentifier, for: indexPath)
            
            view.isHidden = Int.random(in: 0...6) > 4
            
            return view
            
        default:
            assertionFailure("Handle new kind")
            return nil
        }
    }
    
    override func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize, supplementaryItems: [createBadgeItem(), createdUpdatedInfoItem()])
        item.contentInsets = .uniform(size: 15)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func createBadgeItem() -> NSCollectionLayoutSupplementaryItem {
        let topRightAnchor = NSCollectionLayoutAnchor(edges: [.top, .trailing], fractionalOffset: CGPoint(x: 0.2, y: -0.2))
        
        let badgeSize: CGFloat = 18
        
        let item = NSCollectionLayoutSupplementaryItem(layoutSize: .init(widthDimension: .absolute(badgeSize), heightDimension: .absolute(badgeSize)), elementKind: BadgeView.reuseIdentifier, containerAnchor: topRightAnchor)
        
        return item
    }
    
    private func createdUpdatedInfoItem() -> NSCollectionLayoutSupplementaryItem {
        let bottomAnchor = NSCollectionLayoutAnchor(edges: [.bottom, .leading, .trailing], fractionalOffset: CGPoint(x: 0, y: 0.3))
        
        let item = NSCollectionLayoutSupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1.05), heightDimension: .estimated(20)), elementKind: UpdatedInfoView.reuseIdentifier, containerAnchor: bottomAnchor)
        
        return item
    }
}
