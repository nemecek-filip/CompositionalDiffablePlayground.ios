//
//  ProfileHeaderCell.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 16/01/2021.
//

import UIKit

class ProfileHeaderCell: UICollectionViewCell {
    
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var accountTypeLabel: UILabel!
    
    @IBOutlet var numberOfPostsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarImageView.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        avatarImageView.layer.borderWidth = 1
    }
    
    func configure(with data: ProfileHeaderData) {
        nameLabel.text = data.name
        accountTypeLabel.text = data.accountType
        numberOfPostsLabel.text = String(data.postCount)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height/2
    }
    
}
