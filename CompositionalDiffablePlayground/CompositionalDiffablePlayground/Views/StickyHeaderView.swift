//
//  StickyHeaderView.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 09.02.2021.
//

import UIKit

class StickyHeaderView: SimpleHeaderView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .systemOrange
    }
}
