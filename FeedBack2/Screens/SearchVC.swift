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
    
    var copyRightLabel = FooterSupplementaryView()
    
    var loadingVC: LoadingVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showSplashLoadingSreen()
        addDismissKeyBoardGesture()
        configureNavigationBar()
        configureHeaderView()
        configureCategoriesView()
        configureContentView()
        configureShowCaseVC()
    }
    
    fileprivate func showSplashLoadingSreen() {
        loadingVC = LoadingVC()
        guard let loadingVC = loadingVC else { return }
        loadingVC.modalTransitionStyle = .crossDissolve
        loadingVC.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async {
            self.present(loadingVC, animated: false)
        }
    }
    
    private func addDismissKeyBoardGesture(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
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
        categoriesView.delegate = self
        view.addSubview(categoriesView)
        categoriesView.snp.makeConstraints { (maker) in
            maker.top.equalTo(headerView.snp.bottom).offset(50)
            maker.left.equalTo(view.snp.left).offset(20)
            maker.right.equalTo(view.snp.right).offset(20)
            maker.height.equalTo(40)
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
            maker.bottom.equalTo(view.snp.bottom)
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
    }}

extension SearchVC: HeaderViewDelegate{
    func actionButtonPressed() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let showOverViewAction = UIAlertAction(title: "Show Overview", style: .default) { (action) in
            self.headerView.textfield.clearTextField()
            self.showShowCaseVC()
        }
        
        let sortIsOn = PersistenceManager.getImpactSort()
        let sortActionTitle = sortIsOn ?    "Turn Off Sort for Impact" : "Turn On Sort for Impact"
        
        let sortAction = UIAlertAction(title: sortActionTitle, style: .default) { (action) in
            PersistenceManager.setImpactSort(!sortIsOn)
            if(self.listView.isDescendant(of: self.contentView)){
                self.charityListVC.sortForImpact()
                self.charityListVC.updateTableView()
            }
        }
        
        if(listView.isDescendant(of: contentView)){
            alertController.addAction(showOverViewAction)
        }
        alertController.addAction(sortAction)
        alertController.addAction(UIAlertAction(title: "Cancel",
                                                style: .cancel,
                                                handler: nil))
        self.present(alertController, animated: true, completion: nil)

        
        if let popoverController = alertController.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
    }
    
    func categoryChanged(category: Category) {
        showListVC()
        headerView.textfield.clearTextField()
        charityListVC.loadInitialCharities(searchParameter: category.parameter)
    }
    
    func searchEntered(input: String?){
        guard let searchInput = input, !searchInput.isEmpty else { return }
        showListVC()
        categoriesView.selectedCategory = nil
        categoriesView.updateCategorySelection()
        charityListVC.loadInitialCharities(searchParameter: "q=\(searchInput)")
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
    
    func finishedLoading(){
        DispatchQueue.main.async {
            self.loadingVC?.dismiss(animated: true)
        }
        
    }
    
    
}


