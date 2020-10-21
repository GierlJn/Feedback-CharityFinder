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
    let categoriesView = SearchCategoriesStackView()
    let showCaseView = UIView()
    var searchCategory = Categories.all.category
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureHeaderView()
        configureCategoriesView()
        configureShowCaseVC()
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
            maker.height.equalTo(160)
        }
    }
    
    private func configureCategoriesView(){
        view.addSubview(categoriesView)
        categoriesView.snp.makeConstraints { (maker) in
            maker.top.equalTo(headerView.snp.bottom).offset(50)
            maker.left.equalTo(view.snp.left).offset(20)
            maker.right.equalTo(view.snp.right).offset(20)
            maker.height.equalTo(40)
        }
    }
    
    private func configureShowCaseVC(){
        let showcaseVC = ShowCaseVC()
        add(childVC: showcaseVC, to: showCaseView)
        view.addSubview(showCaseView)
        showCaseView.snp.makeConstraints { (maker) in
            maker.top.equalTo(categoriesView.snp.bottom).offset(10)
            maker.bottom.equalTo(view.snp.bottom)
            maker.left.equalTo(view.snp.left)
            maker.right.equalTo(view.snp.right)
        }
        
    }
}


