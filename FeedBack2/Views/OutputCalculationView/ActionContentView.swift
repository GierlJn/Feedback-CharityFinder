//
//  ActionContentView.swift
//  FeedBack
//
//  Created by Julian Gierl on 22.11.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

class ActionContentView: UIView{
    
    var donationTextField = DonationTextField()
    var outputStackView: UIStackView?
    let currency = PersistenceManager.retrieveCurrency()
    var delegate: OutputCalculationVCDelegate?
    let padding: CGFloat = 15
    var enteredAmount: Float = 1.0
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureTextField(){
        addSubview(donationTextField)

        donationTextField.snp.makeConstraints { (maker) in
            maker.height.equalTo(40)
            maker.centerY.equalTo(snp.centerY)
            maker.left.equalTo(snp.left).offset(padding)
            maker.right.equalTo(snp.right).offset(-padding)
        }
        
        donationTextField.delegate = self
        donationTextField.currencyLabel.setTitle(currency.symbol, for: .normal)
        donationTextField.currencyLabel.setTitleColor(.label, for: .normal)
        donationTextField.currencyLabel.addTarget(self, action: #selector(currencyButtonPressed), for: .touchUpInside)
    }
    
    func configureMessageLabel(output: SimpleImpact) {
        outputStackView = UIStackView()
        let impactNumberLabel = FBTitleLabel(textAlignment: .center)
        let impactNameLabel = FBSubTitleLabel(textAlignment: .center)
        if(outputStackView != nil){
            self.addSubview(outputStackView!)
            outputStackView?.pinToEdges(of: self)
        }
        outputStackView?.addArrangedSubview(impactNumberLabel)
        outputStackView?.addArrangedSubview(impactNameLabel)
        outputStackView?.axis = .vertical
        outputStackView?.distribution = .fillEqually
        
        let value = output.costPerBeneficiary?.value ?? "1.0"
        var floatValue = Float(value) ?? 1.0
        floatValue = floatValue / currency.relativeValueToPound
        
        let impact = enteredAmount / floatValue
        
        let formatted = String(format: "%.0f", impact)
        
        impactNumberLabel.text = "\(formatted)"
        impactNumberLabel.textColor = .outputColor
        impactNumberLabel.font = UIFont.boldSystemFont(ofSize: 25)
        
        impactNameLabel.text = "\(output.name?.formatOutputName(with: currency, wording: .plural) ?? "")"
        impactNameLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        impactNameLabel.textColor = .label
        impactNameLabel.numberOfLines = 2
    }
    
    @objc func currencyButtonPressed(){
        delegate?.currencyButtonPressed()
    }
}


extension ActionContentView: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = donationTextField.textField.text else { return false}
        guard !text.isEmpty else { return false}
        enteredAmount = Float(String(text)) ?? 1.0
        return true
    }
    
    
}
