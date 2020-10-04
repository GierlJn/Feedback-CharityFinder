//
//  CharityInfoVC.swift
//  FeedBack2
//
//  Created by Julian Gierl on 04.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

class CharityInfoVC: UIViewController{
    
    var charityId: String = ""
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        title = charityId        
    }
    
    
}
