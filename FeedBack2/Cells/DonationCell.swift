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
    let padding = 20
    
    var titleLabel = FBTitleLabel(textAlignment: .left)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(donation: Donation){
        titleLabel.text = donation.charityName
    }
    
    private func configure(){
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(snp.left)
            maker.top.equalTo(snp.top)
        }
    }


}
