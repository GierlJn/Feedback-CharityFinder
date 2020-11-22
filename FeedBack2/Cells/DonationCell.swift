//
//  DonationCell.swift
//  FeedBack
//
//  Created by Julian Gierl on 20.11.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

class DonationCell: UITableViewCell{
    
    static let reuseIdentifier = "DonationCell"
    let padding = 15
    
    var titleLabel = FBTitleLabel(textAlignment: .left)
    var dateLabel = FBSubTitleLabel(textAlignment: .left)
    
    var donationAmountLabel = FBTitleLabel(textAlignment: .right)
    
    var labelStackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(donation: Donation){
        titleLabel.text = donation.charityName
        dateLabel.text = donation.date.getFormattedDate(format: "yyyy-MM-dd")
        donationAmountLabel.text = String(Int(donation.amount)) + donation.currency.symbol
    }
    
    private func configure(){
        configureLabelStackView()
        configureDonationAmountLabel()
    }
    
    private func configureLabelStackView(){
        addSubview(labelStackView)
        labelStackView.axis = .vertical
        labelStackView.spacing = 5
        labelStackView.addArrangedSubview(dateLabel)
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.snp.makeConstraints { (maker) in
            maker.left.equalTo(snp.left).offset(padding)
            maker.top.equalTo(snp.top).offset(padding)
            maker.bottom.equalTo(snp.bottom).offset(-padding)
            maker.width.equalTo(240)
        }
    }
    
    private func configureDonationAmountLabel(){
        addSubview(donationAmountLabel)
        donationAmountLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(labelStackView.snp.right).offset(padding)
            maker.right.equalTo(snp.right).offset(-padding)
            maker.top.equalTo(snp.top).offset(padding)
            maker.bottom.equalTo(snp.bottom).offset(-padding)
        }
    }
    

}
