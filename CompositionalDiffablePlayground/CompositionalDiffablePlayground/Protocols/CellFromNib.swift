//
//  CellFromNib.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 28/11/2020.
//

import UIKit

protocol CellFromNib: UICollectionViewCell {
    
}

extension CellFromNib {
    static var nib: UINib {
        return UINib(nibName: String(describing: Self.self), bundle: nil)
    }
}
