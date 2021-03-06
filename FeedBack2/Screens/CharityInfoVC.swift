//
//  CharityInfoVC.swift
//  FeedBack2
//
//  Created by Julian Gierl on 04.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit
import FacebookShare
import SnapKit

protocol DonationBarViewDelegate {
    func donationButtonPressed()
}

final class CharityInfoVC: UIViewController{
    
    var impactImageView = FBImpactImageView(frame: .zero)
    var descriptionLabel = FBTextLabel()
    var charityTitleLabelView = CharityTitleLabelView()
    let donateButton = UIButton()
    var outputView: OutputView?
    var aboutHeaderLabel = FBTitleLabel(textAlignment: .left)
    var tagView = TagLabelScrollView(color: .whyTagView)
    var locationTagView = TagLabelScrollView(color: .locationTagView)
    var contentSuperView = UIView()
    var calculationVC: OutputCalculationVC?
    let scrollView = UIScrollView()
    let contentView = UIView()
    var socialMediaStackView = SocialMediaStackView()
    
    var infoCharity: InfoCharity?
    var charity: Charity!
    var charityId: String!
    
    let networkManager = NetworkManager()
    var contentHeight: CGFloat = 70.0
    let padding: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        getCharityInfo()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateGradients()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateGradients()
    }
    
    fileprivate func updateGradients() {
        view.setGradientBackgroundColor(colors: [.lightBlueBackgroundGradientStart, .lightBlueBackgroundGradientEnd], axis: .horizontal)
        donateButton.applyGradient(colors: [UIColor.headerButtonGradientStart.cgColor, UIColor.headerButtonGradientEnd.cgColor], radius: 7)
    }
    
    private func configureNavigationBar(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Images.backButton, style: .plain, target: self, action: #selector(backButtonPressed))
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func getCharityInfo(){
        showLoadingView()
        networkManager.getCharityInfo(charityId: charityId) { [weak self] (result) in
            guard let self = self else { return }
            switch(result){
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong!", message: error.errorMessage, buttonTitle: "Ok")
            case .success(let infoCharity):
                DispatchQueue.main.async {
                    self.impactImageView.setImage(imageUrl: infoCharity.imageUrl) { 
                        self.hideLoadingView()
                        self.infoCharity = infoCharity
                        self.configureViews()
                    }
                }
            }
        }
    }
    
    //MARK: Views Setup
    
    private func configureViews() {
        guard self.infoCharity != nil else { return }
        addRightBarButtonItem()
        configureDonationButton()
        configureImpactImageView()
        configureScrollView()
        configureTitleLabelView()
        configureTagView()
        configureLocationTagView()
        configureOutputView()
        configureAboutHeaderLabel()
        configureDescriptionLabel()
        configureSocialMediaStackView()
        setContentViewHeight()
    }
    
    private func addRightBarButtonItem(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: self, action: #selector(accessoryButtonPressed))
    }
    
    private func configureDonationButton(){
        view.addSubview(donateButton)
        donateButton.addTarget(self, action: #selector(donateButtonPressed), for: .touchUpInside)
        donateButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        donateButton.setTitle("Donate", for: .normal)
        
        if(DeviceType.isiPad){
            donateButton.snp.makeConstraints { (maker) in
                maker.left.equalTo(self.view.snp.left).offset(200)
                maker.right.equalTo(self.view.snp.right).offset(-200)
                maker.width.greaterThanOrEqualTo(400)
                maker.centerX.equalTo(self.view.snp.centerX)
                maker.bottom.equalTo(self.view.snp.bottom).offset(-40)
                maker.height.equalTo(70)
            }
        }else{
            donateButton.snp.makeConstraints { (maker) in
                maker.left.equalTo(self.view.snp.left).offset(padding)
                maker.right.equalTo(self.view.snp.right).offset(-padding)
                maker.bottom.equalTo(self.view.snp.bottom).offset(-20)
                maker.height.equalTo(50)
            }
        }
    }
    
    private func configureScrollView(){
        view.addSubview(contentSuperView)
        contentSuperView.snp.makeConstraints { (maker) in
            maker.top.equalTo(impactImageView.snp.bottom)
            maker.left.equalTo(self.view.snp.left)
            maker.right.equalTo(self.view.snp.right)
            maker.bottom.equalTo(self.view.snp.bottom)
        }
        
        contentSuperView.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.snp.makeConstraints { (maker) in
            maker.top.equalTo(impactImageView.snp.bottom)
            maker.left.equalTo(self.view.snp.left)
            maker.right.equalTo(self.view.snp.right)
            maker.bottom.equalTo(self.view.snp.bottom)
        }
        
        contentView.pinToEdges(of: scrollView)
        contentView.snp.makeConstraints { (maker) in
            maker.width.equalTo(contentSuperView.snp.width)
        }
        view.bringSubviewToFront(donateButton)
    }

    private func configureImpactImageView(){
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
        charityTitleLabelView.set(title: infoCharity!.name)
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
    
    private func configureTagView(){
        contentView.addSubview(tagView)
        tagView.set(tags: infoCharity!.tags!)
        tagView.snp.makeConstraints { (maker) in
            maker.height.equalTo(30)
            maker.top.equalTo(contentView.snp.top).offset(45)
            maker.left.equalTo(contentView.snp.left).offset(20)
            maker.right.equalTo(contentView.snp.right).offset(-20)
        }
        contentHeight += 75
    }
    
    private func configureLocationTagView(){
        contentView.addSubview(locationTagView)
        locationTagView.set(tags: infoCharity!.geoTags!)
        locationTagView.snp.makeConstraints { (maker) in
            maker.height.equalTo(30)
            maker.top.equalTo(tagView.snp.bottom).offset(10)
            maker.left.equalTo(contentView.snp.left).offset(20)
            maker.right.equalTo(contentView.snp.right).offset(-20)
        }
        contentHeight += 40
    }
    
    private func configureOutputView(){
        outputView = OutputView(output: infoCharity!.singleImpact)
        
        contentView.addSubview(outputView!)
        outputView!.snp.makeConstraints { (maker) in
            maker.height.equalTo(50)
            maker.top.equalTo(locationTagView.snp.bottom).offset(30)
            maker.left.equalTo(contentView.snp.left).offset(20)
            maker.right.lessThanOrEqualTo(contentView.snp.right).offset(-20)
        }
        
        if(infoCharity!.singleImpact != nil){
            let gestureRegocnizer = UITapGestureRecognizer(target: self, action: #selector(outputButtonPressed))
            outputView!.addGestureRecognizer(gestureRegocnizer)
            outputView?.layer.borderWidth = 0.2
            outputView?.layer.cornerRadius = 7
            outputView?.layer.borderColor = UIColor.outputColor.cgColor
        }
        
        contentHeight += 120
    }
    
    private func configureAboutHeaderLabel(){
        contentView.addSubview(aboutHeaderLabel)
        aboutHeaderLabel.text = "About Charity"
        aboutHeaderLabel.textColor = .aboutCharityTextColor
        aboutHeaderLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(outputView!.snp.bottom).offset(25)
            maker.left.equalTo(contentView.snp.left).offset(20)
            maker.right.equalTo(contentView.snp.right).offset(-20)
            maker.height.equalTo(50)
        }
        contentHeight += 75
    }
    
    private func configureDescriptionLabel(){
        let summaryDescription = infoCharity!.summaryDescription ?? ""
        let description = infoCharity!.description ?? ""
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
            maker.left.equalTo(contentView.snp.left).offset(padding)
            maker.right.equalTo(contentView.snp.right).offset(-padding)
        }
        descriptionLabel.sizeToFit()
        descriptionLabel.textColor = .aboutCharityTextColor
        if(DeviceType.isiPad){
            contentHeight += labelText.height(withWidth: view.bounds.width - 40, font: UIFont.preferredFont(forTextStyle: .body))
        }else{
            contentHeight += labelText.height(withWidth: view.bounds.width - 40, font: UIFont.preferredFont(forTextStyle: .footnote))
        }
    }
    
    private func configureSocialMediaStackView(){
        contentView.addSubview(socialMediaStackView)
        socialMediaStackView.delegate = self
        socialMediaStackView.snp.makeConstraints { (maker) in
            maker.top.equalTo(descriptionLabel.snp.bottom).offset(padding)
            maker.width.equalTo(100)
            maker.height.equalTo(30)
            maker.centerX.equalTo(contentView.snp.centerX)
        }
        contentHeight += 30
    }
    
    private func setContentViewHeight(){
        contentView.snp.makeConstraints { (maker) in
            maker.height.equalTo(contentHeight)
        }
    }
    
    //MARK: Buttons & Alerts
    
    @objc func outputButtonPressed(){
        presentCalculationVC()
    }
    
    @objc func backButtonPressed(){
        self.dismiss(animated: true)
    }
    
    @objc private func donateButtonPressed() {
        let safariAlert = FBAlertVC(title: "Donate", message: "Do want to open Safari to donate?", actionButtonTitle: "Yes", dismissButtonTitle: "No") {
            self.presentSafariVC()
        }
        present(safariAlert, animated: true)
    }
    
    @objc func accessoryButtonPressed(){
        let actionSheetAC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Currency Selection", style: .default) { (action) in
            self.showCurrencyAlertVC()
        }
        actionSheetAC.addAction(action)
        actionSheetAC.addAction(UIAlertAction(title: "Cancel",
                                              style: .cancel,
                                              handler: nil))
        present(actionSheetAC, animated: true)
        
    }
    
    private func showCurrencyAlertVC(){
        DispatchQueue.main.async {
            let vc = CurrencySelectionVC()
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.delegate = self
            self.present(vc, animated: true)
        }
    }
    
    func presentCurrencySelectionInCalculationVC(){
        if(calculationVC != nil){
            calculationVC?.dismiss(animated: true, completion: {
                let vc = CurrencySelectionVC()
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                vc.startOutputCalculationVCOnDismiss = true
                vc.delegate = self
                self.present(vc, animated: true)
            })
        }
    }
    
    func presentCalculationVC(){
        calculationVC = OutputCalculationVC()
        calculationVC?.output = infoCharity?.singleImpact
        calculationVC?.modalTransitionStyle = .crossDissolve
        calculationVC?.modalPresentationStyle = .overFullScreen
        calculationVC?.delegate = self
        if(calculationVC != nil){
            present(calculationVC!, animated: true)
        }
    }
    
    func presentSafariVC(){
        guard let infoCharity = infoCharity else { return }
        var stringUrl = infoCharity.url ?? ""
        if(!stringUrl.hasPrefix("http")){
            stringUrl = "http://".appending(stringUrl)
        }
        guard let url = URL(string: stringUrl) else {
            presentErrorAlert(FBError.noValidURL)
            return
        }
        presentSafariVC(with: url)
    }
    
    func saveDonation(enteredAmount: Float){
        let donation = Donation(date: Date(), charityName: infoCharity!.name, impact: infoCharity?.singleImpact, amount: enteredAmount, currency: PersistenceManager.retrieveCurrency())
        
        PersistenceManager.updateDonations(donation: donation, persistenceActionType: .add) { [weak self](error) in
            guard let self = self else { return }
            if error != nil {
                self.presentErrorAlert(error!)
            }
        }
    }
}

extension CharityInfoVC: CurrencySelectionDelegate{
    func currencyChanged() {
        outputView?.updateUI()
    }
    func startCalculationVC(){
        presentCalculationVC()
    }
}

extension CharityInfoVC: TitleLabelViewDelegate{
    func favouriteButtonPressed() {
        PersistenceManager.isCharityFavorite(charity: charity) { [weak self] (isFavourite) in
            guard let self = self else { return }
            if(isFavourite){
                PersistenceManager.updateFavorites(charity: self.charity, persistenceActionType: .remove) { (error) in
                    guard let error = error else {
                        self.presentGFAlertOnMainThread(title: "Removed", message: "\(self.charity.name) has been removed from your favorites", buttonTitle: "Ok")
                        self.charityTitleLabelView.isFavourite = false
                        return
                    }
                    self.presentErrorAlert(error)
                }
            }else{
                PersistenceManager.updateFavorites(charity: self.charity, persistenceActionType: .add) { (error) in
                    guard let error = error else {
                        self.presentGFAlertOnMainThread(title: "Added", message: "\(self.charity.name) is now in your favorites", buttonTitle: "Ok")
                        self.charityTitleLabelView.isFavourite = true
                        return
                    }
                    self.presentErrorAlert(error)
                }
            }
        }
    }
}


extension CharityInfoVC: DonationBarViewDelegate{
    func donationButtonPressed() {
        presentSafariVC()
    }
}


extension CharityInfoVC: OutputCalculationVCDelegate{
        func saveDonationTriggered(enteredAmount: Float) {
            saveDonation(enteredAmount: enteredAmount)
            calculationVC?.dismiss(animated: true, completion: {
                self.presentGFAlertOnMainThread(title: "Saved", message: "Your donation was saved", buttonTitle: "Ok")
            })
        }
    
    func currencyButtonPressedFromOutputCalculationVC() {
        presentCurrencySelectionInCalculationVC()
    }
}


extension CharityInfoVC: SocialMediaStackViewDelegate{
    func shareTextOnFaceBook() {
        guard let urlString = infoCharity!.url else { return }
        guard let url = URL.init(string: urlString) else { return }
        let shareContent = ShareLinkContent()
        shareContent.contentURL = url
        shareContent.quote = infoCharity!.summaryDescription ?? ""
        ShareDialog(fromViewController: self, content: shareContent, delegate: nil).show()
    }
    
    func shareTextOnTwitter(){
        let tweetText = infoCharity?.summaryDescription ?? ""
        let tweetUrl = infoCharity!.url ?? ""
        let shareString = "https://twitter.com/intent/tweet?text=\(tweetText)&url=\(tweetUrl)"
        let escapedShareString = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        guard let url = URL(string: escapedShareString) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func shareTextOnWhatsapp(){
        let message = infoCharity?.summaryDescription ?? "" + "\n" + String(infoCharity!.url ?? "")
        let shareString = "whatsapp://send?text=\(message)"
        let escapedShareString = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        guard let url = URL(string: escapedShareString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [: ], completionHandler: nil)
        } else {
            presentGFAlertOnMainThread(title: "WhatsApp could not be found", message: "Please install WhatsApp first", buttonTitle: "Ok")
        }
    }
    
    func buttonPressed(type: SocialMediaType) {
        switch type {
        case .facebook:
            shareTextOnFaceBook()
        case .twitter:
            shareTextOnTwitter()
        case .whatsapp:
            shareTextOnWhatsapp()
        }
    }
}
