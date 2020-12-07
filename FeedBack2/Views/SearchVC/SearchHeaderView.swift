//
//  HeaderView.swift
//  FeedBack2
//
//  Created by Julian Gierl on 14.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit
import AnimatedGradientView

final class SearchHeaderView: UIView{
    
    var backgroundView: AnimatedGradientView!
    let label = FBTitleLabel(textAlignment: .left)
    
    let searchStackView = UIStackView()
    let textfield = SearchTextField()
    let actionButton = UIButton()
    
    var delegate: HeaderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        actionButton.setGradientBackgroundColor(colors: [.headerButtonGradientStart, .headerButtonGradientEnd], axis: .custom(angle: CGFloat(90)))
        DispatchQueue.main.async {
            self.backgroundView.startAnimating()
        }
    }

    private func configure(){
        translatesAutoresizingMaskIntoConstraints = false
        configureBackgroundView()
        configureLabel()
        configureSearchView()
        configureTextField()
    }
    
    fileprivate func configureBackgroundView(){
        backgroundView = AnimatedGradientView()
        addSubview(backgroundView)
        backgroundView.pinToEdges(of: self)
        backgroundView.colors = [[UIColor.headerViewGradientStart, UIColor.headerViewGradientEnd]]
        backgroundView.direction = .right
        backgroundView.type = .conic
        backgroundView.drawsAsynchronously = false
        backgroundView.autoAnimate = false
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
            maker.right.lessThanOrEqualTo(snp.right).offset(-20).priority(1000)
            maker.width.greaterThanOrEqualTo(500).priority(900)
            maker.height.equalTo(50)
            maker.centerY.equalTo(snp.bottom)
        }

        searchStackView.spacing = 8
        searchStackView.addArrangedSubview(textfield)
        searchStackView.addArrangedSubview(actionButton)
        actionButton.snp.makeConstraints { (maker) in
            maker.size.equalTo(50)
        }
        
        actionButton.setImage(Images.searchActionButton, for: .normal)
        actionButton.addTarget(self, action: #selector(actionButtonTabbed), for: .touchUpInside)
        actionButton.setGradientBackgroundColor(colors: [.headerButtonGradientStart, .headerButtonGradientEnd], axis: .custom(angle: CGFloat(90)))
        actionButton.layer.cornerRadius = 7
        actionButton.clipsToBounds = true
        actionButton.tintColor = .white
    }
    
    func configureTextField(){
        textfield.delegate = self
    }

    @objc private func actionButtonTabbed(){
        delegate?.actionButtonPressed()
    }
}


extension SearchHeaderView: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.searchEntered(input: textfield.text)
        return true
    }
}
