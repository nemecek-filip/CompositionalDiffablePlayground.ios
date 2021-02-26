//
//  ArticleCell.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 26.02.2021.
//

import UIKit

class ArticleCell: UICollectionViewCell, CellFromNib {
    @IBOutlet var titleLabel: UILabel!
    
    override var isHighlighted: Bool {
        didSet {
            contentView.alpha = isHighlighted ? 0.8 : 1.0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 20
        contentView.backgroundColor = .secondarySystemBackground
    }
    
    func configure(with article: ArticleDTO) {
        titleLabel.text = article.title
    }

}
