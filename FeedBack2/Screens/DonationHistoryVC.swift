//
//  DonationHistoryVC.swift
//  FeedBack
//
//  Created by Julian Gierl on 20.11.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

class DonationHistoryVC: UIViewController{
    
    let headerView = HistoryHeaderView()
    let padding = 20
    
    var tableView = UITableView()
    var donations = [Donation]()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        getDonations()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.setGradientBackgroundColor(colors: [.lightBlueBackgroundGradientStart, .lightBlueBackgroundGradientEnd], axis: .horizontal)
    }
    
    fileprivate func getDonations() {
        PersistenceManager.retrieveDonations { [weak self] (result) in
            guard let self = self else { return }
            switch result{
            case .failure(let error):
                self.presentErrorAlert(error)
            case .success(let donations):
                self.donations = donations
                self.tableView.reloadData()
                self.headerView.updateUI(with: donations)
            }
        }
    }
    
    fileprivate func configureHeaderView() {
        view.addSubview(headerView)
        headerView.backgroundColor = .init(white: 0, alpha: 0)
        headerView.applyViewShadow()
        headerView.snp.makeConstraints { (maker) in
            maker.height.equalTo(140)
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            maker.left.equalTo(view.snp.left)
            maker.right.equalTo(view.snp.right)
        }
    }
    
    fileprivate func configureTableView() {
        tableView.dataSource = self
        tableView.register(DonationCell.self, forCellReuseIdentifier: DonationCell.reuseIdentifier)
        tableView.rowHeight = 80
        tableView.backgroundColor = .init(white: 0, alpha: 0)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (maker) in
            maker.top.equalTo(headerView.snp.bottom)
            maker.left.equalTo(view.snp.left)
            maker.right.equalTo(view.snp.right)
            maker.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        tableView.removeExcessCells()
    }
    
    private func configure(){
        configureHeaderView()
        configureTableView()
    }
    
}

extension DonationHistoryVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        donations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DonationCell.reuseIdentifier) as! DonationCell
        cell.set(donation: donations[indexPath.row])
        return cell
    }
}

