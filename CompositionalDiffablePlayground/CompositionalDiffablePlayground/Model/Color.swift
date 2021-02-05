//
//  Color.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 05.02.2021.
//

import UIKit

struct Color {
    let id = UUID()
    let color = UIColor.random()
}

extension Color: Hashable, Equatable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: Color, rhs: Color) -> Bool {
        return lhs.id == rhs.id
    }
}
