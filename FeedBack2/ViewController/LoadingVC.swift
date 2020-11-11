//
//  LoadingVC.swift
//  FeedBack
//
//  Created by Julian Gierl on 11.11.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

class LoadingVC: UIViewController{
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    var titleLabel = FBTitleLabel(textAlignment: .center)
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "LoadingVC", bundle: .main)
        //configure()
        
    }
    
    override func viewDidLoad() {
        loadingIndicator.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configure(){
        view.backgroundColor = .systemBackground
        view.addSubview(titleLabel)
        titleLabel.text = "Loading"
        titleLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(view.snp.centerX)
            maker.centerY.equalTo(view.snp.centerY)
            
        }
    }
    
}
