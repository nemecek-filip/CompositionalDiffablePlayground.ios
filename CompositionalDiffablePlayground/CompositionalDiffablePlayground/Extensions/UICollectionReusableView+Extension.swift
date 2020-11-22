//
//  UICollectionReusableView+Extension.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 22/11/2020.
//

import UIKit

extension UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

