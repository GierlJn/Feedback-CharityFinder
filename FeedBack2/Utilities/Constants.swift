//
//  Constants.swift
//  FeedBack2
//
//  Created by Julian Gierl on 10.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

enum Images {
    static let image_placeholder = UIImage(named: "charity-image-placeholder-dark")
    static let logo_placeholder = UIImage(named: "logo-placeholder-dark")
    static let searchActionButton = UIImage(systemName: "slider.horizontal.3")
}

enum SearchParameters {
    static let all = Category(name: "all", parameter: "all")
    static let animals = Category(name: "animals", parameter: "animals")
    static let health = Category(name: "health", parameter: "health")
}

struct Category: Equatable {
    var name: String
    var parameter: String
}
