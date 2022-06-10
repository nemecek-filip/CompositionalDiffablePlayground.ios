//
//  UIColor+Extension.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 13/11/2020.
//

import UIKit

extension UIColor {
    static let safeHue = Array(0...150) + Array(230...359)
    
    static func random() -> UIColor {
        let randomHue = safeHue.randomElement()!
        
        return UIColor(hue: CGFloat(randomHue) / 100, saturation: 0.7, brightness: 1, alpha: 1)
    }
}
