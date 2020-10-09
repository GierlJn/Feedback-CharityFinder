//
//  OutputOverViewStackView.swift
//  FeedBack2
//
//  Created by Julian Gierl on 08.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

class OutputOverViewContainerView: UIView{
    
    var outputs: [Output]!
    
    
    private override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(outputs: [Output]) {
        self.init()
        self.outputs = outputs
        configure()
    }
    
    private func configure(){
        for output in outputs{
            let outputOverView = OutputOverviewView()
            addSubview(outputOverView)
        }
    }
    
}
