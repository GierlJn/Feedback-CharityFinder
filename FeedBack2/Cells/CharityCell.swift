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
    
    let titleLabel = UILabel(frame: .zero)
    let impactDescriptionLabel = FBSubTitleLabel(frame: .zero)
    let logoImageView = FBLogoImageView(frame: .zero)
    let padding = 10
    let enteredDonation: Float = 1.0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLogoImageView()
        configureLabels()
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
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        impactDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        impactDescriptionLabel.numberOfLines = 2
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleLabel.heightAnchor.constraint(equalToConstant: 50),
            
            impactDescriptionLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: 10),
            impactDescriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            impactDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
    
    private func configureLogoImageView(){
        contentView.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { (maker) in
            maker.size.equalTo(100)
            maker.left.equalTo(padding)
            maker.top.equalTo(padding)
            maker.bottom.equalTo(-padding)
            
        }
    }
}
