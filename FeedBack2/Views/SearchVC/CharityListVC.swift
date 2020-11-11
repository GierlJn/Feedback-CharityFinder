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
        configureContentView()
        configureTableViewController()
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
        
        tableView.removeExcessCells()
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
        }
    }

    
    func getCharities(searchParameter: String) {
        networkManager.cancelCurrentTasks()
        showLoadingIndicatorView()
        networkManager.getCharities(searchParameter: searchParameter, size: 15) { [weak self] result in
            guard let self = self else { return }
            self.hideLoadingIndicatorView()
            switch(result){

            case .failure(let error):
                if(error == .unableToConnect){
                    self.presentErrorAlert(error: error)
                }else if(error == .userCancelled){
                    return 
                }else{
                    DispatchQueue.main.async {
                        self.addEmptyStateView()
                    }
                }
            case .success(let charities):
                DispatchQueue.main.async {
                    self.addTableViewController()
                    self.updateUI(with: charities)
                }

            }
        }
    }
    
    func showLoadingIndicatorView(){
        guard  containerView == nil else { return }
        containerView = UIView()
        contentView.addSubview(containerView!)
        containerView!.pinToEdges(of: view)
        containerView!.alpha = 1
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        containerView!.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(containerView!.snp.centerX)
            maker.centerY.equalTo(containerView!.snp.centerY)
        }
        loadingIndicator.startAnimating()
    }
    
    func hideLoadingIndicatorView(){
        DispatchQueue.main.async {
            if(self.containerView != nil){
                self.containerView!.removeFromSuperview()
                self.containerView = nil
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
        
        let navigationController = UINavigationController(rootViewController: charityInfoVC)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.navigationBar.barStyle = .black
        present(navigationController, animated: true)
    }
    
    
}

