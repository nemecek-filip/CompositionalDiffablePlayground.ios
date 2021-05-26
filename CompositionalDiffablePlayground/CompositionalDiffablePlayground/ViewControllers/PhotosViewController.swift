//
//  PhotosViewController.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 20.02.2021.
//

import UIKit

class PhotosViewController: CompositionalCollectionViewViewController {
    
    typealias Datasource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    private lazy var modeSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl()
        control.backgroundColor = .secondarySystemBackground
        control.translatesAutoresizingMaskIntoConstraints = false
        control.insertSegment(withTitle: "Months", at: 0, animated: false)
        control.insertSegment(withTitle: "All Photos", at: 1, animated: false)
        control.selectedSegmentIndex = 1
        return control
    }()
    
    enum Section: Hashable {
        case collection(header: String)
        
        var title: String {
            switch self {
            case .collection(let header):
                return header
            }
        }
    }
    
    enum Item: Hashable {
        case largePhoto(Photo)
        case photo(Photo)
    }
    
    enum Mode: Int {
        case monthSummary
        case allPhotos
    }
    
    private var datasource: Datasource!
    
    private var mode = Mode.allPhotos
    
    private let photos1 = Photo.demoPhotos.prefix(4)
    private let photos2 = Photo.demoPhotos.suffix(4)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Photos"
        
        setupView()
        
        collectionView.register(cell: ImageViewCell.self)
        collectionView.register(cellFromNib: PhotoSummaryCell.self)
        collectionView.register(header: SimpleHeaderView.self)
        
        configureDatasource()
    }
    
    @objc func modeSegmentedControlValueChanged(sender: UISegmentedControl) {
        mode = Mode(rawValue: sender.selectedSegmentIndex)!
        datasource.apply(snapshot(), animatingDifferences: true)
        let summaryCells = collectionView.visibleCells.compactMap({ $0 as? PhotoSummaryCell })
        summaryCells.forEach { (cell) in
            cell.configure(forMode: mode)
        }
    }
    
    private func configureDatasource() {
        datasource = Datasource(collectionView: collectionView, cellProvider: { [unowned self] collectionView, indexPath, item in
            return self.cell(collectionView: collectionView, indexPath: indexPath, item: item)
        })
        
        datasource.supplementaryViewProvider = { [unowned self] collectionView, kind, indexPath in
            return self.supplementary(collectionView: collectionView, kind: kind, indexPath: indexPath)
        }
        
        datasource.apply(snapshot(), animatingDifferences: false)
    }
    
    private func snapshot() -> Snapshot {
        var snapshot = Snapshot()
        
        let julyCollection = Section.collection(header: "July 2020")
        let augustCollection = Section.collection(header: "August 2020")
        
        snapshot.appendSections([julyCollection, augustCollection])
        
        snapshot.appendItems([.largePhoto(photos1.first!)], toSection: julyCollection)
        snapshot.appendItems([.largePhoto(photos2.first!)], toSection: augustCollection)
        
        if mode == .allPhotos {
            snapshot.appendItems(photos1.dropFirst().map { Item.photo($0) }, toSection: julyCollection)
            snapshot.appendItems(photos2.dropFirst().map { Item.photo($0) }, toSection: augustCollection)
        }
        
        return snapshot
    }
    
    private func cell(collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell {
        switch item {
        case .photo(let photo):
            let cell: ImageViewCell = collectionView.dequeue(for: indexPath)
            cell.configure(with: photo.image)
            return cell
        case .largePhoto(let photo):
            let cell: PhotoSummaryCell = collectionView.dequeue(for: indexPath)
            cell.configure(with: photo.image)
            cell.configure(forMode: mode)
            return cell
        }
    }
    
    private func supplementary(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView {
        let header: SimpleHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SimpleHeaderView.reuseIdentifier, for: indexPath) as! SimpleHeaderView
        
        let section = datasource.snapshot().sectionIdentifiers[indexPath.section]
        
        header.configure(with: section.title)
        
        return header
    }
    
    private func layoutSection(forIndex index: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        
        let photoItemHeight: NSCollectionLayoutDimension
        
        switch mode {
        case .allPhotos:
            photoItemHeight = .fractionalWidth(1.0)
        case .monthSummary:
            photoItemHeight = .fractionalWidth(0.8)
        }
        
        let photoItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: photoItemHeight))
        
        if mode == .monthSummary {
            photoItem.contentInsets = .init(horizontal: 16, vertical: 2)
        } else {
            photoItem.contentInsets = .init(horizontal: 2, vertical: 2)
        }
        
        let smallPhotoItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalWidth(1/3)))
        smallPhotoItem.contentInsets = .init(horizontal: 2, vertical: 0)
        
        let photoGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1/3)), subitem: smallPhotoItem, count: 3)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(500)), subitems: [photoItem, photoGroup])
        
        let section = NSCollectionLayoutSection(group: group)
        
        if mode == .monthSummary {
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            
            section.boundarySupplementaryItems = [headerElement]
        }
        
        return section
    }
    
    override func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [unowned self] index, env in
            return self.layoutSection(forIndex: index, environment: env)
        }
    }
    
    private func setupView() {
        modeSegmentedControl.addTarget(self, action: #selector(modeSegmentedControlValueChanged(sender:)), for: .valueChanged)
        
        let safeArea = view.safeAreaLayoutGuide
        
        let bottomGradient = BottomGradientView()
        bottomGradient.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(bottomGradient)
        view.addSubview(modeSegmentedControl)
        
        NSLayoutConstraint.activate([
            modeSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            modeSegmentedControl.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -5),
            modeSegmentedControl.widthAnchor.constraint(equalToConstant: 240),
            view.bottomAnchor.constraint(equalTo: bottomGradient.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: bottomGradient.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: bottomGradient.trailingAnchor),
            bottomGradient.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        collectionView.contentInset.bottom = 50
    }
}
