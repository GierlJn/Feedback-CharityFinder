//
//  OutputOverViewStackView.swift
//  FeedBack2
//
//  Created by Julian Gierl on 08.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

class OutputOverViewContainerView: UIStackView{
    
    var outputs: [Output]!
    
    private override init(frame: CGRect) {
        super.init(frame: .zero)
        //configure()
    }
    
    convenience init(outputs: [Output]) {
        self.init(frame: .zero)
        self.outputs = outputs
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(outputs: [Output]) {
        self.outputs = outputs
        configure()
    }
    
    private func configure(){
        self.axis = .vertical
        self.distribution = .equalCentering
        self.spacing = 5
        
        for output in outputs{
            let outputOverView = OutputView(output: output)
            outputOverView.snp.makeConstraints { (maker) in
                maker.height.equalTo(30)
            }
            addArrangedSubview(outputOverView)
        }
    }
    
}
