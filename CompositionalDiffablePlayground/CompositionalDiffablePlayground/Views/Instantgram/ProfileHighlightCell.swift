//
//  ProfileHighlightCell.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 16/01/2021.
//

import UIKit

class ProfileHighlightCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
        
        imageView.contentMode = .scaleAspectFill
        contentView.backgroundColor = .clear
        contentView.layer.borderColor = UIColor.secondaryLabel.cgColor
        contentView.layer.borderWidth = 1
    }
    
    func configure(with highlight: ProfileHighlight) {
        imageView.image = highlight.image
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layer.cornerRadius = contentView.bounds.height/2
        imageView.layoutIfNeeded()
        imageView.layer.cornerRadius = imageView.bounds.height/2
    }
    
}
