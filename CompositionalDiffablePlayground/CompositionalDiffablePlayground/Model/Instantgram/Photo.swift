//
//  Photo.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 16/01/2021.
//

import UIKit

struct Photo {
    let id = UUID()
    let image: UIImage
}

extension Photo: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Photo {
    static var demoPhotos: [Photo] {
        let names = (1...8).map({ "photo\($0)" })
        
        return names.map({ Photo(image: UIImage(named: $0)!) })
    }
}
