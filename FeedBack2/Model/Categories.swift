//
//  Categories.swift
//  FeedBack2
//
//  Created by Julian Gierl on 15.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import Foundation

enum Categories: CaseIterable {
    case animals, health, education, poverty
    
    var category: Category{
        switch(self){
        case .animals:
            return Category(name: "Animals", parameter: "q=animals")
        case .health:
            return Category(name: "Health", parameter: "q=health")
        case .education:
            return Category(name: "Education", parameter: "q=education")
        case .poverty:
            return Category(name: "Poverty", parameter: "q=poverty")
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
