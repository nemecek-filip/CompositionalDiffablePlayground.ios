//
//  LetterCell.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 12/01/2021.
//

import UIKit

class LetterCell: UICollectionViewCell {
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 42, weight: .semibold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func configure(with letter: Character) {
        label.text = String(letter)
    }
    
    private func setupView() {
        contentView.addSubview(label)
        
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        contentView.layer.cornerRadius = 2
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
}
