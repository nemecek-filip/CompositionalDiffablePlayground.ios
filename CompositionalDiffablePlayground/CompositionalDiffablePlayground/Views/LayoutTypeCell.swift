//
//  LayoutTypeCell.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 15/11/2020.
//

import UIKit

class LayoutTypeCell: RoundedCornersCollectionCell {
    @IBOutlet var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    func configure(with layout: LayoutType) {
        titleLabel.text = layout.name
        contentView.backgroundColor = layout.color
    }

}
