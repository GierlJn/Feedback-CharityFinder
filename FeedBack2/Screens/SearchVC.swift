//
//  SearchVC.swift
//  FeedBack2
//
//  Created by Julian Gierl on 30.09.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

class SearchVC: UIViewController{
    
    let actionButton = FBButton(title: "Get Impact", backgroundColor: .systemBlue)
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        configureActionButton()
    }
    
    private func configureActionButton(){
        view.addSubview(actionButton)
        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150),
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actionButton.heightAnchor.constraint(equalToConstant: 40),
            actionButton.widthAnchor.constraint(equalToConstant: 150)
        ])
        actionButton.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)
    }
    
    @objc func actionButtonPressed(){
        let charityListVC = CharityListVC()
        navigationController?.pushViewController(charityListVC, animated: true)
    }
}
