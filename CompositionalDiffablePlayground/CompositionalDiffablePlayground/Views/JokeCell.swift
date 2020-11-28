//
//  JokeCell.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 28/11/2020.
//

import UIKit

class JokeCell: UICollectionViewCell, CellFromNib {
    @IBOutlet var setupLabel: UILabel!
    @IBOutlet var punchlineLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupLabel.text = nil
        punchlineLabel.text = nil
        
        layer.cornerRadius = 20
    }
    
    func configure(withJoke joke: JokeDTO) {
        setupLabel.text = joke.setup
        punchlineLabel.text = joke.punchline
    }

}
