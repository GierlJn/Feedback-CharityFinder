//
//  CharityListVC.swift
//  FeedBack2
//
//  Created by Julian Gierl on 30.09.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

class CharityListVC: UIViewController{
    
    enum Section{
        case main
    }
    
    var tableView = UITableView()
    var contentView = UIView()
    let emptyStateView = EmptyStateView(title: "Your search didn't find anything")
    var charities = [Charity]()
    let networkManager = NetworkManager()
    var containerView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContentView()
        configureTableViewController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
//        networkManager.cancelCurrentTasks()
//        hideLoadingSubView(in: contentView)
    }
    
    private func configureContentView(){
        view.addSubview(contentView)
        contentView.pinToEdges(of: view)
    }
    
    private func configureTableViewController(){
        addTableViewController()
        tableView.backgroundColor = .init(white: 0, alpha: 0 )
        tableView.register(CharityCell.self, forCellReuseIdentifier: CharityCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 120
        let footerView = FooterView()
        footerView.delegate = self
        tableView.tableFooterView = footerView
        
        
        //tableView.removeExcessCells()
    }
    
    private func addTableViewController(){
        if(emptyStateView.isDescendant(of: view)){
            emptyStateView.removeFromSuperview()
        }
        
        if(!tableView.isDescendant(of: view)){
            view.addSubview(tableView)
            tableView.pinToEdges(of: contentView)
        }
    }
    
    private func addEmptyStateView(){
        if(tableView.isDescendant(of: view)){
            tableView.removeFromSuperview()
        }
        
        if(!emptyStateView.isDescendant(of: view)){
            contentView.addSubview(emptyStateView)
            emptyStateView.pinToEdges(of: contentView)
            emptyStateView.isHidden = false
        }
    }
    
    private func hideEmptyStateView(){
        emptyStateView.isHidden = true
        if(emptyStateView.isDescendant(of: view)){
            emptyStateView.removeFromSuperview()
        }
    }

    
    func getCharities(searchParameter: String) {
        networkManager.cancelCurrentTasks()
        showLoadingSubView(in: self.contentView)
        tableView.isHidden = true
        hideEmptyStateView()
        networkManager.getCharities(searchParameter: searchParameter, size: 15) { [weak self] result in
            guard let self = self else { return }
            
            switch(result){

            case .failure(let error):
                if(error == .unableToConnect){
                    self.hideLoadingSubView(in: self.contentView)
                    self.presentErrorAlert(error: error)
                }else if(error == .userCancelled){
                    DispatchQueue.main.async {
                        //self.tableView.isHidden = false
                    }
                    return 
                }else{
                    DispatchQueue.main.async {
                        self.hideLoadingSubView(in: self.contentView)
                        self.addEmptyStateView()
                    }
                }
            case .success(let charities):
                DispatchQueue.main.async {
                    self.tableView.isHidden = false
                    self.hideLoadingSubView(in: self.contentView)
                    self.addTableViewController()
                    self.updateUI(with: charities)
                }

            }
        }
    }
    
    private func updateUI(with charities: [Charity]){
        self.charities = charities
        
        let isOn = PersistenceManager.getImpactSort()
        if(isOn){
            sortForImpact()
        }
        self.updateData()
        if (charities.isEmpty) {
            self.addEmptyStateView()
        }else{
            scrollToTop()
        }
        
    }
    
    func updateData(){
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
}

extension CharityListVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        charities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let charity = charities[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: CharityCell.reuseIdentifier) as! CharityCell
        cell.set(charity: charity)
        return cell
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

extension CharityListVC: FooterViewDelegate{
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

