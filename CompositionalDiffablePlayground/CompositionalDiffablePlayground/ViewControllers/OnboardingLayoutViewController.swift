//
//  OnboardingLayoutViewController.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 29/01/2021.
//

import UIKit

class OnboardingLayoutViewController: CompositionalCollectionViewViewController {
    
    private var datasource: ColoredDiffableDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "forward.end"), style: .plain, target: self, action: #selector(skipTapped))
    }
    
    @objc func skipTapped() {
        // not implemented yet
    }
    
    private func setupView() {
        title = "Onboarding example"

        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.reuseIdentifier)
        collectionView.alwaysBounceVertical = false
        
        datasource = ColoredDiffableDataSource(collectionView: collectionView)
        
        datasource.apply(ColorsSnapshot.random())
    }
    
    override func createLayout() -> UICollectionViewLayout {
        let item = NSCollectionLayoutItem.withEntireSize()
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.95))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(horizontal: 15, vertical: 5)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
}
