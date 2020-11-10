//
//  FBButton.swift
//  FeedBack2
//
//  Created by Julian Gierl on 30.09.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

class FBButton: UIButton{
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addShadow()
        
    }
    
    convenience init(title: String){
        self.init(frame: .zero)
        setTitle(title, for: .normal)
        configure()
    }
    
    private func configure(){
        backgroundColor = .standardButton
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 7
        titleLabel?.font = .systemFont(ofSize: 20)
        //titleLabel?.textColor = .red
    }
    
    private func addShadow(){
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 6.0)
        layer.shadowRadius = 3
    }
    
}

