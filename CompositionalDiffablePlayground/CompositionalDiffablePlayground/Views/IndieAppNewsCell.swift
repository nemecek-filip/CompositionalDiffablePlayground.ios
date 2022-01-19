//
//  IndieAppNewsCell.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 19.01.2022.
//

import UIKit

class IndieAppNewsCell: UICollectionViewCell, CellFromNib {
    @IBOutlet var titleLabel: UILabel!
    
    
    private var shimmerLayer: CALayer?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        clipsToBounds = true
        layer.cornerRadius = 16
        
        titleLabel.text = nil
    }
    
    func configure(with appNews: AppNewsDTO) {
        titleLabel.text = appNews.title
    }
    
    
    func showLoading() {
        let light = UIColor(white: 0, alpha: 0.1).cgColor

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
        
        titleLabel.text = nil
        
        shimmerLayer?.removeFromSuperlayer()
    }

}
