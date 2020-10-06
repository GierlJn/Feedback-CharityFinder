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
    let impactDescriptionLabel = FBBodyLabel(frame: .zero)
    let logoImageView = FBLogoImageView(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLogoImageView()
        configureLabels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(charity: Charity, enteredDonation: Float){
        titleLabel.text = charity.name
        let calculatedImpact = DonationManager.calculateValue(for: charity.output.costPerBeneficiary?.value ?? 0.0, impactValue: enteredDonation)
        impactDescriptionLabel.text = "\(calculatedImpact) \(charity.output.name?.lowercased() ?? "")"
        
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
        NSLayoutConstraint.activate([
            logoImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            logoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            logoImageView.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
}
