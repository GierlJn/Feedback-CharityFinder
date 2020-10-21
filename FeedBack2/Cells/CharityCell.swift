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
    let impactDescriptionLabel = FBSubTitleLabel(frame: .zero)
    let logoImageView = FBLogoImageView(frame: .zero)
    let padding = 20
    let enteredDonation: Float = 1.0
    
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
        //let calculatedImpact = DonationManager.calculateValue(for: charity.mainOutput.costPerBeneficiary?.value ?? 0.0, impactValue: enteredDonation)
        let value = charity.mainOutput.costPerBeneficiary?.value
        let formatted = String(format: "%.2f", value!)
        let valueLabelText = "1 \(charity.mainOutput.name?.formatOutputName(with: PersistenceManager.retrieveCurrency()) ?? "")"
        
        impactDescriptionLabel.text = "\(valueLabelText ) for every \(formatted)\(PersistenceManager.retrieveCurrency().symbol) donated"
        logoImageView.setLogoImage(logoUrl: charity.logoUrl)
    }
    
    private func configureLabels(){
        contentView.addSubview(titleLabel)
        contentView.addSubview(impactDescriptionLabel)

        impactDescriptionLabel.numberOfLines = 2
        
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(padding)
            maker.left.equalTo(logoImageView.snp.right).offset(10)
            maker.right.equalTo(-padding)
            maker.height.equalTo(40)
        }
        
        impactDescriptionLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom)
            maker.left.equalTo(logoImageView.snp.right).offset(10)
            maker.bottom.equalTo(-padding)
            maker.right.equalTo(-padding)
        }
        
    }
    
    private func configureLogoImageView(){
        contentView.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { (maker) in
            maker.size.equalTo(100)
            maker.left.equalTo(padding)
            maker.centerY.equalTo(snp.centerY)
            
        }
    }
}
