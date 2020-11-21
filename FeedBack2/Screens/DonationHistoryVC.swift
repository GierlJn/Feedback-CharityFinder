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
        getDonations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    fileprivate func getDonations() {
        PersistenceManager.retrieveDonations { [weak self] (result) in
            guard let self = self else { return }
            switch result{
            case .failure(let error):
                self.presentErrorAlert(error)
            case .success(let donations):
                self.donations = donations
            }
        }
    }
    
    fileprivate func configureHeaderView() {
        view.addSubview(headerView)
        
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
        return cell
    }
    
    
}










class HistoryHeaderView: UIView{
    
    var titleLabel = FBTitleLabel(textAlignment: .center)
    var numbersStackView = UIStackView()
    var toggleButton = UIButton()
    
    var totalDonations: Float = 0
    var totalDonationsSum: Float = 0.00
    
    let padding = 20
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        configureTitleLabel()
        configureNumberStackView()
        configureToggleButton()
    }
    
    private func configureTitleLabel(){
        addSubview(titleLabel)
        titleLabel.text = "Your donations"
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(snp.top)
            maker.height.equalTo(50)
            maker.left.equalTo(snp.left).offset(padding)
            maker.right.equalTo(snp.right).offset(-padding)
        }
    }
    
    private func configureNumberStackView(){
        addSubview(numbersStackView)
        numbersStackView.axis = .vertical
        numbersStackView.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom)
            maker.height.equalTo(50)
            maker.left.lessThanOrEqualTo(snp.left).offset(padding)
            maker.right.lessThanOrEqualTo(snp.right).offset(-padding)
            maker.centerX.equalTo(snp.centerX)
        }
        
        let totalLabelView = FBTitleLabel(textAlignment: .center)
        totalLabelView.text = String(totalDonations)
        totalLabelView.textColor = .outputColor
        numbersStackView.addArrangedSubview(totalLabelView)
        
//        let heartIconImageView = UIImageView(image: Images.outputLogoIcon)
//        numbersStackView.addArrangedSubview(heartIconImageView)
//        heartIconImageView.snp.makeConstraints { (maker) in
//            maker.size.equalTo(10)
//        }
//        heartIconImageView.sizeToFit()
        
        let totalDonationsSumLabel = FBSubTitleLabel(textAlignment: .center)
        totalDonationsSumLabel.text = String(totalDonationsSum)
        numbersStackView.addArrangedSubview(totalDonationsSumLabel)
    }
    
    private func configureToggleButton(){
        addSubview(toggleButton)
        toggleButton.setTitle("Toggle View", for: .normal)
        
        toggleButton.snp.makeConstraints { (maker) in
            maker.top.equalTo(numbersStackView.snp.bottom)
            maker.left.equalTo(snp.left).offset(padding)
            maker.right.equalTo(snp.right).offset(-padding)
            maker.bottom.equalTo(snp.bottom)
        }
        
        toggleButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .footnote)
    }
    


}
