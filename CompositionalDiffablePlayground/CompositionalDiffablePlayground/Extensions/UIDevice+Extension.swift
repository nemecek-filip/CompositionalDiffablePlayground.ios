//
//  UIDevice+Extension.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 10.02.2021.
//

import UIKit

extension UIDevice {
    var isIpad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}
