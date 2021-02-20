//
//  TopGradientView.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 20.02.2021.
//

import UIKit

class TopGradientView: UIView {
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        (layer as! CAGradientLayer).colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
    }
}

class BottomGradientView: UIView {
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        (layer as! CAGradientLayer).colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
    }
}
