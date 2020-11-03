//
//  NewSearchVC.swift
//  FeedBack2
//
//  Created by Julian Gierl on 14.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit


protocol HeaderViewDelegate{
    func categoryChanged(category: Category)
    func searchEntered(input: String?)
    func actionButtonPressed()
}

class SearchVC: UIViewController{
    
    let headerView = SearchHeaderView()
    let categoriesView = SearchCategoriesStackView()
    
    let showCaseView = UIView()
    let listView = UIView()
    let contentView = UIView()
    
    let charityListVC = CharityListVC()
    let showcaseVC = ShowCaseVC()
    var searchCategory: Category?
    
    var copyRightLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureHeaderView()
        configureCategoriesView()
        configureCopyRightLabel()
        configureContentView()
        configureShowCaseVC()
    }
    
    private func configureNavigationBar(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = .black
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.setGradientBackgroundColor(colors: [.lightBlueBackgroundGradientStart, .lightBlueBackgroundGradientEnd], axis: .horizontal)
        
    }
}


extension SearchVC{
    private func configureHeaderView(){
        view.addSubview(headerView)
        headerView.delegate = self
        headerView.snp.makeConstraints { (maker) in
            maker.top.equalTo(view.snp.top)
            maker.left.equalTo(view.snp.left)
            maker.right.equalTo(view.snp.right)
            maker.height.equalTo(200)
        }
    }
    
    private func configureCategoriesView(){
        categoriesView.searchVCdelegate = self
        view.addSubview(categoriesView)
        categoriesView.snp.makeConstraints { (maker) in
            maker.top.equalTo(headerView.snp.bottom).offset(50)
            maker.left.equalTo(view.snp.left).offset(20)
            maker.right.equalTo(view.snp.right).offset(20)
            maker.height.equalTo(40)
        }
    }
    
    private func configureCopyRightLabel(){
        view.addSubview(copyRightLabel)
        copyRightLabel.text = "Data provided by SoGive Ltd"
        copyRightLabel.textAlignment = .center
        copyRightLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        copyRightLabel.adjustsFontSizeToFitWidth = true
        copyRightLabel.minimumScaleFactor = 0.6
        copyRightLabel.lineBreakMode = .byTruncatingTail
        copyRightLabel.textColor = .secondaryLabel
        
        copyRightLabel.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-5)
            maker.left.equalTo(view.snp.left)
            maker.right.equalTo(view.snp.right)
            maker.height.equalTo(20)
        }
    }
    
    private func configureShowCaseVC(){
        showcaseVC.delegate = self
        add(childVC: showcaseVC, to: showCaseView)
        contentView.addSubview(showCaseView)
        showCaseView.pinToEdges(of: contentView)
    }
    
    private func configureContentView(){
        view.addSubview(contentView)
        contentView.snp.makeConstraints { (maker) in
            maker.top.equalTo(categoriesView.snp.bottom).offset(10)
            maker.bottom.equalTo(copyRightLabel.snp.top)
            maker.left.equalTo(view.snp.left)
            maker.right.equalTo(view.snp.right)
        }
    }
    
    private func showListVC() {
        if(showCaseView.isDescendant(of: contentView)){
            showCaseView.removeFromSuperview()
            contentView.addSubview(listView)
            listView.pinToEdges(of: contentView)
            add(childVC: charityListVC, to: listView)
        }
    }
    
    private func showShowCaseVC(){
        if(listView.isDescendant(of: contentView)){
            listView.removeFromSuperview()
            contentView.addSubview(showCaseView)
            showCaseView.pinToEdges(of: contentView)
            add(childVC: showcaseVC, to: showCaseView)
        }
    }

    

}

extension SearchVC: HeaderViewDelegate{
    func actionButtonPressed() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let showOverViewAction = UIAlertAction(title: "Show Overview", style: .default) { (action) in
            self.headerView.textfield.clearTextField()
            self.showShowCaseVC()
        }
        let sortAction = UIAlertAction(title: "Sort for impact", style: .default) { (action) in
            if(self.listView.isDescendant(of: self.contentView)){
                self.charityListVC.sortForImpact()
            }
        }
        
        if(listView.isDescendant(of: contentView)){
            alertController.addAction(sortAction)
            alertController.addAction(showOverViewAction)
            alertController.addAction(UIAlertAction(title: "Cancel",
                                                    style: .cancel,
                                                    handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func categoryChanged(category: Category) {
        showListVC()
        headerView.textfield.clearTextField()
        charityListVC.getCharities(searchParameter: category.parameter)
    }
    
    func searchEntered(input: String?){
        guard let searchInput = input, !searchInput.isEmpty else { return }
        showListVC()
        categoriesView.selectedCategory = nil
        categoriesView.updateCategorySelection()
        charityListVC.getCharities(searchParameter: "q=\(searchInput)")
    }
}

extension SearchVC: ShowCaseVCDelegate{
    func showCharityInfo(charityId: String, charity: Charity) {
        headerView.textfield.clearTextField()
        let charityInfoVC = CharityInfoVC()
        charityInfoVC.charityId = charityId
        charityInfoVC.charity = charity
        let navigationController = UINavigationController(rootViewController: charityInfoVC)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.navigationBar.barStyle = .black
        present(navigationController, animated: true)
    }
    
    func showCategories(category: Category) {
        showListVC()
        headerView.textfield.clearTextField()
        categoriesView.selectedCategory = category
    }
    
    
}


