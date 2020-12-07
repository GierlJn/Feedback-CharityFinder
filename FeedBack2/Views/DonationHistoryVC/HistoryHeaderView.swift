//
//  HistoryHeaderView.swift
//  FeedBack
//
//  Created by Julian Gierl on 23.11.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

final class HistoryHeaderView: UIView{
    
    var titleLabel = FBTitleLabel(textAlignment: .center)
    var numbersStackView = NumbersStackView()
    var toggleButton = UIButton()
    
    let padding = 20
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI(with donations: [Donation]){
        numbersStackView.updateUI(with: donations)
    }
    
    private func configure(){
        configureTitleLabel()
        configureNumberStackView()
        configureSeperator()
    }
    
    private func configureTitleLabel(){
        addSubview(titleLabel)
        titleLabel.text = "Your donations"
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(snp.top)
            maker.height.equalTo(50)
            maker.left.equalTo(snp.left).offset(padding)
            maker.right.equalTo(snp.right).offset(-padding)
        }
    }
    
    private func configureNumberStackView(){
        addSubview(numbersStackView)
        numbersStackView.axis = .vertical
        numbersStackView.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom)
            maker.height.equalTo(50)
            maker.left.lessThanOrEqualTo(snp.left).offset(padding)
            maker.right.lessThanOrEqualTo(snp.right).offset(-padding)
            maker.centerX.equalTo(snp.centerX)
        }
    }
    
    private func configureSeperator(){
        let seperator = UIView()
        seperator.backgroundColor = .label
        seperator.alpha = 0.5
        addSubview(seperator)
        seperator.snp.makeConstraints { (maker) in
            maker.top.equalTo(snp.bottom)
            maker.width.equalTo(snp.width)
            maker.height.equalTo(0.5)
            maker.centerX.equalTo(snp.centerX)
        }
    }
}
