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
    @IBOutlet var favoriteButton: UIButton!
    
    private var shimmerLayer: CALayer?
    
    var favoriteAction: Action?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupLabel.text = nil
        punchlineLabel.text = nil
        
        layer.cornerRadius = 20
    }
    
    func configure(withJoke joke: JokeDTO) {
        setupLabel.text = joke.setup
        punchlineLabel.text = joke.punchline
        favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
    }
    
    func configure(with joke: Joke) {
        setupLabel.text = joke.setup
        punchlineLabel.text = joke.punchline
        favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
    }
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        favoriteAction?()
    }
    
    func showLoading() {
        let light = UIColor(white: 0, alpha: 0.1).cgColor
        
        favoriteButton.isHidden = true

        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, light, UIColor.clear.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.525)
        gradient.locations = [0.4, 0.5, 0.6]

        gradient.frame = CGRect(x: -contentView.bounds.width, y: 0, width: contentView.bounds.width * 3, height: contentView.bounds.height)

        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.1, 0.2]
        animation.toValue = [0.8, 0.9, 1.0]

        animation.repeatCount = .infinity
        animation.duration = 1.1
        animation.isRemovedOnCompletion = false

        gradient.add(animation, forKey: "shimmer")
        
        contentView.layer.addSublayer(gradient)
        
        shimmerLayer = gradient
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setupLabel.text = nil
        punchlineLabel.text = nil
        favoriteButton.isHidden = false
        favoriteAction = nil
        
        shimmerLayer?.removeFromSuperlayer()
    }

}
