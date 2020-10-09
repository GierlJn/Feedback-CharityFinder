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
    let trackActionButton = FBButton(title: "Track donation", backgroundColor: .systemGray)
    
    let stackView = UIStackView()
    
    var delegate: DonationBarViewDelegate?
    
    override func viewDidLoad() {
        configureUI()
        layoutUI()
    }
    
    private func configureUI(){
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.addArrangedSubview(donateActionButton)
        stackView.addArrangedSubview(trackActionButton)
    }
    
    private func layoutUI(){
        stackView.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(self.view.snp.bottom).offset(-8)
            maker.left.equalTo(self.view.snp.left).offset(8)
            maker.right.equalTo(self.view.snp.right).offset(-8)
            maker.top.equalTo(self.view.snp.top).offset(8)
        }
    }
    
}
