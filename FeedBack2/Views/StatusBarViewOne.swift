//
//  StatusBarViewOne.swift
//  FeedBack2
//
//  Created by Julian Gierl on 07.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

protocol StatusBarViewOneDelegate{
    func donationAmountButtonPressed()
}

class StatusBarViewOne: UIView{
    
    let fundAmountButton = UIButton()
    let mayFundLabel = FBTitleLabel(textAlignment: .left)
    var delegate: StatusBarViewOneDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        configureFundAmountButton()
        configureMayFundLabel()
    }
    
    func set(donationAmount: String, currency: String){
        fundAmountButton.setTitle("\(donationAmount) \(currency)", for: .normal)
    }
    
    private func configureFundAmountButton(){
        addSubview(fundAmountButton)
        fundAmountButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        fundAmountButton.setTitleColor(.black, for: .normal)
        fundAmountButton.addTarget(self, action: #selector(fundAmountButtonPressed), for: .touchUpInside)
        
        fundAmountButton.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.snp.left).offset(8)
            maker.height.equalTo(50)
            maker.width.equalTo(80)
            maker.centerY.equalTo(self.snp.centerY)
        }
    }
    
    private func configureMayFundLabel(){
        addSubview(mayFundLabel)
        mayFundLabel.text = "may fund..."
        mayFundLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(fundAmountButton.snp.right).offset(8)
            maker.height.equalTo(50)
            maker.width.equalTo(200)
            maker.centerY.equalTo(self.snp.centerY)
        }
    }
    
    @objc func fundAmountButtonPressed(){
        delegate?.donationAmountButtonPressed()
    }
}

