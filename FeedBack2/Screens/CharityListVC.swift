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
    
    let testData = [Charity(name: "Test1"), Charity(name: "Test2"), Charity(name: "Test3")]
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        configureViewController()
        configureDataSource()
        updateData(charities: testData)
    }
    
    private func configureViewController(){
        tableView = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(tableView)
        tableView.backgroundColor = .systemBackground
        tableView.register(CharityCell.self, forCellReuseIdentifier: CharityCell.reuseIdentifier)
        tableView.delegate = self
        tableView.rowHeight = 150
    }
    
    private func configureDataSource(){
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, charity) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: CharityCell.reuseIdentifier, for: indexPath) as! CharityCell
            cell.set(charity: charity)
            return cell
        })
    }
    
    private func updateData(charities: [Charity]){
        var snapshot = NSDiffableDataSourceSnapshot<Section, Charity>()
        snapshot.appendSections([.main])
        snapshot.appendItems(charities)
        DispatchQueue.main.async {self.dataSource.apply(snapshot)}
    }
}

extension CharityListVC: UITableViewDelegate{
}

