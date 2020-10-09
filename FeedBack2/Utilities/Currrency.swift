//
//  Currrency.swift
//  FeedBack2
//
//  Created by Julian Gierl on 09.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import Foundation

enum Currency: String, Codable{
    case dollar = "dollar"
    case euro = "euro"
    case pound = "pound"
    
    var relativeValueToPound: Float{
        switch self{
        case .dollar:
            return 0.77
        case .euro:
            return 0.91
        default:
            return 1
        }
    }
    
    var symbol: String{
        switch self{
        case .dollar:
            return "$"
        case .euro:
            return "€"
        case .pound:
            return "£"
        }
    }
}
