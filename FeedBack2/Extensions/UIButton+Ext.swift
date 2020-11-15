//
//  UIButton+Ext.swift
//  FeedBack
//
//  Created by Julian Gierl on 15.11.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

extension UIButton {
    func applyGradient(colors: [CGColor], radius: CGFloat?) {
            self.backgroundColor = nil
            self.layoutIfNeeded()
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = colors
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
            gradientLayer.frame = self.bounds
            if let radius = radius {
            gradientLayer.cornerRadius = radius
                }

            gradientLayer.shadowColor = UIColor.darkGray.cgColor
            gradientLayer.shadowOffset = CGSize(width: 0, height: 2.5)
            gradientLayer.shadowRadius = 1.0
            gradientLayer.shadowOpacity = 0.2
            gradientLayer.masksToBounds = false

            self.layer.insertSublayer(gradientLayer, at: 0)
            self.contentVerticalAlignment = .center
        }
}

