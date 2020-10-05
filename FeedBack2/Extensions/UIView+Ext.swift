//
//  UIView+Extensions.swift
//  FeedBack2
//
//  Created by Julian Gierl on 05.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit
import SnapKit

extension UIView{
    func pinToEdges(of superView: UIView){
        self.snp.makeConstraints { (make) in
            make.top.equalTo(superView.snp.top)
            make.left.equalTo(superView.snp.left)
            make.right.equalTo(superView.snp.right)
            make.bottom.equalTo(superView.snp.bottom)
        }
    }
}
