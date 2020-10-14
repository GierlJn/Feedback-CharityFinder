//
//  SearchVC.swift
//  FeedBack2
//
//  Created by Julian Gierl on 30.09.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

class SearchVC: UIViewController{
    
    let actionButton = FBButton(title: "Get Impact")
    let textfield = FBTextField()
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        configureActionButton()
        configureTextField()
    }
    
    private func configureActionButton(){
        view.addSubview(actionButton)
        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150),
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actionButton.heightAnchor.constraint(equalToConstant: 40),
            actionButton.widthAnchor.constraint(equalToConstant: 280)
        ])
        actionButton.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)
    }
    
    private func configureTextField(){
        view.addSubview(textfield)
        NSLayoutConstraint.activate([
            textfield.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -50),
            textfield.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textfield.heightAnchor.constraint(equalToConstant: 40),
            textfield.widthAnchor.constraint(equalToConstant: 280)
        ])
    }
    
    @objc func actionButtonPressed(){
        let charityListVC = CharityListVC()
        
        if(!textfield.text!.isEmpty){
            charityListVC.enteredDonation = Float(textfield.text ?? "0.0")!
            charityListVC.title = textfield.text ?? "0.0"
        }
        
        navigationController?.pushViewController(charityListVC, animated: true)
    }
}
