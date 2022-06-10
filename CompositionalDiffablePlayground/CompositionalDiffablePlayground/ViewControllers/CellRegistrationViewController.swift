//
//  CellRegistrationViewController.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 26/12/2020.
//

import UIKit

@available(iOS 14.0, *)
class CellRegistrationViewController: CompositionalCollectionViewViewController {
    
    private var colorCellRegistration: UICollectionView.CellRegistration<ColorCell, Color>!
    
    private var datasource: UICollectionViewDiffableDataSource<Int, Color>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Cell registration"
        
        setupView()
    }
    
    private func setupView() {
        colorCellRegistration = UICollectionView.CellRegistration { cell, indexPath, color in
            cell.contentView.backgroundColor = color.color
        }
        
        datasource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { [unowned self] (collectionView, indexPath, model) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: self.colorCellRegistration, for: indexPath, item: model)
            
            return cell
        })
        
        datasource.apply(ColorsSnapshot.random())
    }
    
    override func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout.list(using: .init(appearance: .insetGrouped))
    }
}

