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

extension ComplexExample {
    static let available: [ComplexExample] = [
        ComplexExample(name: "Instagram profile example", type: .instantgram, color: .random()),
        ComplexExample(name: "Photos with layout switch", type: .photos, color: .random()),
        // The API is no longer available
        //ComplexExample(name: "Jokes API with shimmer", type: .jokes, color: .random()),
        ComplexExample(name: "Badges example", type: .badges, color: .random()),
    ]
}
