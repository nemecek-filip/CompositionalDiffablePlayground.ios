//
//  ComplexExample.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 07/12/2020.
//

import UIKit

struct ComplexExample: Hashable {
    let name: String
    let type: ExampleType
    let color: UIColor
    
    enum ExampleType {
        case jokes
        case badges
        case instantgram
        case photos
    }
}
