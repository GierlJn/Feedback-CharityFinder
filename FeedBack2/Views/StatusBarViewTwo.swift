//
//  StatusBarViewTwo.swift
//  FeedBack2
//
//  Created by Julian Gierl on 07.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

class StatusBarViewTwo: UIView{
    
    let impactValueLabel = UILabel()
    let impactDescriptionLabel = FBSubTitleLabel(textAlignment: .left)
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        //impactDescriptionLabel.text = impactDescription
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        configureImpactValueLabel()
        configureImpactDescriptionLabel()
    }
    
    func set(calculatedImpact: String, impactDescription: String){
        impactValueLabel.text = calculatedImpact
        impactDescriptionLabel.text = impactDescription
    }
    
    private func configureImpactValueLabel(){
        self.addSubview(impactValueLabel)
        impactValueLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        impactValueLabel.textAlignment = .center
        
        impactValueLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.snp.left).offset(8)
            maker.height.equalTo(50)
            maker.width.equalTo(100)
            maker.centerY.equalTo(self.snp.centerY)
        }
    }
    
    private func configureImpactDescriptionLabel(){
        self.addSubview(impactDescriptionLabel)
        impactDescriptionLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(impactValueLabel.snp.right).offset(8)
            maker.right.equalTo(self.snp.right).offset(-8)
            maker.height.equalTo(50)
            maker.centerY.equalTo(self.snp.centerY)
        }
    }
    
    
}
