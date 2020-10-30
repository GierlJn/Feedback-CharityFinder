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
    let titleLabel = FBTitleLabel(textAlignment: .center)
    let labelView = UIView()
    
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
        addSubviews(imageView, labelView)
        
        let spacing = 10

        labelView.snp.makeConstraints { (maker) in
            maker.height.equalTo(50)
            maker.left.equalTo(contentView.snp.left)
            maker.right.equalTo(contentView.snp.right)
            maker.bottom.equalTo(contentView.snp.bottom)
        }
        
        labelView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(labelView.snp.top).offset(spacing)
            maker.left.equalTo(labelView.snp.left).offset(spacing)
            maker.right.equalTo(labelView.snp.right).offset(-spacing)
            maker.bottom.equalTo(labelView.snp.bottom).offset(-spacing)
        }
        
        imageView.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView.snp.top)
            maker.left.equalTo(contentView.snp.left)
            maker.right.equalTo(contentView.snp.right)
            maker.bottom.equalTo(labelView.snp.top)
        }
        
        

        labelView.setGradientBackgroundColor(colors: [.buttonDarkBlueGradientStart, .buttonDarkBlueGradientEnd], axis: .horizontal)
    }
}
