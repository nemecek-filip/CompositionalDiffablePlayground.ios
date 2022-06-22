//
//  SettingsExampleViewController.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 10.06.2022.
//

import UIKit

@available(iOS 14.0, *)
class SettingsExampleViewController: CompositionalCollectionViewViewController {
    typealias Datasource = UICollectionViewDiffableDataSource<String, SettingsItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<String, SettingsItem>
    
    struct SettingsItem: Hashable {
        let title: String
        let symbolName: String
        
        static let general: [SettingsItem] = [
            .init(title: "Airplane Mode", symbolName: "airplane"),
            .init(title: "Wi-Fi", symbolName: "wifi"),
            .init(title: "Mobile Data", symbolName: "antenna.radiowaves.left.and.right")
        ]
    }
    
    let settingsRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SettingsItem> {
        cell, indexPath, item in
        
        var content = cell.defaultContentConfiguration()
        
        content.text = item.title
        content.image = UIImage(systemName: item.symbolName)
        
        cell.accessories = [.disclosureIndicator()]
        
        cell.contentConfiguration = content
    }
    
    var datasource: Datasource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Example Settings"
        
        datasource = Datasource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: self.settingsRegistration, for: indexPath, item: itemIdentifier)
        })
        
        loadData()
    }
    
    private func loadData() {
        var snapshot = Snapshot()
        
        snapshot.appendSections(["General"])
        snapshot.appendItems(SettingsItem.general)
        
        datasource.apply(snapshot, animatingDifferences: false)
    }
    
    override func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout.list(using: .init(appearance: .insetGrouped))
    }
}
