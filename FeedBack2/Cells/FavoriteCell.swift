//
//  FavoriteCell.swift
//  FeedBack2
//
//  Created by Julian Gierl on 01.11.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

class FavoriteCell: UITableViewCell{
    static let reuseIdentifier = "FavoriteCell"
    
    let titleLabel = FBTitleLabel(frame: .zero)
    let logoImageView = FBLogoImageView(frame: .zero)
    let padding = 20
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLogoImageView()
        configureLabels()
        backgroundColor = .init(white: 0, alpha: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(charity: Charity){
        titleLabel.text = charity.name
        logoImageView.setLogoImage(logoUrl: charity.logoUrl)
    }
    
    private func configureLogoImageView(){
        contentView.addSubview(logoImageView)
        logoImageView.setRoundCorners()
        logoImageView.snp.makeConstraints { (maker) in
            maker.size.equalTo(80)
            maker.left.equalTo(padding)
            maker.centerY.equalTo(snp.centerY)
        }
    }
    
    private func configureLabels(){
        contentView.addSubview(titleLabel)
        //titleLabel.textAlignment = .right
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(snp.top).offset(padding)
            maker.left.equalTo(logoImageView.snp.right).offset(15)
            maker.right.equalTo(-25)
            maker.height.equalTo(40)
        }
        
    }
    
}


