//
//  Charity.swift
//  FeedBack2
//
//  Created by Julian Gierl on 02.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import Foundation

struct Charity: Hashable, Codable{
    var name: String
    var id: String
    var logoUrl: String
    var mainOutput: Output
    var outputs: [Output]
    var url: String
}
