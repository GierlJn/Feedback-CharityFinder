//
//  CharityInfoVC.swift
//  FeedBack2
//
//  Created by Julian Gierl on 04.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit
import SnapKit

class CharityInfoVC: UIViewController{
    
    var logoImageView = FBLogoImageView(frame: .zero)
    var impactImageView = FBImpactImageView(frame: .zero)
    var descriptionLabel = FBBodyLabel(textAlignment: .left)
    var titleLabel = FBTitleLabel(textAlignment: .left)

    let scrollView = UIScrollView()
    let contentView = UIView()
    
    var charityId: String = ""
    var networkManger = NetworkManager()
    var charity: Charity!

    
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        title = charity.name
        configureScrollView()
        getCharityInfo()
    }
    
    private func configureScrollView(){
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.pinToEdges(of: self.view)
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
                self.configureLogoImageView()
                self.configureImpactImageView(infoCharity)
                self.configureTitleLabel()
                self.configureDescriptionLabel(infoCharity)
                }
            }
        }
    }
    
    private func configureLogoImageView(){
        contentView.addSubview(logoImageView)
        logoImageView.setLogoImage(logoUrl: charity.logoUrl)
        logoImageView.layer.cornerRadius = 20
        logoImageView.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(50)
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
        }
    }
    
    private func configureImpactImageView(_ infoCharity: InfoCharity){
            self.contentView.addSubview(self.impactImageView)
            self.contentView.bringSubviewToFront(self.logoImageView)
            if (infoCharity.imageUrl != nil){
                self.impactImageView.setImage(imageUrl: infoCharity.imageUrl!)
            }
            
            self.impactImageView.snp.makeConstraints { (make) in
                make.left.equalTo(self.view.snp.left)
                make.right.equalTo(self.view.snp.right)
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
                make.height.equalTo(150)
            }
    }
    
    private func configureTitleLabel(){
        contentView.addSubview(titleLabel)
        titleLabel.text = charity.name
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(impactImageView.snp.bottom).offset(10)
            maker.left.equalTo(contentView.snp.left).offset(20)
            maker.right.equalTo(contentView.snp.right).offset(-20)
            maker.height.equalTo(60)
        }
    }
    
    private func configureDescriptionLabel(_ infoCharity: InfoCharity){
        contentView.addSubview(descriptionLabel)
        descriptionLabel.text = infoCharity.description
        descriptionLabel.numberOfLines = 0
        descriptionLabel.sizeToFit()
        descriptionLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom).offset(5)
            maker.left.equalTo(contentView.snp.left).offset(20)
            maker.right.equalTo(contentView.snp.right).offset(-20)
        }
    }
    
}
