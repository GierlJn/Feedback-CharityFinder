//
//  HeaderView.swift
//  FeedBack2
//
//  Created by Julian Gierl on 14.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit
import AnimatedGradientView

class SearchHeaderView: UIView{
    
    let backgroundView = AnimatedGradientView()
    let label = FBTitleLabel(textAlignment: .left)
    
    let searchStackView = UIStackView()
    let textfield = FBTextField()
    let searchButton = UIButton()
    
    var delegate: HeaderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure(){
        configureBackgroundView()
        configureLabel()
        configureSearchView()
        configureTextField()
    }
    
    fileprivate func configureBackgroundView(){
        addSubview(backgroundView)
        backgroundView.pinToEdges(of: self)
        backgroundView.colors = [[UIColor.hedaerViewGradientStart, UIColor.headerViewGradientEnd]]
        backgroundView.direction = .right
        backgroundView.type = .conic
    }
    
    fileprivate func configureLabel() {
        addSubview(label)
        label.textColor = .white
        label.text = "Discover Charities"
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.snp.makeConstraints { (maker) in
            maker.left.equalTo(snp.left).offset(20)
            maker.right.equalTo(snp.right).offset(-20)
            maker.height.equalTo(50)
            maker.bottom.equalTo(snp.bottom).offset(-40)
        }
    }
    
    fileprivate func configureSearchView(){
        searchStackView.axis = .horizontal
        addSubview(searchStackView)
        searchStackView.snp.makeConstraints { (maker) in
            maker.left.equalTo(snp.left).offset(20)
            maker.right.equalTo(snp.right).offset(-20)
            maker.height.equalTo(50)
            maker.centerY.equalTo(snp.bottom)
        }

        searchStackView.spacing = 8
        searchStackView.addArrangedSubview(textfield)
        searchStackView.addArrangedSubview(searchButton)
        searchButton.snp.makeConstraints { (maker) in
            maker.size.equalTo(50)
        }
        
        searchButton.setImage(Images.searchActionButton, for: .normal)
        searchButton.setGradientBackgroundColor(colors: [.hedaerViewGradientStart, .headerViewGradientEnd], axis: .custom(angle: CGFloat(90)))
        searchButton.layer.cornerRadius = 7
        searchButton.clipsToBounds = true
        searchButton.tintColor = .white

    }
    
    func configureTextField(){
        textfield.delegate = self
    }

    
}


extension SearchHeaderView: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.searchEntered(input: textfield.text)
        return true
    }
}
