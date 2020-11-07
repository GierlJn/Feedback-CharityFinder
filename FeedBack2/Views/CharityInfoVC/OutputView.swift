//
//  OutputOverviewView.swift
//  FeedBack2
//
//  Created by Julian Gierl on 08.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

class OutputView: UIView{
    
    var output: SimpleImpact!
    var iconImageView = UIImageView()
    var mayFundLabel = UILabel()
    var impactLabel = UILabel()
    var labelsStackView = UIStackView()
    var viewColor: UIColor = UIColor.outputColor
    
    private override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(output: SimpleImpact) {
        self.init()
        self.output = output
        
        configure()
        updateUI()
    }

    private func configure(){

        addSubview(iconImageView)
        iconImageView.image = UIImage(systemName: "heart.fill")
        iconImageView.tintColor = viewColor
        iconImageView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.snp.left)
            maker.size.equalTo(30)
            maker.centerY.equalTo(self.snp.centerY)
        }
        
                
        addSubview(labelsStackView)
        labelsStackView.axis = .vertical
        labelsStackView.distribution = .fill
        labelsStackView.spacing = 3
        labelsStackView.addArrangedSubview(mayFundLabel)
        labelsStackView.addArrangedSubview(impactLabel)
        
        labelsStackView.snp.makeConstraints { (maker) in
            maker.left.equalTo(iconImageView.snp.right).offset(8)
            maker.right.equalTo(self.snp.right)
            maker.top.equalTo(self.snp.top)
            maker.bottom.equalTo(self.snp.bottom)
        }
    }
    
    func updateUI(){
        mayFundLabel.font = .boldSystemFont(ofSize: 12)
        let valueLabelText = "1 \(output.name!.formatOutputName(with: PersistenceManager.retrieveCurrency()))"
        mayFundLabel.text = valueLabelText
        mayFundLabel.textColor = viewColor
        
        let currency = PersistenceManager.retrieveCurrency()
        
        let value = output.costPerBeneficiary!.value
        var floatValue = Float(value!) ?? 1.0
        floatValue = floatValue / currency.relativeValueToPound
        let formatted = String(format: "%.2f", floatValue)
        impactLabel.text = "For every \(formatted)\(currency.symbol) donated"
        
        impactLabel.font = .systemFont(ofSize: 12)
        impactLabel.textColor = viewColor
        impactLabel.alpha = 0.8
    }
    
}
