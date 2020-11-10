//
//  AlertContainerView.swift
//  FeedBack2
//
//  Created by Julian Gierl on 02.11.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

class AlertContainerView: UIView{
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configure() {
        backgroundColor = .systemBackground
        layer.borderWidth = 2
        layer.borderColor = UIColor.standardButton.cgColor
        layer.cornerRadius = 12
        clipsToBounds = true
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        layer.borderColor = UIColor.standardButton.cgColor
    }
    
}

