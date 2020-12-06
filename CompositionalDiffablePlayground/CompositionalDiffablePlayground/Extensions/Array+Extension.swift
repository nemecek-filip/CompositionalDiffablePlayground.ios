//
//  Array+Extension.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 06/12/2020.
//

import Foundation

extension Array {
    init(repeatingExpression expression: @autoclosure (() -> Element), count: Int) {
        var temp = [Element]()
        for _ in 0..<count {
            temp.append(expression())
        }
        self = temp
    }
}
