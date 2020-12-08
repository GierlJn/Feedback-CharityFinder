//
//  CharityCell.swift
//  FeedBack2
//
//  Created by Julian Gierl on 01.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

final class CharityCell: UITableViewCell{
    
    let titleLabel = FBTitleLabel(frame: .zero)
    let subTitleLabel = FBSubTitleLabel(frame: .zero)
    let logoImageView = FBLogoImageView(frame: .zero)
    let imageContentView = UIView()
    
    static let reuseIdentifier = "CharityCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
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
    
    private func configure(){
        backgroundColor = .init(white: 0, alpha: 0)
        configureLogoImageView()
        configureLabels()
    }
    
    private func configureLogoImageView(){
        configureImageContentView()
        configureImageView()
    }
    
    fileprivate func configureImageContentView() {
        contentView.addSubview(imageContentView)
        imageContentView.snp.makeConstraints { (maker) in
            maker.size.equalTo(100)
            maker.left.equalTo(20)
            maker.centerY.equalTo(snp.centerY)
        }
    }
    
    fileprivate func configureImageView() {
        let inset = 15
        imageContentView.addSubview(logoImageView)
        logoImageView.setRoundCorners()
        logoImageView.snp.makeConstraints { (maker) in
            maker.top.equalTo(imageContentView.snp.top).offset(inset)
            maker.bottom.equalTo(imageContentView.snp.bottom).offset(-inset)
            maker.left.equalTo(imageContentView.snp.left).offset(inset)
            maker.right.equalTo(imageContentView.snp.right).offset(-inset)
        }
    }
    
    private func configureLabels(){
        configureTitleLabel()
        configureSubTitleLabel()
    }
    
    fileprivate func configureTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(snp.top).offset(20)
            maker.left.equalTo(logoImageView.snp.right).offset(15)
            maker.right.equalTo(-25)
            maker.height.equalTo(40)
        }
    }
    
    fileprivate func configureSubTitleLabel() {
        contentView.addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom).offset(5)
            maker.left.equalTo(logoImageView.snp.right).offset(15)
            maker.right.equalTo(-25)
            maker.bottom.equalTo(snp.bottom).offset(-25)
        }
    }
}
