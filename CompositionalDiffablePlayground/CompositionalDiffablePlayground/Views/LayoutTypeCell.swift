//
//  LayoutTypeCell.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 15/11/2020.
//

import UIKit

class LayoutTypeCell: RoundedCornersCollectionCell, CellFromNib {
    @IBOutlet var titleLabel: UILabel!
    
    private var originalBackgroundColor: UIColor!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override var isHighlighted: Bool {
        didSet {
            contentView.backgroundColor = isHighlighted ? originalBackgroundColor.withAlphaComponent(0.8) : originalBackgroundColor.withAlphaComponent(0.6)
            
            UIView.animate(withDuration: 0.1) {
                self.titleLabel.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.9, y: 0.9).concatenating(CGAffineTransform(rotationAngle: -0.04)) : .identity
            }
        }
    }
    
    
    
    func configure(with layout: LayoutType) {
        titleLabel.text = layout.name
        originalBackgroundColor = layout.color
        contentView.backgroundColor = originalBackgroundColor.withAlphaComponent(0.6)
    }

}
