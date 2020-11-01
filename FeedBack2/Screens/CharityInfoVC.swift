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
    var tagView = TagLabelScrollView(color: .lightGray)
    var locationTagView = TagLabelScrollView(color: .systemGray)
    
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    var charityId: String!
    var enteredDonation: Float = 1.0

    var infoCharity: InfoCharity?
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
            maker.height.equalTo(100)
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
        NetworkManager.shared.getCharityInfo(charityId: charityId) { [weak self] (result) in
            guard let self = self else { return }
            switch(result){
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong!", message: error.errorMessage, buttonTitle: "Ok")
            case .success(let infoCharity):
                DispatchQueue.main.async {
                    self.impactImageView.setImage(imageUrl: infoCharity.imageUrl) { (error) in
                            self.hideLoadingView()
                            self.infoCharity = infoCharity
                            self.configureViews()
                        }
                }
            }
        }
    }
    
    private func configureViews() {
        guard let infoCharity = infoCharity else { return }
        addRightBarButtonItem()
        configureDonationBarView()
        configureImpactImageView(infoCharity)
        configureScrollView()
        configureTitleLabelView(infoCharity)
        configureTagView(infoCharity)
        configureLocationTagView(infoCharity)
        configureAboutHeaderLabel()
        configureDescriptionLabel(infoCharity)
        configureOutputOverviewStackView(infoCharity)
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
    
    private func configureTitleLabelView(_ infoCharity: InfoCharity){
        self.view.addSubview(charityTitleLabelView)
        charityTitleLabelView.set(title: infoCharity.name)
        charityTitleLabelView.delegate = self
        PersistenceManager.isCharityFavorite(charity: charity) { (isFavourite) in
            self.charityTitleLabelView.isFavourite = isFavourite
        }
        charityTitleLabelView.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(impactImageView.snp.bottom)
            maker.left.equalTo(self.view.snp.left)
            maker.right.equalTo(self.view.snp.right).offset(-16)
            maker.height.equalTo(50)
        }
    }
    
    private func configureTagView(_ infoCharity: InfoCharity){
        contentView.addSubview(tagView)
        tagView.set(tags: infoCharity.tags!)
        tagView.snp.makeConstraints { (maker) in
            maker.height.equalTo(30)
            maker.top.equalTo(contentView.snp.top).offset(45)
            maker.left.equalTo(contentView.snp.left).offset(20)
            maker.right.equalTo(contentView.snp.right).offset(-20)
        }
    }
    
    private func configureLocationTagView(_ infoCharity: InfoCharity){
        contentView.addSubview(locationTagView)
        locationTagView.set(tags: infoCharity.geoTags!)
        locationTagView.snp.makeConstraints { (maker) in
            maker.height.equalTo(30)
            maker.top.equalTo(tagView.snp.bottom).offset(10)
            maker.left.equalTo(contentView.snp.left).offset(20)
            maker.right.equalTo(contentView.snp.right).offset(-20)
        }
    }
    
    private func configureAboutHeaderLabel(){
        contentView.addSubview(aboutHeaderLabel)
        aboutHeaderLabel.text = "About Charity"
        aboutHeaderLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(locationTagView.snp.bottom).offset(25)
            maker.left.equalTo(contentView.snp.left).offset(20)
            maker.right.equalTo(contentView.snp.right).offset(-20)
            maker.height.equalTo(50)
        }
    }
    
    private func configureDescriptionLabel(_ infoCharity: InfoCharity){
        let summaryDescription = infoCharity.summaryDescription ?? ""
        let description = infoCharity.description ?? ""
        var labelText = ""
        
        if(!summaryDescription.isEmpty){
            labelText.append(summaryDescription)
        }
        
        if(!summaryDescription.isEmpty && !description.isEmpty){
            labelText.append("\n\n" + description)
        }
        
        if(summaryDescription.isEmpty && !description.isEmpty){
            labelText.append(description)
        }
        
        if(description.isEmpty && summaryDescription.isEmpty){
            labelText = "No description available"
        }
        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.text = labelText
        
        descriptionLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(aboutHeaderLabel.snp.bottom)
            maker.left.equalTo(contentView.snp.left).offset(20)
            maker.right.equalTo(contentView.snp.right).offset(-20)
        }
        descriptionLabel.sizeToFit()
    }
    
    private func configureOutputOverviewStackView(_ infoCharity: InfoCharity){
        guard let impact = infoCharity.singleImpact else { return }
        outputOverviewStackView.set(outputs: [impact])
        contentView.addSubview(outputOverviewStackView)
        outputOverviewStackView.snp.makeConstraints { (maker) in
            maker.height.equalTo(30)
            maker.top.equalTo(descriptionLabel.snp.bottom).offset(50)
            maker.left.equalTo(contentView.snp.left).offset(20)
            maker.right.equalTo(contentView.snp.right).offset(-20)
        }
    }
    
    @objc func backButtonPressed(){
        self.dismiss(animated: true)
    }
    
    @objc func accessoryButtonPressed(){
       
        
    }
    
    
}

extension CharityInfoVC: TitleLabelViewDelegate{
    func favouriteButtonPressed() {
        PersistenceManager.isCharityFavorite(charity: charity) { [self] (isFavourite) in
            if (isFavourite){
                PersistenceManager.updateFavorites(charity: charity, persistenceActionType: .remove) { (error) in
                    if ((error) != nil){
                        presentGFAlertOnMainThread(title: "Error", message: error!.errorMessage, buttonTitle: "Ok")
                    }
                    else{
                        charityTitleLabelView.isFavourite = false
                        presentGFAlertOnMainThread(title: "Removed", message: "\(charity.name) has been removed from your favorites", buttonTitle: "Ok")
                        
                    }
                }
            }else{
                PersistenceManager.updateFavorites(charity: charity, persistenceActionType: .add) { (error) in
                    if ((error) != nil){
                        presentGFAlertOnMainThread(title: "Error", message: error!.errorMessage, buttonTitle: "Ok")
                    }
                    else{
                        charityTitleLabelView.isFavourite = true
                        presentGFAlertOnMainThread(title: "Added", message: "\(charity.name) has been added to your favorites", buttonTitle: "Ok")
                    }
                }
            }
            
            
        }
        
    }
    
    
}

extension CharityInfoVC: DonationBarViewDelegate{
    func donationButtonPressed() {
        guard let infoCharity = infoCharity, let url = URL(string: infoCharity.url!) else { return }
        presentSafariVC(with: url)
    }
}
