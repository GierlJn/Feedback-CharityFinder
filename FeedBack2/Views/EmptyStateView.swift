//
//  EmptyStateView.swift
//  FeedBack2
//
//  Created by Julian Gierl on 05.11.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

class EmptyStateView: UIView{
    
    var titleLabel = FBTitleLabel(textAlignment: .center)
    var title: String = "Nothing to see here"
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String?) {
        self.init(frame: .zero)
        configure()
    }
    
    private func configure(){
        addSubview(titleLabel)
        titleLabel.text = title
        
        titleLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(snp.centerY)
            maker.left.equalTo(snp.left).offset(40)
            maker.right.equalTo(snp.right).offset(-40)
        }
    }
}
