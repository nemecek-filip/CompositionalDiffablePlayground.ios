//
//  UpdatedInfoView.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 06/01/2021.
//

import UIKit

class UpdatedInfoView: UICollectionReusableView {
    
    private var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.text = "Updated"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemGreen
        layer.cornerRadius = 5
        layer.shadowRadius = 0.5
        
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            heightAnchor.constraint(equalToConstant: 25),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
