//
//  DonationManager.swift
//  FeedBack2
//
//  Created by Julian Gierl on 03.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import Foundation

class DonationManager{
    static func calculateValue(for donation: Float, impactValue: Float)->Float{
        return donation * impactValue
    }
}
