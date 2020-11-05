//
//  SearchVC.swift
//  FeedBack2
//
//  Created by Julian Gierl on 30.09.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

class FavouritesVC: UIViewController{
    
    var charities = [Charity]()
    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureTableView()
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        loadFavorites()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.setGradientBackgroundColor(colors: [.lightBlueBackgroundGradientStart, .lightBlueBackgroundGradientEnd], axis: .horizontal)
    }
    
    fileprivate func loadFavorites() {
        PersistenceManager.retrieveFavorites { [weak self] (result) in
            guard let self = self else { return }
            switch result{
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Error", message: error.errorMessage, buttonTitle: "Ok")
            case .success(let charities):
                self.charities = charities
                self.updateUI()
            }
        }
    }
    
    private func configureTableView(){
        view.addSubview(tableView)
        tableView.pinToEdges(of: view)
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        tableView.removeExcessCells()
        tableView.backgroundColor = .init(white: 0, alpha: 0)
        
    }
    
    private func updateUI(){
        tableView.reloadData()
        if (charities.isEmpty) {
            view.showEmptyView("You don't have any favorites yet")
        }else{
            view.hideEmptyView()
        }
    }
    
}


extension FavouritesVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        charities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseIdentifier) as! FavoriteCell
        cell.set(charity: charities[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let charity = charities[indexPath.row]
        let charityInfoVc = CharityInfoVC()
        charityInfoVc.charity = charity
        charityInfoVc.charityId = charity.id
        let navigationController = UINavigationController(rootViewController: charityInfoVc)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.navigationBar.barStyle = .black
        present(navigationController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        PersistenceManager.updateFavorites(charity: charities[indexPath.row], persistenceActionType: .remove) { [weak self](error) in
            guard let self = self else { return }
            guard let error = error else{
                self.charities.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .left)
                return
            }
            
            self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.errorMessage, buttonTitle: "Ok")
        }
        
    }
    
}
