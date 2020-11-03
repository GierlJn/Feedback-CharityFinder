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
    var dataSource: UITableViewDiffableDataSource<Section, Charity>!
    var charities = [Charity]()
    
    override func viewDidLoad() {
        configureTableViewController()
        configureDataSource()
    }
    
    private func configureTableViewController(){
        view.addSubview(tableView)
        tableView.pinToEdges(of: view)
        tableView.backgroundColor = .init(white: 0, alpha: 0 )
        tableView.register(CharityCell.self, forCellReuseIdentifier: CharityCell.reuseIdentifier)
        tableView.delegate = self
        tableView.rowHeight = 120
        tableView.removeExcessCells()
    }
    
    private func configureDataSource(){
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, charity) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: CharityCell.reuseIdentifier, for: indexPath) as! CharityCell
            cell.set(charity: charity)
            return cell
        })
    }
    
    func getCharities(searchParameter: String) {
        NetworkManager.shared.getCharities(searchParameter: searchParameter, size: 20) { [weak self] result in
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
        self.updateData()
    }
    
    private func updateData(){
        var snapshot = NSDiffableDataSourceSnapshot<Section, Charity>()
        snapshot.appendSections([.main])
        snapshot.appendItems(charities)
        DispatchQueue.main.async {self.dataSource.apply(snapshot)}
    }
    
    func sortForImpact(){
        self.charities.sort { (charity1, charity2) -> Bool in
            guard let impact1 = ImpactEstimation(rawValue: charity1.impactEstimation ?? "none") else { return false }
            guard let impact2 = ImpactEstimation(rawValue: charity2.impactEstimation ?? "none") else { return false}
            return impact1.getSortingRank > impact2.getSortingRank
        }
        self.updateData()
    }
}

extension CharityListVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let charity = charities[indexPath.item]
        let charityInfoVC = CharityInfoVC()
        charityInfoVC.charityId = charity.id
        charityInfoVC.charity = charity
        let navigationController = UINavigationController(rootViewController: charityInfoVC)
        
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.navigationBar.barStyle = .black
        present(navigationController, animated: true)
    }
    
    
}

