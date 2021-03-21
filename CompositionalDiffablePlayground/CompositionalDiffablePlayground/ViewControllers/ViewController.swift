//
//  ViewController.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 13/11/2020.
//

import UIKit
import Combine
import SafariServices

typealias ColorsSnapshot = NSDiffableDataSourceSnapshot<Int, UIColor>

class ViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    
    typealias Datasource = UICollectionViewDiffableDataSource<Int, SectionItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, SectionItem>
    
    private var cancellables = Set<AnyCancellable>()
    
    enum SectionItem: Hashable {
        case layoutType(LayoutType)
        case color(UIColor)
        case example(ComplexExample)
        case article(ArticleDTO)
    }
    
    private var datasource: Datasource!
    
    private var articles: [ArticleDTO]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Modern Collection Views"
        
        setupView()
        configureDatasource()
        generateData(animated: false)
        
        setupNotifications()
        
        FeedsService.shared.loadArticles()
    }
    
    private func setupView() {
        collectionView.register(LayoutTypeCell.nib, forCellWithReuseIdentifier: LayoutTypeCell.reuseIdentifier)
        collectionView.register(cellFromNib: ArticleCell.self)
        collectionView.register(SimpleHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SimpleHeaderView.reuseIdentifier)
        collectionView.register(SimpleFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: SimpleFooterView.reuseIdentifier)
        collectionView.setCollectionViewLayout(createLayout(), animated: false)
        collectionView.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .plain, target: self, action: #selector(regenerateTapped))
    }
    
    @objc func regenerateTapped() {
        generateData(animated: true)
    }
    
    private func setupNotifications() {
        FeedsService.shared.$articles
            .receive(on: RunLoop.main)
            .sink { [weak self] (articles) in
                self?.articles = articles
                self?.generateData(animated: true)
            }
            .store(in: &cancellables)
    }
    
    // MARK: configureDatasource
    private func configureDatasource() {
        datasource = Datasource(collectionView: collectionView, cellProvider: cell(collectionView:indexPath:item:))
        
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
            } else if indexPath.section == 2 {
                header.configure(with: "iOS Feeds")
            } else {
                header.configure(with: "Responsive section items")
            }
            
            return header
        }
    }
    
    private func cell(collectionView: UICollectionView, indexPath: IndexPath, item: SectionItem) -> UICollectionViewCell {
        switch item {
        case .color(let color):
            let cell: ColorCell = collectionView.dequeue(for: indexPath)
            cell.contentView.backgroundColor = color
            return cell
            
        case .article(let data):
            let cell: ArticleCell = collectionView.dequeue(for: indexPath)
            cell.configure(with: data)
            return cell
            
        case .layoutType(let layout):
            let cell: LayoutTypeCell = collectionView.dequeue(for: indexPath)
            cell.configure(with: layout)
            return cell
            
        case .example(let example):
            let cell: LayoutTypeCell = collectionView.dequeue(for: indexPath)
            cell.configure(with: example)
            return cell
        }
    }
    
    private func generateData(animated: Bool) {
        var snapshot = Snapshot()
        
        var sections = [Int]()
        
        for i in 0...Int.random(in: 4...7) {
            sections.append(i)
        }
        
        snapshot.appendSections(sections)
        
        snapshot.appendItems(LayoutType.available.map(SectionItem.layoutType), toSection: sections.first)
        snapshot.appendItems(ComplexExample.available.map(SectionItem.example), toSection: sections[1])
        
        if let articles = articles {
            let shuffled = articles.shuffled()
            snapshot.appendItems(shuffled.prefix(8).map(SectionItem.article), toSection: 2)
        }
        
        for section in sections.suffix(from: 3) {
            let items = Array.init(repeatingExpression: SectionItem.color(.random()), count: Int.random(in: 4...9))
            
            snapshot.appendItems(items, toSection: section)
        }
        
        datasource.apply(snapshot, animatingDifferences: animated)
    }
    
    // MARK: Layout
    private func topSection() -> NSCollectionLayoutSection {
        let item: NSCollectionLayoutItem
        
        if UIDevice.current.isIpad {
            item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0)))
        } else {
            item = NSCollectionLayoutItem.withEntireSize()
        }
        
        item.contentInsets = NSDirectionalEdgeInsets(horizontal: 10, vertical: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(UIDevice.current.isIpad ? 0.2 : 0.32))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = UIDevice.current.isIpad ? .continuous : .groupPagingCentered
        
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
    
    private func mediumSection(addHeader: Bool = false) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(UIDevice.current.isIpad ? 0.25 : 0.5), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets.uniform(size: 10)
        
        let heightDimension: NSCollectionLayoutDimension = UIDevice.current.isIpad ? .fractionalHeight(0.2) : .fractionalWidth(0.5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: heightDimension)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        if addHeader {
            addStandardHeader(toSection: section)
        }
        
        return section
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            if 0...1 ~= sectionIndex {
                return self.topSection()
            } else if 2...3 ~= sectionIndex {
                return self.mediumSection(addHeader: sectionIndex == 2)
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
    
    private func openWebviewFor(article: ArticleDTO) {
        let svc = SFSafariViewController(url: URL(string: article.url)!)
        present(svc, animated: true, completion: nil)
    }
}


// MARK: UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard 0...2 ~= indexPath.section else { return }
        guard let item = datasource.itemIdentifier(for: indexPath) else { return }
        
        let vc: UIViewController?
        
        switch item {
        case .layoutType(let layoutType):
            
            switch layoutType.layout {
            case .list:
                vc = ListViewController()
            case .simpleGrid:
                vc = SimpleGridViewController()
            case .onboarding:
                vc = OnboardingLayoutViewController()
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
            case .stickyHeaders:
                vc = StickyHeadersViewController()
            case .responsiveLayout:
                vc = ResponsiveLayoutViewController()
            }
            
            
        case .example(let example):
            switch example.type {
            case .jokes:
                vc = JokesViewController()
            case .photos:
                vc = PhotosViewController()
            case .badges:
                vc = BadgesViewController()
            case .instantgram:
                vc = UIStoryboard(name: "Instantgram", bundle: nil).instantiateInitialViewController()!
            }
            
        case .article(let data):
            openWebviewFor(article: data)
            vc = nil
        default:
            vc = nil
        }
        
        guard let viewController = vc else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
}

