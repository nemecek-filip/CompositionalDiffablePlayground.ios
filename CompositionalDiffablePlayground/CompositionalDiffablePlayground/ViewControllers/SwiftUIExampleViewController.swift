//
//  SwiftUIExampleViewController.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 23.06.2022.
//

import Foundation
import UIKit
import SwiftUI
import SafariServices

@available(iOS 16, *)
class SwiftUIExampleViewController: CompositionalCollectionViewViewController {
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    typealias Datasource = UICollectionViewDiffableDataSource<Section, Item>
    
    enum Section: Hashable {
        case news
    }
    
    enum Item: Hashable {
        case news(AppNewsDTO)
    }
    
    private var appNewsResults: AppNewsResultsDTO? {
        didSet {
            datasource.apply(snapshot(), animatingDifferences: true)
        }
    }
    
    var datasource: Datasource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        configureDatasource()
        
        loadData()
    }
    
    private func loadData() {
        SimpleNetworkHelper.shared.getAppNews { results in
            self.appNewsResults = results
        }
    }
    
    private func setupView() {
        title = "SwiftUI Cells"
        
        collectionView.register(cellFromNib: IndieAppNewsCell.self)
        collectionView.contentInset.top = 15
        collectionView.delegate = self
    }
    
    let appNewsRegistration = UICollectionView.CellRegistration<UICollectionViewCell, AppNewsDTO> {
        cell, indexPath, item in
        
        cell.contentConfiguration = UIHostingConfiguration {
            VStack(alignment: .leading) {
                AsyncImage(
                    url: URL(string: item.thumbnailUrl),
                    content: { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerSize: CGSize.init(width: 10, height: 10)))
                    },
                    placeholder: {
                        ProgressView()
                    }
                )
                
                Text(item.title)
                    .font(.title2)
                    .bold()
                    .padding(.bottom, 20)
            }
        }
    }
    
    private func configureDatasource() {
        datasource = Datasource(collectionView: collectionView, cellProvider: { [unowned self] collectionView, indexPath, item in
            switch item {
            case .news(let appNews):
                return collectionView.dequeueConfiguredReusableCell(using: appNewsRegistration, for: indexPath, item: appNews)
            }
        })
        
        datasource.apply(snapshot(), animatingDifferences: false)
    }
    
    private func snapshot() -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([.news])
        
        if let appNewsResults = appNewsResults {
            snapshot.appendItems(appNewsResults.results.map(Item.news), toSection: .news)
        }
        
        return snapshot
    }
    
    override func createLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.showsSeparators = false
        
        
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
}

@available(iOS 16, *)
extension SwiftUIExampleViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = datasource.itemIdentifier(for: indexPath) else { return }
        
        switch item {
        case .news(let news):
            if let url = URL(string: news.detailUrl) {
                let svc = SFSafariViewController(url: url)
                present(svc, animated: true, completion: nil)
            }
        }
    }
}
