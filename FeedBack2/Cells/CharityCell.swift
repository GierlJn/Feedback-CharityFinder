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
    let subTitleLabel = FBSubTitleLabel(frame: .zero)
    let logoImageView = FBLogoImageView(frame: .zero)
    let padding = 20
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
        if let impctestimation = charity.impactEstimation{
            subTitleLabel.text = "Impact: \(impctestimation)"
        }else{
            subTitleLabel.text = "Impact unknown"
        }
        
        logoImageView.setLogoImage(urlString: charity.logoUrl)
    }
    
    private func configureLogoImageView(){
        contentView.addSubview(logoImageView)
        logoImageView.setRoundCorners()
        logoImageView.snp.makeConstraints { (maker) in
            maker.size.equalTo(100)
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
        
        contentView.addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom).offset(5)
            maker.left.equalTo(logoImageView.snp.right).offset(15)
            maker.right.equalTo(-25)
            maker.bottom.equalTo(snp.bottom).offset(-25)
        }
        
    }
    
    private func configureButton(){
        
    }
    
    
    
    
}
