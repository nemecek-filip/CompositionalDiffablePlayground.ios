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
    }
    
    enum Item: Hashable {
        case header(ProfileHeaderData)
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
        }
    }
    
    func snapshot() -> Snapshot {
        var snapshot = Snapshot()
        
        snapshot.appendSections([.header])
        snapshot.appendItems([.header(demoProfileData)], toSection: .header)
        
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
    
    func sectionFor(index: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        return createHeaderSection()
    }
    
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout(sectionProvider: sectionFor(index:environment:))
    }
}
