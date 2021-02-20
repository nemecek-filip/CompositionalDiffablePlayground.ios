//
//  PhotoSummaryCell.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 20.02.2021.
//

import UIKit

class PhotoSummaryCell: UICollectionViewCell, CellFromNib {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var moreButton: UIButton!
    @IBOutlet var topGradientView: TopGradientView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.clipsToBounds = true
        
        dayLabel.text = Calendar.current.weekdaySymbols.randomElement()!
        
        dayLabel.alpha = 0
        moreButton.alpha = 0
        topGradientView.alpha = 0
    }
    
    func configure(with image: UIImage) {
        imageView.image = image
    }
    
    func configure(forMode mode: PhotosViewController.Mode) {
        UIView.animate(withDuration: 0.2) {
            switch mode {
            case .allPhotos:
                self.configureForAllPhotos()
            case .monthSummary:
                self.configureForSummary()
            }
        }
    }
    
    private func configureForAllPhotos() {
        dayLabel.alpha = 0
        moreButton.alpha = 0
        topGradientView.alpha = 0
        contentView.layer.cornerRadius = 0
    }
    
    private func configureForSummary() {
        dayLabel.alpha = 1
        moreButton.alpha = 1
        topGradientView.alpha = 1
        contentView.layer.cornerRadius = 16
    }

}
