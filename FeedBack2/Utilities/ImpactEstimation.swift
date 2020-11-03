//
//  ImpactEstimation.swift
//  FeedBack2
//
//  Created by Julian Gierl on 03.11.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import Foundation

enum ImpactEstimation: String{
    case none = "none"
    case low = "low"
    case medium = "medium"
    case high = "high"
    
    var getSortingRank: Int{
        switch self{
        case .high:
            return 4
        case .medium:
            return 3
        case .low:
            return 2
        case .none:
            return 1
        }
    }
    
}
