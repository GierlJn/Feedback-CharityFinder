//
//  ExploreCharityCell.swift
//  FeedBack2
//
//  Created by Julian Gierl on 15.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

final class ExploreCharityCell: UICollectionViewCell{
    
    let imageView = FBLogoImageView(frame: .zero)
    let titleLabel = FBTitleLabel(textAlignment: .center)
    let labelView = UIView()
    
    static let reuseIdentifier = "explore-charity-cell"
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        configureLabelView()
        configureImageView()
        configureSeperator()
        backgroundColor = .logoImageBackground
        layer.cornerRadius = 8
        clipsToBounds = true
    }
    
    fileprivate func configureLabelView() {
        addSubview(labelView)
        labelView.snp.makeConstraints { (maker) in
            maker.height.equalTo(50)
            maker.left.equalTo(contentView.snp.left)
            maker.right.equalTo(contentView.snp.right)
            maker.bottom.equalTo(contentView.snp.bottom)
        }
        configureTitleLabel()
    }
    
    fileprivate func configureTitleLabel() {
        let spacing = 10
        
        labelView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(labelView.snp.top).offset(spacing)
            maker.left.equalTo(labelView.snp.left).offset(spacing)
            maker.right.equalTo(labelView.snp.right).offset(-spacing)
            maker.bottom.equalTo(labelView.snp.bottom).offset(-spacing)
        }
    }
    
    fileprivate func configureSeperator() {
        let border = UIView()
        border.backgroundColor = .systemGray6
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: labelView.frame.size.width, height: 0.9)
        labelView.addSubview(border)
    }
    
    fileprivate func configureImageView() {
        let padding = 15
        
        addSubview(imageView)
        imageView.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView.snp.top).offset(padding)
            maker.left.equalTo(contentView.snp.left).offset(padding)
            maker.right.equalTo(contentView.snp.right).offset(-padding)
            maker.bottom.equalTo(labelView.snp.top).offset(-padding)
        }
    }
}
