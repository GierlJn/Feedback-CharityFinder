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
    let impactDescriptionLabel = UILabel(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(charity: Charity){
        titleLabel.text = charity.name
        impactDescriptionLabel.text = charity.output.impactDecsription
    }
    
    private func configure(){
        contentView.addSubview(titleLabel)
        contentView.addSubview(impactDescriptionLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        impactDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            impactDescriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10)
            
        ])
    }
}
