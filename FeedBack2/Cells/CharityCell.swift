//
//  CharityCell.swift
//  FeedBack2
//
//  Created by Julian Gierl on 01.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

class CharityCell: UITableViewCell{
    static let reuseIdentifier = "CharityCell"
    
    let titleLabel = FBTitleLabel(frame: .zero)
    //let impactDescriptionLabel = FBSubTitleLabel(frame: .zero)
    let logoImageView = FBLogoImageView(frame: .zero)
    let padding = 20
    let enteredDonation: Float = 1.0
    let favouriteButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLogoImageView()
        configureLabels()
        configureButton()
        backgroundColor = .init(white: 0, alpha: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(charity: Charity){
        titleLabel.text = charity.name
        logoImageView.setLogoImage(logoUrl: charity.logoUrl)
    }
    
    private func configureLabels(){
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(snp.centerY)
            maker.left.equalTo(logoImageView.snp.right).offset(15)
            maker.right.equalTo(-padding)
            maker.height.equalTo(40)
        }
    }
    
    private func configureButton(){
        
    }
    
    
    
    private func configureLogoImageView(){
        contentView.addSubview(logoImageView)
        logoImageView.setRoundCorners()
        logoImageView.snp.makeConstraints { (maker) in
            maker.size.equalTo(80)
            maker.left.equalTo(padding)
            maker.top.equalTo(padding)
        }
    }
}
