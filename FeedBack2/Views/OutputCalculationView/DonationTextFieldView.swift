//
//  DonationTextField.swift
//  FeedBack
//
//  Created by Julian Gierl on 10.11.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

final class DonationTextContentView: UIView{
    
    var textField = FBTextField()
    var currencyLabel = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        addSubview(currencyLabel)
        currencyLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(snp.right).offset(-3)
            maker.top.equalTo(snp.top)
            maker.bottom.equalTo(snp.bottom)
            maker.width.equalTo(15)
        }
        
        textField.returnKeyType = .go
        textField.clearButtonMode = .never
        textField.placeholder = "Enter donation"
        textField.keyboardType = .numberPad
        textField.layer.borderWidth = 0
        textField.backgroundColor = .none
        addSubview(textField)
        textField.snp.makeConstraints { (maker) in
            maker.top.equalTo(snp.top)
            maker.bottom.equalTo(snp.bottom)
            maker.left.equalTo(snp.left).offset(18)
            maker.right.equalTo(currencyLabel.snp.left)
        }
        
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray.cgColor
    }
    
}
