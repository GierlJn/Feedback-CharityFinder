//
//  FBButton.swift
//  FeedBack2
//
//  Created by Julian Gierl on 30.09.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

final class FBButton: UIButton{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.applyShadow()
    }
    
    convenience init(title: String){
        self.init(frame: .zero)
        setTitle(title, for: .normal)
        configure()
    }
    
    private func configure(){
        backgroundColor = UIColor.headerButtonGradientStart
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 7
        titleLabel?.font = .systemFont(ofSize: 20)
    }
}

