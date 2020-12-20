////
////  Charity.swift
////  FeedBack2
////
////  Created by Julian Gierl on 01.10.20.
////  Copyright © 2020 Julian Gierl. All rights reserved.
////
//
//import Foundation
//
//struct RawServerResponse{
//    let charities: [Charity]
//}
//
//
//extension RawServerResponse: Decodable{
//    enum CodingKeys: String, CodingKey{
//        case cargo
//        
//        enum CargoKeys: String, CodingKey{
//            case hits = "hits"
//            
//            enum HitsKeys: String, CodingKey{
//                case id = "@id"
//                case name = "name"
//                case logoUrl = "logo"
//                case displayName = "displayName"
//                case projects = "projects"
//                
//                enum ProjectKeys: String, CodingKey{
//                    case outputs = "outputs"
//                    case analyst = "analyst"
//                    
//                    enum OutputKeys: String, CodingKey{
//                        case costPerBeneficiary = "costPerBeneficiary"
//                        case projectDescription = "name"
//                        
//                        enum CostPerBeneficiaryKeys: String, CodingKey{
//                            case value = "value"
//                        }
//                    }
//                }
//            }
//        }
//    }
//    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let cargoContainer = try container.nestedContainer(keyedBy: CodingKeys.CargoKeys.self, forKey: .cargo)
//        var hitsContainer = try cargoContainer.nestedUnkeyedContainer(forKey: .hits)
//        var charities = [Charity]()
//        while !hitsContainer.isAtEnd {
//            let charityContainer = try hitsContainer.nestedContainer(keyedBy: CodingKeys.CargoKeys.HitsKeys.self)
//            
//            let id = try charityContainer.decode(String.self, forKey: .id)
//            let name = try? charityContainer.decode(String.self, forKey: .name)
//            let displayName = try? charityContainer.decode(String.self, forKey: .displayName)
//            let logoUrl = try charityContainer.decode(String.self, forKey: .logoUrl)
//            let charityName = displayName ?? name // JSON response is inconsistent
//            var mainProject: ImpactProject? // Sometimes there are more than one project, therefore choose the one with the highest value
//            
//            var projectsUnkeyedContainer = try charityContainer.nestedUnkeyedContainer(forKey: .projects)
//            
//            while !projectsUnkeyedContainer.isAtEnd{
//                let projectNestedContainer = try projectsUnkeyedContainer.nestedContainer(keyedBy: CodingKeys.CargoKeys.HitsKeys.ProjectKeys.self)
//                var outputsUnkeyedContainer = try projectNestedContainer.nestedUnkeyedContainer(forKey: .outputs)
//                
//                var fetchedProjects = [ImpactProject]()
//                
//                while !outputsUnkeyedContainer.isAtEnd{
//                    let outputNestedContainer = try outputsUnkeyedContainer.nestedContainer(keyedBy: CodingKeys.CargoKeys.HitsKeys.ProjectKeys.OutputKeys.self)
//                    
//                    let projectDescription = try? outputNestedContainer.decode(String.self, forKey: .projectDescription)
//                    
//                    let costPerBeneficiaryNestedContainer = try? outputNestedContainer.nestedContainer(keyedBy: CodingKeys.CargoKeys.HitsKeys.ProjectKeys.OutputKeys.CostPerBeneficiaryKeys.self, forKey: .costPerBeneficiary)
//                    let costPerBeneficiary = try? costPerBeneficiaryNestedContainer?.decode(Float.self, forKey: .value)
//                    
//                    if(projectDescription != nil && costPerBeneficiary != nil){
//                        let output = ImpactProject(projectDecsription: projectDescription!, costPerBeneficiary: costPerBeneficiary!)
//                        fetchedProjects.append(output)
//                    }
//                    mainProject = fetchedProjects.first
//                    mainProject = fetchedProjects.first(where: {$0.costPerBeneficiary > mainProject!.costPerBeneficiary}) ?? mainProject
//                }
//            }
//            
//            if(charityName != nil && mainProject != nil){
//                let charity = Charity(name: charityName!, id: id, output: mainProject!, logoUrl: logoUrl)
//                charities.append(charity)
//            }
//        }
//        self.charities = charities
//    }
//}
//
//
//
