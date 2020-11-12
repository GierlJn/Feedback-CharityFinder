//
//  FooterView.swift
//  FeedBack2
//
//  Created by Julian Gierl on 06.11.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

protocol FooterViewDelegate{
    func buttonPressed()
}

class FooterView: UICollectionReusableView{
    
    var actionButton = UIButton()
    let padding = 20
    var delegate: FooterViewDelegate?
    static let reuseIdentifier = "FooterView"
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        addSubview(actionButton)
        
        actionButton.setTitle("Data provided by SoGive LtD", for: .normal)
        actionButton.setTitleColor(.secondaryLabel, for: .normal)
        actionButton.titleLabel?.textAlignment = .center
        actionButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .footnote)
        actionButton.titleLabel?.adjustsFontSizeToFitWidth = true
        actionButton.titleLabel?.minimumScaleFactor = 0.6
        actionButton.titleLabel?.lineBreakMode = .byTruncatingHead
        actionButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        actionButton.snp.makeConstraints { (maker) in
            maker.left.equalTo(snp.left).offset(padding)
            maker.right.equalTo(snp.right).offset(-padding)
            maker.top.equalTo(snp.top).offset(5)
            maker.bottom.equalTo(snp.bottom)
        }
    }
    
    @objc private func buttonPressed(){
        delegate?.buttonPressed()
    }
    
}


class FooterUIView: UIView{
    
    var actionButton = UIButton()
    let padding = 20
    var delegate: FooterViewDelegate?
    static let reuseIdentifier = "FooterView"
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        addSubview(actionButton)
        
        actionButton.setTitle("Data provided by SoGive LtD", for: .normal)
        actionButton.setTitleColor(.secondaryLabel, for: .normal)
        actionButton.titleLabel?.textAlignment = .center
        actionButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .footnote)
        actionButton.titleLabel?.adjustsFontSizeToFitWidth = true
        actionButton.titleLabel?.minimumScaleFactor = 0.6
        actionButton.titleLabel?.lineBreakMode = .byTruncatingHead
        actionButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        actionButton.snp.makeConstraints { (maker) in
            maker.left.equalTo(snp.left).offset(padding)
            maker.right.equalTo(snp.right).offset(-padding)
            maker.top.equalTo(snp.top)
            maker.bottom.equalTo(snp.bottom)
        }
    }
    
    @objc private func buttonPressed(){
        delegate?.buttonPressed()
    }
    
}
