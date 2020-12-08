//
//  CharityListVC.swift
//  FeedBack2
//
//  Created by Julian Gierl on 30.09.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

class CharityListVC: UIViewController{
    
    var tableView = UITableView()
    var contentView = UIView()
    let emptyStateView = EmptyStateView(title: "Your search didn't find anything")
    var charities = [Charity]()
    let networkManager = NetworkManager()
    var containerView: UIView?
    
    var startFetchIndex = 0
    var isLoading = false
    
    var charitiesLeftDownload = true
    
    var searchParameter: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContentView()
        configureTableViewController()
    }
    
    private func configureContentView(){
        view.addSubview(contentView)
        contentView.pinToEdges(of: view)
    }
    
    private func configureTableViewController(){
        showTableViewController()
        tableView.backgroundColor = .init(white: 0, alpha: 0 )
        tableView.register(CharityCell.self, forCellReuseIdentifier: CharityCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 120
        let footerView = FooterSupplementaryView()
        footerView.delegate = self
        tableView.tableFooterView = footerView
    }
    
    func loadInitialCharities(searchParameter: String) {
        resetQueryData(searchParameter)
        showLoadingState()
        networkManager.getCharities(searchParameter: self.searchParameter!, size: 15, startFrom: 0) { [weak self] result in
            guard let self = self else { return }
            switch(result){
            
            case .failure(let error):
                switch error{
                case .unableToConnect:
                    self.hideLoadingSubView(in: self.contentView)
                    self.presentErrorAlert(error)
                case .userCancelled:
                    return
                default:
                    DispatchQueue.main.async {
                        self.hideLoadingSubView(in: self.contentView)
                        self.showEmptyStateView()
                    }
                }
                
            case .success(let charities):
                DispatchQueue.main.async {
                    self.tableView.isHidden = false
                    self.hideLoadingSubView(in: self.contentView)
                    self.showTableViewController()
                    self.setInitialCharities(with: charities)
                }
            }
            self.isLoading = false
        }
    }
    
    fileprivate func resetQueryData(_ searchParameter: String) {
        charities = [Charity]()
        self.startFetchIndex = 0
        self.searchParameter = searchParameter
        networkManager.cancelCurrentTasks()
    }
    
    fileprivate func showLoadingState() {
        tableView.isHidden = true
        removeEmptyStateView()
        isLoading = true
        showLoadingSubView(in: self.contentView)
    }
    
    func loadAdditionalCharities() {
        isLoading = true
        networkManager.getCharities(searchParameter: self.searchParameter!, size: 15, startFrom: self.startFetchIndex) { [weak self] result in
            guard let self = self else { return }
            switch(result){
            case .failure(let error):
                print(error.errorMessage)
            case .success(let charities):
                DispatchQueue.main.async {
                    self.updateUI(with: charities)
                }
            }
            self.isLoading = false
        }
    }
    
    private func setInitialCharities(with charities: [Charity]){
        self.charities = charities
        charitiesLeftDownload = true
        self.updateTableView()
        if(PersistenceManager.isSortActivated){
            sortForImpact()
        }
        if (self.charities.isEmpty) {
            self.showEmptyStateView()
        }else{
            scrollToTop()
        }
    }
    
    private func updateUI(with charities: [Charity]){
        self.charities.append(contentsOf: charities)
        if(charities.isEmpty){
            charitiesLeftDownload = false
        }
        updateTableView()
    }
    
    func updateTableView(){
        tableView.reloadData()
    }
    
    func sortForImpact(){
        let impactEst: [String:Int] = ["none":1, "low":2, "medium":3, "high":4]
        
        self.charities.sort { (charity1, charity2) -> Bool in
            return impactEst[charity1.impactEstimation ?? "none", default: 1] > impactEst[charity2.impactEstimation ?? "none", default: 1]
        }
    }
    
    fileprivate func scrollToTop() {
        DispatchQueue.main.async {
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }
    
    private func showTableViewController(){
        DispatchQueue.main.async {
            if(self.emptyStateView.isDescendant(of: self.view)){
                self.emptyStateView.removeFromSuperview()
            }
            
            if(!self.tableView.isDescendant(of: self.view)){
                self.view.addSubview(self.tableView)
                self.tableView.pinToEdges(of: self.contentView)
            }
        }
    }
    
    private func showEmptyStateView(){
        DispatchQueue.main.async {
            if(self.tableView.isDescendant(of: self.view)){
                self.tableView.removeFromSuperview()
            }
            
            if(!self.emptyStateView.isDescendant(of: self.view)){
                self.contentView.addSubview(self.emptyStateView)
                self.emptyStateView.pinToEdges(of: self.contentView)
                self.emptyStateView.isHidden = false
            }
        }
    }
    
    private func removeEmptyStateView(){
        if(emptyStateView.isDescendant(of: view)){
            emptyStateView.removeFromSuperview()
        }
    }
}

extension CharityListVC: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        charities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(charities.isEmpty){ return UITableViewCell() }
        let charity = charities[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: CharityCell.reuseIdentifier) as! CharityCell
        cell.set(charity: charity)
        return cell
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height{
            guard !isLoading, self.searchParameter != nil, charitiesLeftDownload else { return }
            startFetchIndex += 15
            loadAdditionalCharities()
        }
    }
}

extension CharityListVC: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let charity = charities[indexPath.item]
        let charityInfoVC = CharityInfoVC()
        charityInfoVC.charityId = charity.id
        charityInfoVC.charity = charity
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        networkManager.cancelCurrentTasks()
        hideLoadingSubView(in: contentView)
        
        let navigationController = UINavigationController(rootViewController: charityInfoVC)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.navigationBar.barStyle = .black
        present(navigationController, animated: true)
    }
}

extension CharityListVC: FooterSupplementaryViewDelegate{
    
    func buttonPressed() {
        DispatchQueue.main.async {
            let fbAlertVC = FBAlertVC(title: "Notice", message: "This will open a link in your browser", actionButtonTitle: "Ok", dismissButtonTitle: "Cancel"){ [weak self] in
                guard let self = self else { return }
                self.presentSafariVC(with: URLS.soGiveUrl)
            }
            fbAlertVC.modalPresentationStyle = .overFullScreen
            fbAlertVC.modalTransitionStyle = .crossDissolve
            self.present(fbAlertVC, animated: true)
        }
    }
}

