//
//  SelectableCell.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 18.03.2021.
//

import UIKit

class SelectableCell: UICollectionViewCell, CellFromNib {
    @IBOutlet var selectedImageView: UIImageView!
    
    override var isSelected: Bool {
        didSet {
            setSelected(isSelected)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.borderColor = UIColor.systemBlue.cgColor
        selectedImageView.isHidden = true
        contentView.layer.cornerRadius = 10
    }
    
    func configure(with item: SelectableItem) {
        contentView.backgroundColor = item.color
        setSelected(item.isSelected)
    }
    
    private func setSelected(_ isSelected: Bool) {
        contentView.layer.borderWidth = isSelected ? 4 : 0
        selectedImageView.isHidden = !isSelected
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        setSelected(false)
    }

}
