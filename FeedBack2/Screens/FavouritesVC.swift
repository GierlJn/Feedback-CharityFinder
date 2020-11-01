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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        loadFavorites()
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
        tableView.rowHeight = 80
        tableView.removeExcessCells()
        
    }
    
    private func updateUI(){
        tableView.reloadData()
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
    
}
