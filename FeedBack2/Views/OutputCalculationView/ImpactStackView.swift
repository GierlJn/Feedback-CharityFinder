//
//  ImpactStackView.swift
//  FeedBack
//
//  Created by Julian Gierl on 22.11.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

class ImpactStackView: UIStackView{

    var output: SimpleImpact!
    var enteredAmount: Float!
    let currency = PersistenceManager.retrieveCurrency()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    convenience init(output: SimpleImpact, enteredAmount: Float) {
        self.init(frame: .zero)
        self.output = output
        self.enteredAmount = enteredAmount
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        let impactNumberLabel = FBTitleLabel(textAlignment: .center)
        let impactNameLabel = FBSubTitleLabel(textAlignment: .center)
        self.addArrangedSubview(impactNumberLabel)
        self.addArrangedSubview(impactNameLabel)
        self.axis = .vertical
        self.distribution = .fillEqually
        
        let value = output.costPerBeneficiary?.value ?? "1.0"
        var floatValue = Float(value) ?? 1.0
        floatValue = floatValue / currency.relativeValueToPound
        
        let impact = enteredAmount / floatValue
        
        let formatted = String(format: "%.0f", impact)
        
        impactNumberLabel.text = "\(formatted)"
        impactNumberLabel.textColor = .outputColor
        impactNumberLabel.font = UIFont.boldSystemFont(ofSize: 25)
        
        impactNameLabel.text = "\(output.name?.formatPluralOutputName(with: currency) ?? "")"
        impactNameLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        impactNameLabel.textColor = .label
        impactNameLabel.numberOfLines = 2
    }
    
    
}
