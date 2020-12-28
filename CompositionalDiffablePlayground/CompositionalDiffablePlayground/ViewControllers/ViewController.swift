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
        case layoutType(LayoutType)
        case color(UIColor)
        case example(ComplexExample)
    }
    
    private let layoutTypes: [SectionItem] = [
        .layoutType(LayoutType(name: "List Layout", color: .random(), layout: .list)),
        .layoutType(LayoutType(name: "Simple Grid Layout", color: .random(), layout: .simpleGrid)),
        .layoutType(LayoutType(name: "Lazy Grid Layout", color: .random(), layout: .lazyGrid)),
        .layoutType(LayoutType(name: "Background decoration", color: .random(), layout: .insetList)),
        .layoutType(LayoutType(name: "System List Layout", color: .random(), layout: .systemList))
    ]
    
    private let examples: [SectionItem] = [
        .example(ComplexExample(name: "Jokes API with shimmer", type: .jokes, color: .random()))
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
        collectionView.register(SimpleHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SimpleHeaderView.reuseIdentifier)
        collectionView.register(SimpleFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: SimpleFooterView.reuseIdentifier)
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
                
            case .example(let example):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LayoutTypeCell.reuseIdentifier, for: indexPath) as! LayoutTypeCell
                cell.configure(with: example)
                return cell
            }
        })
        
        datasource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            if kind == UICollectionView.elementKindSectionFooter {
                let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: SimpleFooterView.reuseIdentifier, for: indexPath) as! SimpleFooterView
                
                footer.configure(with: "Thanks for checking out this example!")
                
                return footer
            }
            
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SimpleHeaderView.reuseIdentifier, for: indexPath) as! SimpleHeaderView
            
            if indexPath.section == 0 {
                header.configure(with: "Example layouts")
            } else if indexPath.section == 1 {
                header.configure(with: "More complex examples")
            } else {
                header.configure(with: "Responsive section items")
            }
            
            return header
        }
    }
    
    private func generateData(animated: Bool) {
        var snapshot = Snapshot()
        
        var sections = [Int]()
        
        for i in 0...Int.random(in: 4...7) {
            sections.append(i)
        }
        
        snapshot.appendSections(sections)
        
        snapshot.appendItems(layoutTypes, toSection: sections.first)
        snapshot.appendItems(examples, toSection: sections[1])
        
        for section in sections.suffix(from: 2) {
            var items = [SectionItem]()
            
            for _ in 4...Int.random(in: 5...9) {
                items.append(.color(.random()))
            }
            
            // Probably not a good use of a map
            //let items2: [UIColor] = (4...Int.random(in: 7...12)).map({ _ in UIColor.random() })
            
            snapshot.appendItems(items, toSection: section)
        }
        
        datasource.apply(snapshot, animatingDifferences: animated)
    }
    
    private func topSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem.withEntireSize()
        item.contentInsets = NSDirectionalEdgeInsets(horizontal: 10, vertical: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.32))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        addStandardHeader(toSection: section)
        
        return section
    }
    
    private func smallItemsSection(itemCount: Int, addFooter: Bool = false) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(0.5))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets.uniform(size: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.3))
        
        let fractionalWidthToFillSpace = calculateResponsiveFractionalWidth(itemCount: itemCount, maxVisibleCount: 8)
        
        let verticalSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fractionalWidthToFillSpace), heightDimension: .fractionalHeight(1.0))
        
        let groupVertical = NSCollectionLayoutGroup.vertical(layoutSize: verticalSize, subitem: item, count: 2)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [groupVertical])
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        
        addStandardHeader(toSection: section)
        
        if addFooter {
            let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(35))
            let footerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
            section.boundarySupplementaryItems += [footerElement]
        }
        
        return section
    }
    
    private func addStandardHeader(toSection section: NSCollectionLayoutSection) {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [headerElement]
    }
    
    private func calculateResponsiveFractionalWidth(itemCount: Int, maxVisibleCount: Int) -> CGFloat {
        let fractionalWidthToFillSpace: CGFloat
        if itemCount < maxVisibleCount {
            let half = (Double(itemCount) / 2)
            fractionalWidthToFillSpace = CGFloat(1 / half.rounded(.up))
        } else {
            fractionalWidthToFillSpace = 0.25
        }
        
        return fractionalWidthToFillSpace
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
            if 0...1 ~= sectionIndex {
                return self.topSection()
            } else if 2...3 ~= sectionIndex {
                return self.mediumSection()
            } else {
                let snapshot = self.datasource.snapshot()
                let itemCount = snapshot.numberOfItems(inSection: sectionIndex)
                let addFooter = snapshot.numberOfSections == sectionIndex + 1
                return self.smallItemsSection(itemCount: itemCount, addFooter: addFooter)
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        
        return layout
    }
    
    private func showLayoutNotAvailable() {
        let ac = UIAlertController(title: nil, message: "This layout is available only for iOS 14", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(ac, animated: true, completion: nil)
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard 0...1 ~= indexPath.section else { return }
        guard let item = datasource.itemIdentifier(for: indexPath) else { return }
        
        let vc: UIViewController?
        
        switch item {
        case .layoutType(let layoutType):
            
            switch layoutType.layout {
            case .list:
                vc = ListViewController()
            case .simpleGrid:
                vc = SimpleGridViewController()
            case .lazyGrid:
                vc = LazyGridViewController()
            case .systemList:
                if #available(iOS 14.0, *) {
                    vc = SystemListViewController()
                } else {
                    vc = nil
                    showLayoutNotAvailable()
                }
            case .insetList:
                vc = BackgroundDecorationViewController()
            }
            
            
        case .example(let example):
            switch example.type {
            case .jokes:
                vc = JokesViewController()
            }
        default:
            vc = nil
        }
        
        guard let viewController = vc else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
}

