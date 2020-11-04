//
//  CharityNameLabelView.swift
//  FeedBack2
//
//  Created by Julian Gierl on 08.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

protocol TitleLabelViewDelegate{
    func favouriteButtonPressed()
}

class CharityTitleLabelView: UIView{
    
    let titleLabel = FBTitleLabel(textAlignment: .left)
    let favoriteButton = UIButton()
    var delegate: TitleLabelViewDelegate?
    var isFavourite: Bool = false{
        didSet{
            favoriteButton.setImage(isFavourite ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark"), for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .categoriesTransparentColor
        layer.cornerRadius = 7
        layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(title: String){
        titleLabel.text = title
    }
    
    private func configure(){
        addSubview(favoriteButton)
        favoriteButton.setImage(isFavourite ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark"), for: .normal)
        favoriteButton.addTarget(self, action: #selector(favouriteButtonPressed), for: .touchUpInside)
        favoriteButton.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.snp.right).offset(-16)
            maker.size.equalTo(20)
            maker.centerY.equalTo(self.snp.centerY)
        }
        
        addSubview(titleLabel)
        titleLabel.textColor = .darkText
        titleLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(favoriteButton.snp.left).offset(-16)
            maker.top.equalTo(self.snp.top).offset(10)
            maker.bottom.equalTo(self.snp.bottom).offset(-10)
            maker.left.equalTo(self.snp.left).offset(20)
        }
    }
    
    @objc func favouriteButtonPressed(){
        delegate?.favouriteButtonPressed()
    }
    
}
