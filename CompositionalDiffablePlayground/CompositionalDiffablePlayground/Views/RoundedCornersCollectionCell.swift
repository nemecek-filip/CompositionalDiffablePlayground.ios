//
//  RoundedCornersCollectionCell.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 15/11/2020.
//

import UIKit

class RoundedCornersCollectionCell: UICollectionViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layer.cornerRadius = 10
    }
}
