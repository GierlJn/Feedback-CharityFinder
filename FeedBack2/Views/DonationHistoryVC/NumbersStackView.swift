//
//  NumbersStackView.swift
//  FeedBack
//
//  Created by Julian Gierl on 23.11.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

final class NumbersStackView: UIStackView{
    
    let totalLabelView = FBTitleLabel(textAlignment: .center)
    let totalDonationsSumLabel = FBSubTitleLabel(textAlignment: .center)
    
    let currency = PersistenceManager.retrieveCurrency()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI(with donations: [Donation]){
        totalLabelView.text = String(donations.count)
        
        let donationsSumForDollar = donations.reduce(0.0, { (result, donation) -> Float in
            let amount = donation.amount
            let amountInPound = amount * donation.currency.relativeValueToPound
            let amountInSelectedCurrency = amountInPound / currency.relativeValueToPound

            return result + amountInSelectedCurrency
        })
        
        totalDonationsSumLabel.text = String(Int(donationsSumForDollar)) + currency.symbol
    }
    
    private func configure(){
        totalLabelView.textColor = .outputColor
        self.addArrangedSubview(totalLabelView)
        self.addArrangedSubview(totalDonationsSumLabel)
    }
}
