//
//  ActionContentView.swift
//  FeedBack
//
//  Created by Julian Gierl on 22.11.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

protocol ActionContentViewDelegate {
    func currencyButtonPressed()
}

class ActionContentView: UIView{
    
    var donationTextField = DonationTextField()
    var outputStackView = UIStackView()
    let currency = PersistenceManager.retrieveCurrency()
    var delegate: ActionContentViewDelegate?
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
    
    func configureImpactStackView(output: SimpleImpact) {
        outputStackView = ImpactStackView(output: output, enteredAmount: enteredAmount)
        self.addSubview(outputStackView)
        outputStackView.pinToEdges(of: self)
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
