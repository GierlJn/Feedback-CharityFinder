//
//  Cargo.swift
//  FeedBack2
//
//  Created by Julian Gierl on 03.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import Foundation

struct SearchResponse : Decodable {

        let cargo : Cargo?
        let success : Bool?

        enum CodingKeys: String, CodingKey {
                case cargo = "cargo"
                case success = "success"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                cargo = try values.decodeIfPresent(Cargo.self, forKey: .cargo)
                success = try values.decodeIfPresent(Bool.self, forKey: .success)
        }

}

struct Cargo : Decodable {
    
    let hits : [Hit]?
    let total : Int?
    
    
    enum CodingKeys: String, CodingKey {
        case hits = "hits"
        case total = "total"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
        hits = try values.decodeIfPresent([Hit].self, forKey: .hits)
        
    }
    
}

struct Hit : Decodable {
    
    let id : String?
    let displayName : String?
    let logo : String?
    let name : String?
    var url : String?
    let projects : [Project]?
    
    enum CodingKeys: String, CodingKey {
        case id = "@id"
        case displayName = "displayName"
        case logo = "logo"
        case name = "name"
        case projects = "projects"
        case url = "url"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        displayName = try values.decodeIfPresent(String.self, forKey: .displayName)
        logo = try values.decodeIfPresent(String.self, forKey: .logo)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        projects = try values.decodeIfPresent([Project].self, forKey: .projects)
    }
}


struct Project : Codable {

    let outputs : [Output]?
    
    enum CodingKeys: String, CodingKey {
        case outputs = "outputs"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        outputs = try values.decodeIfPresent([Output].self, forKey: .outputs)
    }
}


struct Output : Codable, Hashable {

    let name : String?
    let costPerBeneficiary : CostPerBeneficary?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case costPerBeneficiary = "costPerBeneficiary"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        costPerBeneficiary = try values.decodeIfPresent(CostPerBeneficary.self, forKey: .costPerBeneficiary)
    }
    
}

struct CostPerBeneficary : Codable, Hashable {
    
    let value : Float?
    
    enum CodingKeys: String, CodingKey {
        case value = "value"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        value = try values.decodeIfPresent(Float.self, forKey: .value)
    }
    
}

