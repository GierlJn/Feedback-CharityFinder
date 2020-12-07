//
//  FBTitleLabel.swift
//  FeedBack2
//
//  Created by Julian Gierl on 05.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

final class FBTitleLabel: UILabel{
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(textAlignment: NSTextAlignment){
        self.init(frame: .zero)
        self.textAlignment = textAlignment
    }
    
    private func configure(){
        textColor = .textTitleLabel
        if(DeviceType.isiPad){
            font = UIFont.preferredFont(forTextStyle: .title2)
        }else{
            font = UIFont.preferredFont(forTextStyle: .headline)
        }
        
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.6
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }
}
