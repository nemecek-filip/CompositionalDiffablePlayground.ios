//
//  UIColor+Extension.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 13/11/2020.
//

import UIKit

extension UIColor {
    static func random() -> UIColor {
        return UIColor(hue: CGFloat.random(in: 0...359), saturation: 0.7, brightness: 1, alpha: 1)
    }
}
