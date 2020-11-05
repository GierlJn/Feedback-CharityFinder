//
//  DonationStatusBar.swift
//  FeedBack2
//
//  Created by Julian Gierl on 08.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

class DonationBarView: UIView{
    
    let actionButton = FBButton(title: "Donate")
    var delegate: DonationBarViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        actionButton.setGradientBackgroundColor(colors: [.headerViewGradientStart, .headerViewGradientEnd], axis: .horizontal, cornerRadius: 7)
    }
    
    private func configure(){
        addSubview(actionButton)
        actionButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        actionButton.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)

        let padding = 16
        
        actionButton.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.snp.left).offset(padding*2)
            maker.right.equalTo(self.snp.right).offset(-padding*2)
            maker.top.equalTo(self.snp.top).offset(padding)
            maker.bottom.equalTo(self.snp.bottom).offset(-padding*2)
        }
    }
    
    @objc func actionButtonPressed(){
        delegate?.donationButtonPressed()
    }
}

