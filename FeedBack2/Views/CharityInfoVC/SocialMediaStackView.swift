//
//  SocialMediaStackView.swift
//  FeedBack
//
//  Created by Julian Gierl on 20.11.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

protocol SocialMediaStackViewDelegate{
    func buttonPressed(type: SocialMediaType)
}

class SocialMediaStackView: UIStackView{
    
    var delegate: SocialMediaStackViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        distribution = .equalSpacing
        spacing = 5
        for type in SocialMediaType.allCases{
            addButton(type: type)
        }
    }
    
    private func addButton(type: SocialMediaType){
        let button = SocialMediaButton(type: type)
        self.addArrangedSubview(button)
        button.snp.makeConstraints { (maker) in
            maker.size.equalTo(30)
        }
        button.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
    }
    
    @objc func buttonPressed(sender: SocialMediaButton){
        delegate?.buttonPressed(type: sender.type)
    }

}

class SocialMediaButton: UIButton{
    var type: SocialMediaType!
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(type: SocialMediaType) {
        self.init()
        self.type = type
        configure()
    }
    
    private func configure(){
        switch type{
        case .facebook:
            setImage(Images.facebookIcon, for: .normal)
        case .twitter:
            setImage(Images.twitterIcon, for: .normal)
        case .whatsapp:
            setImage(Images.whatsappIcon, for: .normal)
        default:
            return
        }
        imageView?.sizeToFit()
    }
}


enum SocialMediaType: CaseIterable{
    case facebook, twitter, whatsapp
}
