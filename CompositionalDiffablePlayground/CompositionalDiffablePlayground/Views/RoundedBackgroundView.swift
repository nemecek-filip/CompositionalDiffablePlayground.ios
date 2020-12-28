//
//  RoundedBackgroundView.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 28/12/2020.
//

import UIKit

class RoundedBackgroundView: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 15
        backgroundColor = .secondarySystemFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
