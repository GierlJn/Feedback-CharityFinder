//
//  CharityController.swift
//  FeedBack2
//
//  Created by Julian Gierl on 15.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

class CharityController {
    
    struct CharityC: Hashable {
        let title: String
        let image: UIImage
        let identifier = UUID()
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
    }
    
    struct CharityCollection: Hashable {
        let title: String
        let videos: [CharityC]

        let identifier = UUID()
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
    }
    
    var collections: [CharityCollection] {
        return _collections
    }

    init() {
        generateCollections()
    }
    fileprivate var _collections = [CharityCollection]()
    
    
}


extension CharityController {
    func generateCollections(){
        _collections = [ CharityCollection(title: "High impact",
                                           videos: [ CharityC(title: "Anti Malaria", image: Images.logo_placeholder!), CharityC(title: "Anti IV", image: Images.logo_placeholder!), CharityC(title: "Anti Aids", image: Images.logo_placeholder!)])]
        
    }
}
