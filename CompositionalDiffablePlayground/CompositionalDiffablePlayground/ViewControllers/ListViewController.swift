//
//  ListViewController.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 14/11/2020.
//

import UIKit

class ListViewController: UIViewController {
    var collectionView: UICollectionView!
    
    var datasource: ColoredDiffableDataSource!
    
    override func loadView() {
        view = UIView()
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "List example"

        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: "ColorCell")
        
        datasource = ColoredDiffableDataSource(collectionView: collectionView)
        
        loadData()
    }
    
    private func loadData() {
        var snapshot = ColorsSnapshot()
        
        snapshot.appendSections([0])
        
        var items = [UIColor]()
        for _ in 0...10 {
            items.append(UIColor.random())
        }
        snapshot.appendItems(items)
        
        datasource.apply(snapshot)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout(section: .listLayout())
    }
    
}
