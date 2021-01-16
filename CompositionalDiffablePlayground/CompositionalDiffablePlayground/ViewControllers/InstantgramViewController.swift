//
//  InstantgramViewController.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 16/01/2021.
//

import UIKit

class InstantgramViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    
    typealias Datasource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    enum Section: Hashable {
        case header
        case highlights
        case photos
    }
    
    enum Item: Hashable {
        case header(ProfileHeaderData)
        case highlight(ProfileHighlight)
    }
    
    var demoProfileData: ProfileHeaderData {
        return ProfileHeaderData(name: "Planet Pennies", accountType: "News/Entertainment Company", postCount: 482)
    }
    
    private var datasource: Datasource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Instantgram Profile"
        
        collectionView.setCollectionViewLayout(createLayout(), animated: true)
        
        configureDatasource()
    }
    
    private func configureDatasource() {
        datasource = Datasource(collectionView: collectionView, cellProvider: cell(collectionView:indexPath:item:))
        
        datasource.apply(snapshot(), animatingDifferences: false)
    }
    
    private func cell(collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell {
        switch item {
        case .header(let data):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileHeaderCell.reuseIdentifier, for: indexPath) as! ProfileHeaderCell
            cell.configure(with: data)
            return cell
            
        case .highlight(let data):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileHighlightCell.reuseIdentifier, for: indexPath) as! ProfileHighlightCell
            cell.configure(with: data)
            return cell
        }
    }
    
    func snapshot() -> Snapshot {
        var snapshot = Snapshot()
        
        snapshot.appendSections([.header])
        snapshot.appendItems([.header(demoProfileData)], toSection: .header)
        
        snapshot.appendSections([.highlights])
        snapshot.appendItems(ProfileHighlight.demoHighlights.map({ Item.highlight($0) }), toSection: .highlights)
        
        return snapshot
    }

}

// MARK: Layout
extension InstantgramViewController {
    func createHeaderSection() -> NSCollectionLayoutSection {
        let headerItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        let headerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.3)), subitems: [headerItem])
        
        return NSCollectionLayoutSection(group: headerGroup)
    }
    
    func createHighlightsSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2), heightDimension: .fractionalWidth(0.22)))
        item.contentInsets = .init(horizontal: 5, vertical: 0)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(100)), subitem: item, count: 4)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 0)
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
    
    func sectionFor(index: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let section = datasource.snapshot().sectionIdentifiers[index]
        
        switch section {
        case .header:
            return createHeaderSection()
        case .highlights:
            return createHighlightsSection()
        case .photos:
            return createHighlightsSection()
        }
    }
    
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout(sectionProvider: sectionFor(index:environment:))
    }
}
