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
        
        if UIDevice.current.isIpad {
            titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            contentView.backgroundColor = isHighlighted ? originalBackgroundColor.withAlphaComponent(0.8) : originalBackgroundColor.withAlphaComponent(0.6)
            
            UIView.animate(withDuration: 0.1) {
                self.titleLabel.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.9, y: 0.9).concatenating(CGAffineTransform(rotationAngle: -0.04)) : .identity
            }
        }
    }
    
    func configure(with example: ComplexExample) {
        titleLabel.text = example.name
        configure(color: example.color)
    }
    
    func configure(with layout: LayoutType) {
        titleLabel.text = layout.name
        configure(color: layout.color)
    }
    
    private func configure(color: UIColor) {
        originalBackgroundColor = color
        contentView.backgroundColor = originalBackgroundColor.withAlphaComponent(0.8)
        
        
    }

}
