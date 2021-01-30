//
//  SystemListViewController.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 21/11/2020.
//

import UIKit

@available(iOS 14.0, *)
class SystemListViewController: CompositionalCollectionViewViewController {
    
    struct ListAppearance {
        let name: String
        let appearance: UICollectionLayoutListConfiguration.Appearance
        
        static let allOptions: [ListAppearance] = [
            ListAppearance(name: "Plain", appearance: .plain),
            ListAppearance(name: "Grouped", appearance: .grouped),
            ListAppearance(name: "Inset Grouped", appearance: .insetGrouped),
            ListAppearance(name: "Sidebar", appearance: .sidebar),
            ListAppearance(name: "Sidebar plain", appearance: .sidebarPlain)
        ]
    }
    
    let defaultAppearance = ListAppearance.allOptions.first!
    
    var datasource: ColoredDiffableDataSource!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "System list example"

        collectionView.register(cell: ColorCell.self)
        collectionView.contentInset.top = 10
        
        datasource = ColoredDiffableDataSource(collectionView: collectionView)
        
        loadData()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(showChangeApperanceDialog))
    }
    
    private func loadData() {
        var snapshot = ColorsSnapshot()
        snapshot.appendSections([0, 1, 2])
        snapshot.addRandomItems(count: 10, to: 0)
        snapshot.addRandomItems(count: 10, to: 1)
        snapshot.addRandomItems(count: 10, to: 2)
        
        datasource.apply(snapshot)
    }
    
    @objc func showChangeApperanceDialog() {
        let ac = UIAlertController(title: "Select appearance", message: nil, preferredStyle: .alert)
        
        SystemListViewController.ListAppearance.allOptions.forEach { (option) in
            ac.addAction(UIAlertAction(title: option.name, style: .default, handler: { (_) in
                self.setAppearance(option)
            }))
        }
        
        ac.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        
        present(ac, animated: true, completion: nil)
    }
    
    private func setAppearance(_ appearance: ListAppearance) {
        collectionView.setCollectionViewLayout(UICollectionViewCompositionalLayout.list(using: .init(appearance: appearance.appearance)), animated: true)
    }

    override func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout.list(using: .init(appearance: defaultAppearance.appearance))
    }
}
