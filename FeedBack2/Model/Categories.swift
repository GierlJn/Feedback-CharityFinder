//
//  Categories.swift
//  FeedBack2
//
//  Created by Julian Gierl on 15.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import Foundation

enum Categories: CaseIterable {
    case all, animals, health
    
    var category: Category{
        switch(self){
        case .all:
            return Category(name: "all", parameter: "all")
        case .animals:
            return Category(name: "animals", parameter: "animals")
        case .health:
            return Category(name: "health", parameter: "health")
        }
    }
}

struct Category: Equatable {
    var name: String
    var parameter: String
}
