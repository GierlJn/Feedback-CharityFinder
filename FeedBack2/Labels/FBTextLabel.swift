//
//  FBTextLabel.swift
//  FeedBack2
//
//  Created by Julian Gierl on 10.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

class FBTextLabel: UILabel{
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        textColor = .label
        if(DeviceType.isiPad){
            font = UIFont.preferredFont(forTextStyle: .body)
        }else{
            font = UIFont.preferredFont(forTextStyle: .footnote)
        }
        
        isOpaque = false
        numberOfLines = 0
        textAlignment = .left
        lineBreakMode = .byWordWrapping
        backgroundColor = .init(white: 0, alpha: 0)
    }
}
