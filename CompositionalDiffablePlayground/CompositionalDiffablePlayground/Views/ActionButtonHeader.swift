//
//  ActionButtonHeader.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 05.02.2021.
//

import UIKit

class ActionButtonHeader: SimpleHeaderView {
    private lazy var actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    var buttonAction: Action?
    
    func configure(with title: String, buttonTitle: String) {
        super.configure(with: title)
        
        actionButton.setTitle(buttonTitle, for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    @objc func buttonTapped(sender: Any) {
        buttonAction?()
    }
    
    private func setupView() {
        addSubview(actionButton)
        
        actionButton.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            centerYAnchor.constraint(equalTo: actionButton.centerYAnchor),
            trailingAnchor.constraint(equalTo: actionButton.trailingAnchor, constant: 15)
        ])
    }
}
