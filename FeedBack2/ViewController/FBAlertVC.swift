//
//  FBAlertVC.swift
//  FeedBack2
//
//  Created by Julian Gierl on 31.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

class FBAlertVC: UIViewController{
    
    var containerView = UIView()
    var titleLabel = FBTitleLabel(textAlignment: .center)
    var messageLabel = FBSubTitleLabel(textAlignment: .center)
    var actionButton = FBButton()
    
    var alertTitle: String?
    var message: String?
    var buttonTitle: String?
    
    let padding: CGFloat = 20
    
    init(title: String, message: String, buttonTitle: String) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = title
        self.message = message
        self.buttonTitle = buttonTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        configure()
    }
    
    fileprivate func configureContainerView() {
        containerView.backgroundColor = .systemBackground
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.buttonDarkBlue.cgColor
        containerView.layer.cornerRadius = 12
        containerView.clipsToBounds = true
        
        containerView.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(view.snp.centerY)
            maker.centerX.equalTo(view.snp.centerX)
            maker.height.equalTo(220)
            maker.width.equalTo(280)
        }
    }
    
    private func configure(){
        view.addSubview(containerView)
        
        configureContainerView()
        
        
        containerView.addSubview(titleLabel)
        titleLabel.text = alertTitle ?? "Something went wrong!"
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(containerView.snp.top).offset(padding)
            maker.left.equalTo(containerView.snp.left).offset(padding)
            maker.right.equalTo(containerView.snp.right).offset(-padding)
            maker.height.equalTo(28)
        }
        
        containerView.addSubview(actionButton)
        actionButton.setTitle(buttonTitle, for: .normal)
        actionButton.snp.makeConstraints { (maker) in
            maker.height.equalTo(44)
            maker.left.equalTo(containerView.snp.left).offset(padding)
            maker.right.equalTo(containerView.snp.right).offset(-padding)
            maker.bottom.equalTo(containerView.snp.bottom).offset(-padding)
        }
        actionButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        containerView.addSubview(messageLabel)
        messageLabel.text = message ?? ""
        messageLabel.numberOfLines = 3
        messageLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom).offset(8)
            maker.left.equalTo(containerView.snp.left).offset(padding)
            maker.right.equalTo(containerView.snp.right).offset(-padding)
            maker.bottom.equalTo(actionButton.snp.top).offset(-12)
        }
        
       
        
    }
    
    @objc func buttonPressed(){
        dismiss(animated: true)
    }
    
}
