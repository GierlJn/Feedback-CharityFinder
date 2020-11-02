//
//  OwnScrollView.swift
//  FeedBack2
//
//  Created by Julian Gierl on 02.11.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

class OwnContentView: UIView{
    
    override func layoutSubviews() {
        //print(bounds.height)
        let sumHeight = subviews.map({$0.frame.size.height}).reduce(0, {x, y in x + y})
        //print(sumHeight)
    }
    

    
}
