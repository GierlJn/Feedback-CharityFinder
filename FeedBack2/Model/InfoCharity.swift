//
//  InfoCharity.swift
//  FeedBack2
//
//  Created by Julian Gierl on 04.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import Foundation

struct InfoCharity: Hashable{
    var name: String
    var id: String?
    var summaryDescription: String?
    var logoUrl: String?
    var singleImpact: SimpleImpact?
    var imageUrl: String?
    var description: String?
    var url: String?
    var tags: String?
    var geoTags: String?
    
    
    mutating func filterBadImages(){
        if(id == "give-directly"){
            imageUrl = nil
        }
    }
}
