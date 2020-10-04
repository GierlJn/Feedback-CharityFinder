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
    
    var networkManger = NetworkManager()
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        title = charityId
        
        let url = "https://app.sogive.org/charity/" + charityId + ".json"
        networkManger.getCharityInfo(urlString: url) { (result) in
            switch(result){
            case .failure(let error):
                print(error)
            case .success(let charity):
                print(charity)
            }
        }
    }
    
    
}
