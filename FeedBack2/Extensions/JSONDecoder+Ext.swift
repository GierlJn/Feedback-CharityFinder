//
//  JSONDecover+Ext.swift
//  FeedBack2
//
//  Created by Julian Gierl on 23.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import Foundation

extension JSONDecoder{
    
    func decodeReceivedDataToInfoCharity(data: Data) throws -> InfoCharity {
        do{
            let decoder = JSONDecoder()
            let rawServerResponse = try decoder.decode(InfoResponse.self, from: data)
            let cargo = rawServerResponse.cargo
            
            var charity = InfoCharity(name: cargo.name, id: cargo.id, summaryDescription: cargo.summaryDescription, logoUrl: cargo.logo, imageUrl: cargo.images, description: cargo.description, url: cargo.url, tags: cargo.tags ?? "General", geoTags: cargo.geoTags ?? "Global")
            
            if let singleImpact = cargo.simpleImpact,
               let costPerBeneficiary = singleImpact.costPerBeneficiary,
               costPerBeneficiary.value != nil,
               singleImpact.name != nil
            { charity.singleImpact = singleImpact }
            
            charity.filterBadImages()
            return charity
            
        }catch{
            throw FBError.invalidData
        }
    }
    
    func decodeReceivedCharitiyDataToCharities(data: Data) throws -> [Charity] {
        do{
            let rawServerResponse = try decode(SearchResponse.self, from: data)
            let charities = try decodeRawServerResponse(rawServerResponse)
            return charities
        }catch{
            throw FBError.unableToDecodeData
        }
    }
    
    private func decodeRawServerResponse(_ rawServerResponse: SearchResponse) throws -> [Charity] {
        var charities = [Charity]()
        let cargo = rawServerResponse.cargo
        let hits = cargo.hits
        
        for hit in hits {
            if let name = hit.displayName ?? hit.name{
                guard let url = hit.url else { continue }
                
                var charity = Charity(name: name.withoutStartingWhiteSpace, id: hit.id, logoUrl: hit.logo, url: url)
                if let estimatedImpact = hit.estimatedImpact, estimatedImpact != "more-info-needed"{
                    charity.impactEstimation = estimatedImpact
                }
                charities.append(charity)
            }
            
        }
        return charities
    }
}
