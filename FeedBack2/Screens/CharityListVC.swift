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
    var charities = [Charity]()
    
    override func viewDidLoad() {
        navigationController?.navigationBar.prefersLargeTitles = true
        configureViewController()
        configureDataSource()
    }
    

    
    private func configureViewController(){
        tableView = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(tableView)
        tableView.backgroundColor = .init(white: 0, alpha: 0)
        tableView.register(CharityCell.self, forCellReuseIdentifier: CharityCell.reuseIdentifier)
        tableView.delegate = self
        tableView.rowHeight = 150
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
        networkManager.getCharities(urlString: "https://app.sogive.org/search.json?q=\(searchParameter)") { [weak self] result in
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
        //charityInfoVC.enteredDonation = enteredDonation
        
        let navigationController = UINavigationController(rootViewController: charityInfoVC)
        
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.navigationBar.barStyle = .black
        present(navigationController, animated: true)
    }
}

