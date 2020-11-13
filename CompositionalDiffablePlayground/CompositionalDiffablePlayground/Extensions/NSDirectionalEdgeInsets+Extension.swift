//
//  NSDirectionalEdgeInsets+Extension.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 13/11/2020.
//

import UIKit

extension NSDirectionalEdgeInsets {
    static func uniform(size: CGFloat) -> NSDirectionalEdgeInsets {
        return NSDirectionalEdgeInsets(top: size, leading: size, bottom: size, trailing: size)
    }
}
