//
//  NewSearchVC.swift
//  FeedBack2
//
//  Created by Julian Gierl on 14.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

class NewSearchVC: UIViewController{
    
    let textfield = FBTextField()
    let headerView = SearchHeaderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureHeaderView()
    }
    
    private func configureNavigationBar(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.setGradientBackgroundColor(colors: [.lightBlueBackgroundGradientStart, .lightBlueBackgroundGradientEnd], axis: .horizontal)
    }
    
    private func configureHeaderView(){
        view.addSubview(headerView)
        headerView.backgroundColor = .buttonDarkBlueGradientEnd
        headerView.snp.makeConstraints { (maker) in
            maker.top.equalTo(view.snp.top)
            maker.left.equalTo(view.snp.left)
            maker.right.equalTo(view.snp.right)
            maker.height.equalTo(200)
        }
    }
}
