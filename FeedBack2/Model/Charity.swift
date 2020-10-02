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
                case projects = "projects"
                
                enum ProjectKeys: String, CodingKey{
                    case outputs = "outputs"
                    case analyst = "analyst"
                    
                    enum OutputKeys: String, CodingKey{
                        case costPerBeneficiary = "costPerBeneficiary"
                        case impactDescription = "name"
                        
                        enum CostPerBeneficiaryKeys: String, CodingKey{
                            case value = "value"
                        }
                    }
                }
                
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
            var selectedOutput: Output?
            
            var projectsContainer = try charityContainer.nestedUnkeyedContainer(forKey: .projects)
            while !projectsContainer.isAtEnd{
                let projectsContainer2 = try projectsContainer.nestedContainer(keyedBy: CodingKeys.CargoKeys.HitsKeys.ProjectKeys.self)
                
                var outputsContainer = try projectsContainer2.nestedUnkeyedContainer(forKey: .outputs)
                
                
                var outputs = [Output]()
                while !outputsContainer.isAtEnd{
                    let outputsContainer2 = try outputsContainer.nestedContainer(keyedBy: CodingKeys.CargoKeys.HitsKeys.ProjectKeys.OutputKeys.self)
                    
                    let impactDecsription = try? outputsContainer2.decode(String.self, forKey: .impactDescription)
                    
                    let costPerBeneficiaryContainer = try? outputsContainer2.nestedContainer(keyedBy: CodingKeys.CargoKeys.HitsKeys.ProjectKeys.OutputKeys.CostPerBeneficiaryKeys.self, forKey: .costPerBeneficiary)
                    let costPerBeneficiary = try? costPerBeneficiaryContainer?.decode(Float.self, forKey: .value)
                    
                    if(impactDecsription != nil && costPerBeneficiary != nil){
                        let output = Output(impactDecsription: impactDecsription!, costPerBeneficiary: costPerBeneficiary!)
                        outputs.append(output)
                    }
                    selectedOutput = outputs.first
                    selectedOutput = outputs.first(where: {$0.costPerBeneficiary > selectedOutput!.costPerBeneficiary}) ?? selectedOutput
                }
            }
            
            
            
            
            if(charityName != nil && selectedOutput != nil){
                let charity = Charity(name: charityName!, id: id, output: selectedOutput!)
                charities.append(charity)
            }
        }
        self.charities = charities
    }
    

    
}

struct Output: Hashable{
    var impactDecsription: String
    var costPerBeneficiary: Float
}



struct Charity: Hashable{
    var name: String
    var id: String
    var output: Output
}


