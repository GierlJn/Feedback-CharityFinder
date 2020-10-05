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
    
    var tableView: UITableView!
    var dataSource: UITableViewDiffableDataSource<Section, Charity>!
    
    let networkManager = NetworkManager()
    
    var enteredDonation: Float = 0.0
    
    var charities = [Charity]()
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        configureViewController()
        configureDataSource()
        
        getCharities()
    }
    
    private func configureViewController(){
        tableView = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(tableView)
        tableView.backgroundColor = .systemBackground
        tableView.register(CharityCell.self, forCellReuseIdentifier: CharityCell.reuseIdentifier)
        tableView.delegate = self
        tableView.rowHeight = 140
    }
    
    private func configureDataSource(){
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { [weak self](tableView, indexPath, charity) -> UITableViewCell? in
            guard let self = self else  { return nil}
            let cell = tableView.dequeueReusableCell(withIdentifier: CharityCell.reuseIdentifier, for: indexPath) as! CharityCell
            cell.set(charity: charity, enteredDonation: self.enteredDonation)
            return cell
        })
    }
    
    private func getCharities() {
        networkManager.getCharities(urlString: "https://app.sogive.org/search.json?q=high") { [weak self] result in
            guard let self = self else { return }
            switch(result){
            case .failure(let error):
                print(error)
            case .success(let charities):
                self.updateUI(with: charities)
            }
        }
    }
    
    private func updateUI(with charities: [Charity]){
        self.charities = charities
        self.updateData(charities: charities)
    }
    
    private func updateData(charities: [Charity]){
        var snapshot = NSDiffableDataSourceSnapshot<Section, Charity>()
        snapshot.appendSections([.main])
        snapshot.appendItems(charities)
        DispatchQueue.main.async {self.dataSource.apply(snapshot)}
    }
}

extension CharityListVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let charity = charities[indexPath.item]
        let charityInfoVC = CharityInfoVC()
        charityInfoVC.charity = charity
        
        let navigationController = UINavigationController(rootViewController: charityInfoVC)
        present(navigationController, animated: true)
    }
}

