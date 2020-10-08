//
//  CharityNameLabelView.swift
//  FeedBack2
//
//  Created by Julian Gierl on 08.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

class CharityTitleLabelView: UIView{
    
    let titleLabel = FBTitleLabel(textAlignment: .left)
    let favoriteIconImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(title: String){
        titleLabel.text = title
    }
    
    private func configure(){
        addSubview(favoriteIconImageView)
        favoriteIconImageView.image = UIImage(systemName: "bookmark")
        favoriteIconImageView.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.snp.right).offset(-16)
            maker.size.equalTo(20)
            maker.centerY.equalTo(self.snp.centerY)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(favoriteIconImageView.snp.left).offset(-16)
            maker.top.equalTo(self.snp.top).offset(16)
            maker.bottom.equalTo(self.snp.bottom).offset(-16)
            maker.left.equalTo(self.snp.left).offset(60)
        }
    }
    
}
