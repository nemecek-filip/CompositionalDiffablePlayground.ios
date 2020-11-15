//
//  ViewController.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 13/11/2020.
//

import UIKit

typealias ColorsSnapshot = NSDiffableDataSourceSnapshot<Int, UIColor>

class ViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, SectionItem>
    
    enum SectionItem: Hashable {
        case layoutType(layout: LayoutType)
        case color(color: UIColor)
    }
    
    private let layoutTypes: [SectionItem] = [
        .layoutType(layout: LayoutType(name: "List Layout", color: .random())),
        .layoutType(layout: LayoutType(name: "Simple Grid Layout", color: .random()))
    ]
    
    var datasource: UICollectionViewDiffableDataSource<Int, SectionItem>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        configureDatasource()
        generateData(animated: false)
    }
    
    private func setupView() {
        collectionView.register(LayoutTypeCell.nib, forCellWithReuseIdentifier: LayoutTypeCell.reuseIdentifier)
        collectionView.setCollectionViewLayout(createLayout(), animated: false)
        collectionView.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .plain, target: self, action: #selector(regenerateTapped))
    }
    
    @objc func regenerateTapped() {
        generateData(animated: true)
    }
    
    private func configureDatasource() {
        datasource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            
            switch item {
            case .color(let color):
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.reuseIdentifier, for: indexPath)
                cell.contentView.backgroundColor = color
                return cell
                
            case .layoutType(let layout):
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LayoutTypeCell.reuseIdentifier, for: indexPath) as! LayoutTypeCell
                cell.configure(with: layout)
                return cell
            }
        })
    }
    
    private func generateData(animated: Bool) {
        var snapshot = Snapshot()
        
        var sections = [Int]()
        
        for i in 0...Int.random(in: 4...7) {
            sections.append(i)
        }
        
        snapshot.appendSections(sections)
        
        snapshot.appendItems(layoutTypes, toSection: sections.first)
        
        for section in sections.dropFirst() {
            var items = [SectionItem]()
            
            for _ in 4...Int.random(in: 7...12) {
                items.append(.color(color: .random()))
            }
            
            // Probably not a good use of a map
            //let items2: [UIColor] = (4...Int.random(in: 7...12)).map({ _ in UIColor.random() })
            
            snapshot.appendItems(items, toSection: section)
        }
        
        datasource.apply(snapshot, animatingDifferences: animated)
    }
    
    private func topSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem.withEntireSize()
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.32))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        return section
    }
    
    private func smallItemsSection(itemCount: Int) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(0.5))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets.uniform(size: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.3))
        
        let maxVisibleCount = 8
        
        let fractionalWidthToFillSpace: CGFloat
        if itemCount < maxVisibleCount {
            let half = (Double(itemCount) / 2)
            fractionalWidthToFillSpace = CGFloat(1 / half.rounded(.up))
        } else {
            fractionalWidthToFillSpace = 0.25
        }
        
        let verticalSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fractionalWidthToFillSpace), heightDimension: .fractionalHeight(1.0))
        
        let groupVertical = NSCollectionLayoutGroup.vertical(layoutSize: verticalSize, subitem: item, count: 2)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [groupVertical])
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        
        return section
    }
    
    private func mediumSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets.uniform(size: 10)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            if sectionIndex == 0 {
                return self.topSection()
            } else if 1...3 ~= sectionIndex {
                return self.mediumSection()
            } else {
                let itemCount = self.datasource.collectionView(self.collectionView, numberOfItemsInSection: sectionIndex)
                return self.smallItemsSection(itemCount: itemCount)
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        
        return layout
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section == 0 else { return }
        
        let vc: UIViewController
        
        if indexPath.row == 0 {
            vc = ListViewController()
        } else {
            vc = SimpleGridViewController()
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

