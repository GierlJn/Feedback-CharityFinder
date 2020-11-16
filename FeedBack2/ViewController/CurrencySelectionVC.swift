//
//  CurrencySelectionVC.swift
//  FeedBack2
//
//  Created by Julian Gierl on 02.11.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

protocol CurrencySelectionDelegate {
    func currencyChanged()
    func startCalculationVC()
}

class CurrencySelectionVC: UIViewController{
    
    var containerView = AlertContainerView()
    var currencies = Currency.allCases
    var pickerView = UIPickerView()
    var titleLabel = FBTitleLabel(textAlignment: .center)
    var actionButton = FBButton()
    
    let padding: CGFloat = 20
    var selectedCurrency = PersistenceManager.retrieveCurrency()
    
    var delegate: CurrencySelectionDelegate?
    
    var startOutputCalculationVCOnDismiss = false
    
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        configure()
    }
    
    private func configure(){
        configureContainerView()
        configureTitleLabel()
        configureActionButton()
        configurePickerView()
        
    }
    
    fileprivate func configureContainerView() {
        view.addSubview(containerView)
        containerView.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(view.snp.centerY)
            maker.centerX.equalTo(view.snp.centerX)
            maker.height.equalTo(220)
            maker.width.equalTo(240)
        }
    }
    
    fileprivate func configureTitleLabel() {
        containerView.addSubview(titleLabel)
        titleLabel.text = "Currency Selection"
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(containerView.snp.top).offset(padding)
            maker.left.equalTo(containerView.snp.left).offset(padding)
            maker.right.equalTo(containerView.snp.right).offset(-padding)
            maker.height.equalTo(28)
        }
    }
    
    fileprivate func configureActionButton() {
        containerView.addSubview(actionButton)
        actionButton.setTitle("Set", for: .normal)
        actionButton.snp.makeConstraints { (maker) in
            maker.height.equalTo(44)
            maker.left.equalTo(containerView.snp.left).offset(padding*2)
            maker.right.equalTo(containerView.snp.right).offset(-padding*2)
            maker.bottom.equalTo(containerView.snp.bottom).offset(-padding)
        }
        actionButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    fileprivate func configurePickerView(){
        containerView.addSubview(pickerView)
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom).offset(8)
            maker.left.equalTo(containerView.snp.left).offset(padding)
            maker.right.equalTo(containerView.snp.right).offset(-padding)
            maker.bottom.equalTo(actionButton.snp.top).offset(-12)
        }
        
        let selectedRowIndex = currencies.firstIndex(of: selectedCurrency) ?? 0
        pickerView.selectRow(selectedRowIndex, inComponent: 0, animated: true)
    }
    
    @objc func buttonPressed(){
        _ = PersistenceManager.setCurrency(curency: selectedCurrency)
        
        dismiss(animated: true, completion: {
            self.delegate?.currencyChanged()
            if(self.startOutputCalculationVCOnDismiss){
                self.delegate?.startCalculationVC()
            }
        })
        
       
    }
    
}


extension CurrencySelectionVC: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let currency = currencies[row]
        return currency.symbol
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCurrency = currencies[row]
    }
    
}
