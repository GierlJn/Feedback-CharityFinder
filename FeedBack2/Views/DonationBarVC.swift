//
//  DonationBarView.swift
//  FeedBack2
//
//  Created by Julian Gierl on 07.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

class DonationBarVC: UIViewController{
    
    let donateActionButton = FBButton(title: "Donate", backgroundColor: .systemBlue)
    let addDonationActionButton = FBButton(title: "Save Donation", backgroundColor: .systemGray)
    
    let statusBarViewOne = StatusBarViewOne()
    let statusBarViewTwo = StatusBarViewTwo()
    
    let stackView = UIStackView()
    
    var donationAmount: Float = 1.0
    var currency = "$"
    var charity: Charity!
    
    var delegate: DonationBarViewDelegate?
    
    override func viewDidLoad() {
        view.backgroundColor = .systemGray
        configureUI()
        layoutUI()
    }
    
    private func configureUI(){
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.addArrangedSubview(donateActionButton)
        stackView.addArrangedSubview(addDonationActionButton)
        
        statusBarViewOne.set(donationAmount: "1", currency: "$")
        statusBarViewTwo.set(calculatedImpact: "4.20", impactDescription: charity.mainOutput.name ?? "")
    }
    
    private func layoutUI(){
        
        self.view.addSubview(statusBarViewOne)
        statusBarViewOne.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.view.snp.top).offset(8)
            maker.left.equalTo(self.view.snp.left).offset(8).priority(999)
            maker.right.equalTo(self.view.snp.right).offset(-8).priority(999)
            maker.height.equalTo(40)
        }
        
        
        self.view.addSubview(statusBarViewTwo)
        statusBarViewTwo.snp.makeConstraints { (maker) in
            maker.top.equalTo(statusBarViewOne.snp.bottom).offset(8)
            maker.left.equalTo(self.view.snp.left).offset(8).priority(999)
            maker.right.equalTo(self.view.snp.right).offset(-8).priority(999)
            maker.height.equalTo(40)
        }

        self.view.addSubview(stackView)
        stackView.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(self.view.snp.bottom).offset(-8)
            maker.left.equalTo(self.view.snp.left).offset(8).priority(999)
            maker.right.equalTo(self.view.snp.right).offset(-8).priority(999)
            maker.height.equalTo(50)
        }
    }
}
