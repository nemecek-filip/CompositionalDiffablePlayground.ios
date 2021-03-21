//
//  MultiSelectViewController.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 18.03.2021.
//

import UIKit

// This doesnt work yet..
class MultiSelectViewController: CompositionalCollectionViewViewController {
    typealias Datasource = UICollectionViewDiffableDataSource<Int, SelectableItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, SelectableItem>
    
    private var datasource: Datasource!
    
    private var isMultiSelecting = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        configureDatasource()
    }
    
    private func setupView() {
        collectionView.register(cellFromNib: SelectableCell.self)
        //collectionView.allowsMultipleSelection = true
        collectionView.delegate = self
        title = "Multi select"
        
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    private func configureDatasource() {
        datasource = Datasource(collectionView: collectionView, cellProvider: cell(collectionView:indexPath:item:))
        
        datasource.apply(snapshot(), animatingDifferences: false)
    }
    
    private func snapshot() -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        
        let items = Array(repeatingExpression: SelectableItem(), count: 50)
        snapshot.appendItems(items)
        
        return snapshot
    }
    
    private func cell(collectionView: UICollectionView, indexPath: IndexPath, item: SelectableItem) -> UICollectionViewCell {
        let cell: SelectableCell = collectionView.dequeue(for: indexPath)
        cell.configure(with: item)
        return cell
    }
    
    override func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .uniform(size: 2)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        isMultiSelecting = editing
    }
    
}

extension MultiSelectViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        datasource.itemIdentifier(for: indexPath)?.isSelected = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        datasource.itemIdentifier(for: indexPath)?.isSelected = false
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        // Returning `true` automatically sets `collectionView.allowsMultipleSelection`
        // to `true`. The app sets it to `false` after the user taps the Done button.
        return isMultiSelecting
    }

    func collectionView(_ collectionView: UICollectionView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
        // Replace the Select button with Done, and put the
        // collection view into editing mode.
        setEditing(true, animated: true)
    }

    func collectionViewDidEndMultipleSelectionInteraction(_ collectionView: UICollectionView) {
        
    }
}
