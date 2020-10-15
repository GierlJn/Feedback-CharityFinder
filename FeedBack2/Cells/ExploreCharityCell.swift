//
//  ExploreCharityCell.swift
//  FeedBack2
//
//  Created by Julian Gierl on 15.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

class ExploreCharityCell: UICollectionViewCell{
    static let reuseIdentifier = "explore-charity-cell"
    
    let imageView = FBLogoImageView(frame: .zero)
    let titleLabel = FBTitleLabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ExploreCharityCell {
    func configure(){
        
        
        let spacing = 10
        imageView.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView.snp.top)
            maker.left.equalTo(contentView.snp.left)
            maker.right.equalTo(contentView.snp.right)
        }
        
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(imageView.snp.bottom).offset(spacing)
            maker.left.equalTo(contentView.snp.left)
            maker.right.equalTo(contentView.snp.right)
            maker.bottom.equalTo(contentView.snp.bottom)
            
        }
    }
}
