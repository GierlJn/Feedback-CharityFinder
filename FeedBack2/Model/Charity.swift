//
//  Charity.swift
//  FeedBack2
//
//  Created by Julian Gierl on 01.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import Foundation

struct SoGiveSearchResponse{
    let charities: [Charity]
}


extension SoGiveSearchResponse: Decodable{
    enum CodingKeys: String, CodingKey{
        case cargo
        
        enum CargoKeys: String, CodingKey{
            case hits = "hits"
            
            enum HitsKeys: String, CodingKey{
                case id = "@id"
                case name = "name"
                case displayName = "displayName"
            }
            
        }
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let cargoContainer = try container.nestedContainer(keyedBy: CodingKeys.CargoKeys.self, forKey: .cargo)
        var hitsContainer = try cargoContainer.nestedUnkeyedContainer(forKey: .hits)
        var charities = [Charity]()
        while !hitsContainer.isAtEnd {
            let charityContainer = try hitsContainer.nestedContainer(keyedBy: CodingKeys.CargoKeys.HitsKeys.self)
            let id = try charityContainer.decode(String.self, forKey: .id)
            let name = try? charityContainer.decode(String.self, forKey: .name)
            let displayName = try? charityContainer.decode(String.self, forKey: .displayName)
            let charityName = displayName ?? name
            if(charityName != nil){
                let charity = Charity(name: charityName!, id: id)
                charities.append(charity)
            }
        }
        self.charities = charities
    }
    
}



struct Charity: Hashable{
    var name: String
    var id: String
}


