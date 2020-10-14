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
    var descriptionLabel = FBTextLabel()
    var charityTitleLabelView = CharityTitleLabelView()
    var donationBarView = DonationBarView()
    var outputOverviewStackView = OutputOverViewContainerView()
    var aboutHeaderLabel = FBTitleLabel(textAlignment: .left)
    var tagView = TagView()
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    var charityId: String = ""
    var enteredDonation: Float = 1.0
    
    var networkManger = NetworkManager()
    var charity: Charity!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        getCharityInfo()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.setGradientBackgroundColor(colors: [.lightBlueBackgroundGradientStart, .lightBlueBackgroundGradientEnd], axis: .horizontal)
    }
    
    private func configureNavigationBar(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left.square.fill"), style: .plain, target: self, action: #selector(backButtonPressed))
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
    }
    
    private func configureScrollView(){
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { (maker) in
            maker.top.equalTo(impactImageView.snp.bottom)
            maker.left.equalTo(self.view.snp.left)
            maker.right.equalTo(self.view.snp.right)
            maker.bottom.equalTo(donationBarView.snp.top)
        }
        
        contentView.pinToEdges(of: scrollView)
        contentView.snp.makeConstraints { (maker) in
            maker.width.equalTo(scrollView.snp.width)
            maker.height.equalTo(500)
        }
    }
    
    private func getCharityInfo() {
        showLoadingView()
        let url = "https://app.sogive.org/charity/" + charity.id + ".json"
        networkManger.getCharityInfo(urlString: url) { [weak self] (result) in
            guard let self = self else { return }
            switch(result){
            case .failure(let error):
                print(error)
            case .success(let infoCharity):
                DispatchQueue.main.async {
                    self.impactImageView.setImage(imageUrl: infoCharity.imageUrl) { (error) in
                            self.hideLoadingView()
                            self.configureViews(with: infoCharity)
                        }
                }
            }
        }
    }
    
    private func configureViews(with infoCharity: InfoCharity) {
        addRightBarButtonItem()
        configureDonationBarView()
        configureImpactImageView(infoCharity)
        configureScrollView()
        configureTitleLabelView()
        configureTagView(infoCharity)
        configureOutputOverviewStackView()
        configureAboutHeaderLabel()
        configureDescriptionLabel(infoCharity)
    }
    
    private func addRightBarButtonItem(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: self, action: #selector(accessoryButtonPressed))
    }

    
    private func configureImpactImageView(_ infoCharity: InfoCharity){
        self.view.addSubview(self.impactImageView)
        
        self.impactImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.top.equalTo(self.view.snp.top)
            make.height.equalTo(200)
        }
        
    }
    
    private func configureTitleLabelView(){
        self.view.addSubview(charityTitleLabelView)
        charityTitleLabelView.set(title: charity.name)

        
        charityTitleLabelView.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(impactImageView.snp.bottom)
            maker.left.equalTo(self.view.snp.left)
            maker.right.equalTo(self.view.snp.right).offset(-16)
            maker.height.equalTo(50)
        }
    }
    
    private func configureTagView(_ infoCharity: InfoCharity){
        contentView.addSubview(tagView)
        tagView.set(tags: infoCharity.tags)
        tagView.snp.makeConstraints { (maker) in
            maker.height.equalTo(25)
            maker.top.equalTo(contentView.snp.top).offset(45)
            maker.left.equalTo(contentView.snp.left).offset(20)
            maker.right.equalTo(contentView.snp.right).offset(-20)
        }
    }
    
    private func configureOutputOverviewStackView(){
        outputOverviewStackView.set(outputs: [charity.mainOutput])
        contentView.addSubview(outputOverviewStackView)
        outputOverviewStackView.snp.makeConstraints { (maker) in
            maker.height.equalTo(30)
            maker.top.equalTo(tagView.snp.bottom).offset(25)
            maker.left.equalTo(contentView.snp.left).offset(20)
            maker.right.equalTo(contentView.snp.right).offset(-20)
        }
    }
    
    private func configureAboutHeaderLabel(){
        contentView.addSubview(aboutHeaderLabel)
        aboutHeaderLabel.text = "About Charity"
        aboutHeaderLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(outputOverviewStackView.snp.bottom).offset(16)
            maker.left.equalTo(contentView.snp.left).offset(20)
            maker.right.equalTo(contentView.snp.right).offset(-20)
            maker.height.equalTo(50)
        }
    }
    
    private func configureDescriptionLabel(_ infoCharity: InfoCharity){
        contentView.addSubview(descriptionLabel)
        descriptionLabel.text = infoCharity.description
        descriptionLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(aboutHeaderLabel.snp.bottom)
            maker.left.equalTo(contentView.snp.left).offset(20)
            maker.right.equalTo(contentView.snp.right).offset(-20)
        }
        descriptionLabel.sizeToFit()
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
