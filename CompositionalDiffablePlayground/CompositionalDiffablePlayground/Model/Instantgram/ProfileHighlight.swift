//
//  ProfileHighlight.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 16/01/2021.
//

import UIKit

struct ProfileHighlight: Hashable {
    let id = UUID()
    let image: UIImage
}

extension ProfileHighlight {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension ProfileHighlight {
    static var demoHighlights: [ProfileHighlight] {
        let imageNames = (1...7).map({ "flower\($0)" })
        
        return imageNames.map({ ProfileHighlight(image: UIImage(named: $0)!) })
    }
}
