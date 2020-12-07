//
//  LoadingVC.swift
//  FeedBack
//
//  Created by Julian Gierl on 11.11.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

final class LoadingVC: UIViewController{
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    var titleLabel = FBTitleLabel(textAlignment: .center)
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "LoadingVC", bundle: .main)
    }
    
    override func viewDidLoad() {
        loadingIndicator.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
