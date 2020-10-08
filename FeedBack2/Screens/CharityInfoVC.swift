//
//  CharityInfoVC.swift
//  FeedBack2
//
//  Created by Julian Gierl on 04.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit
import SnapKit

protocol DonationBarViewDelegate {
    func donationButtonPressed()
}

class CharityInfoVC: UIViewController{

    var impactImageView = FBImpactImageView(frame: .zero)
    var descriptionLabel = FBTextView(textAlignment: .left)
    var charityTitleLabelView = CharityTitleLabelView()
    var donationBarView = DonationBarView()
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    var charityId: String = ""
    var enteredDonation: Float = 1.0
    
    var networkManger = NetworkManager()
    var charity: Charity!
    
    
    override func viewDidLoad() {
        view.setGradientBackgroundColor(colors: [.lightBlueBackgroundGradientStart, .lightBlueBackgroundGradientEnd], axis: .horizontal)
        configureNavigationBar()
        
        configureDonationBarView()
        configureScrollView()
        getCharityInfo()
    }
    
    private func configureNavigationBar(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left.square.fill"), style: .plain, target: self, action: #selector(backButtonPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: self, action: #selector(accessoryButtonPressed))
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureDonationBarView(){
        view.addSubview(donationBarView)
        donationBarView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view.snp.left)
            maker.right.equalTo(self.view.snp.right)
            maker.bottom.equalTo(self.view.snp.bottom)
            maker.height.equalTo(80)
        }
        donationBarView.actionButton.setGradientBackgroundColor(colors: [.buttonDarkBlueGradientStart, .buttonDarkBlueGradientEnd], axis: .horizontal, cornerRadius: 7)
    }
    
    private func configureScrollView(){
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.view.snp.top)
            maker.left.equalTo(self.view.snp.left)
            maker.right.equalTo(self.view.snp.right)
            maker.bottom.equalTo(donationBarView.snp.top)
        }
        
        contentView.pinToEdges(of: scrollView)
        contentView.snp.makeConstraints { (maker) in
            maker.width.equalTo(scrollView.snp.width)
            maker.height.equalTo(600)
        }
    }
    
    private func getCharityInfo() {
        let url = "https://app.sogive.org/charity/" + charity.id + ".json"
        networkManger.getCharityInfo(urlString: url) { [weak self] (result) in
            guard let self = self else { return }
            switch(result){
            case .failure(let error):
                print(error)
            case .success(let infoCharity):
                DispatchQueue.main.async {
                    self.configureViews(with: infoCharity)
                }
            }
        }
    }
    
    private func configureViews(with infoCharity: InfoCharity) {
        self.configureImpactImageView(infoCharity)
        self.configureTitleLabelView()
        self.configureDescriptionLabel(infoCharity)
    }

    
    private func configureImpactImageView(_ infoCharity: InfoCharity){
        self.contentView.addSubview(self.impactImageView)
        if (infoCharity.imageUrl != nil){
            self.impactImageView.setImage(imageUrl: infoCharity.imageUrl!)
        }else{
            self.impactImageView.setImage(imageUrl: charity.logoUrl)
            //self.logoImageView.isHidden = true
        }
        
        self.impactImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.top.equalTo(self.view.snp.top)
            make.height.equalTo(200)
        }
    }
    
    private func configureTitleLabelView(){
        contentView.addSubview(charityTitleLabelView)
        charityTitleLabelView.set(title: charity.name)
        charityTitleLabelView.backgroundColor = .white
        charityTitleLabelView.layer.cornerRadius = 7
        
        charityTitleLabelView.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(impactImageView.snp.bottom)
            maker.width.equalTo(400)
            maker.height.equalTo(60)
            maker.right.equalTo(contentView.snp.right).offset(-16)
        }
        
//        contentView.addSubview(titleLabel)
//        titleLabel.text = charity.name
//        titleLabel.snp.makeConstraints { (maker) in
//            maker.top.equalTo(impactImageView.snp.bottom).offset(10)
//            maker.left.equalTo(contentView.snp.left).offset(20)
//            maker.right.equalTo(contentView.snp.right).offset(-20)
//            maker.height.equalTo(60)
//        }
    }
    
    private func configureDescriptionLabel(_ infoCharity: InfoCharity){
        contentView.addSubview(descriptionLabel)
        descriptionLabel.text = infoCharity.description
        //descriptionLabel.backgroundColor = .init(white: 0, alpha: 0)
        //descriptionLabel.isOpaque = false
        descriptionLabel.sizeToFit()
        descriptionLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(charityTitleLabelView.snp.bottom).offset(16)
            maker.left.equalTo(contentView.snp.left).offset(20)
            maker.right.equalTo(contentView.snp.right).offset(-20)
            maker.bottom.equalTo(contentView.snp.bottom).offset(-15)
        }
    }
    
    @objc func backButtonPressed(){
        self.dismiss(animated: true)
    }
    
    @objc func accessoryButtonPressed(){
        
    }
    
    
}

extension CharityInfoVC: DonationBarViewDelegate{
    func donationButtonPressed() {
        guard let url = URL(string: charity.url) else {
            print("error")
            #warning("handle error")
            return
        }
        presentSafariVC(with: url)
    }
}
