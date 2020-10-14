//
//  InfoResponse.swift
//  FeedBack2
//
//  Created by Julian Gierl on 04.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import Foundation

struct InfoResponse : Decodable {
    
    let cargo : InfoCargo?
    
    enum CodingKeys: String, CodingKey {
        case cargo = "cargo"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        cargo = try values.decodeIfPresent(InfoCargo.self, forKey: .cargo)
    }
}

struct InfoCargo : Decodable {
    
    let id : String?
    let descriptionField : String?
    var tags : String?
    let images : String?
    let logo : String?
    let name : String?
    let url: String?
    let simpleImpact : SimpleImpact?
    
    
    enum CodingKeys: String, CodingKey {
        case id = "@id"
        case descriptionField = "summaryDescription"
        case tags = "whyTags"
        case images = "images"
        case logo = "logo"
        case name = "name"
        case simpleImpact = "simpleImpact"
        case url = "url"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        descriptionField = try values.decodeIfPresent(String.self, forKey: .descriptionField)
        tags = try values.decodeIfPresent(String.self, forKey: .tags)
        images = try values.decodeIfPresent(String.self, forKey: .images)
        logo = try values.decodeIfPresent(String.self, forKey: .logo)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        simpleImpact = try values.decodeIfPresent(SimpleImpact.self, forKey: .simpleImpact)
    }
    
}


struct SimpleImpact : Decodable, Hashable {
    
    let type : String?
    let costPerBeneficiary : InfoCostPerBeneficiary?
    let name : String?
    let number : Int?
    
    enum CodingKeys: String, CodingKey {
        case type = "@type"
        case costPerBeneficiary = "costPerBeneficiary"
        case name = "name"
        case number = "number"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        costPerBeneficiary = try values.decodeIfPresent(InfoCostPerBeneficiary.self, forKey: .costPerBeneficiary)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        number = try values.decodeIfPresent(Int.self, forKey: .number)
    }
    
}

struct InfoCostPerBeneficiary : Codable, Hashable {
    
    let value : String?
    
    enum CodingKeys: String, CodingKey {
        case value = "value"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        value = try values.decodeIfPresent(String.self, forKey: .value)
    }
    
}
