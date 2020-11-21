//
//  Donation.swift
//  FeedBack
//
//  Created by Julian Gierl on 20.11.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import Foundation

struct Donation: Hashable, Decodable, Encodable{
    var id = UUID()
    var date: Date
    var charityName: String
    var output: Output
    var amount: Float
    var impact: Float
}
