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
            return Category(name: "All", parameter: "all")
        case .animals:
            return Category(name: "Animals", parameter: "animals")
        case .health:
            return Category(name: "Health", parameter: "health")
        }
    }
    
    static var allCategories: [Category] {
        return Categories.allCases.map { $0.category }
    }
}

struct Category: Equatable {
    var name: String
    var parameter: String
}
