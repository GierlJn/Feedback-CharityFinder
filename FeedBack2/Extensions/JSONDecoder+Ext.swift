//
//  JSONDecover+Ext.swift
//  FeedBack2
//
//  Created by Julian Gierl on 23.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import Foundation

extension JSONDecoder{
    func decodeReceivedCharitiyDataToCharities(data: Data) throws -> [Charity] {
        do{
            let rawServerResponse = try decode(SearchResponse.self, from: data)
            let charities = try decodeRawServerResponse(rawServerResponse)
            return charities
        }catch{
            throw FBError.invalidData
        }
    }
    
    func decodeReceivedDataToInfoCharity(data: Data) throws -> InfoCharity {
        do{
            let decoder = JSONDecoder()
            let rawServerResponse = try decoder.decode(InfoResponse.self, from: data)
            let cargo = rawServerResponse.cargo
            let charity = InfoCharity(name: cargo.name, id: cargo.id, summaryDescription: cargo.summaryDescription, logoUrl: cargo.logo, singleImpact: cargo.simpleImpact, imageUrl: cargo.images, description: cargo.description, url: cargo.url, tags: cargo.tags ?? "No tags", geoTags: cargo.geoTags ?? "Worldwide")
            return charity
        }catch{
            throw FBError.invalidData
        }
    }
    
    private func decodeRawServerResponse(_ rawServerResponse: SearchResponse) throws -> [Charity] {
        var charities = [Charity]()
        let cargo = rawServerResponse.cargo
        let hits = cargo.hits
        
        for hit in hits {
            if let name = hit.displayName ?? hit.name{
                guard let logoUrl = hit.logo else { continue }
                guard let url = hit.url else { continue }
                let charity = Charity(name: name, id: hit.id, logoUrl: logoUrl, url: url)
                charities.append(charity)
            }
            
        }
        return charities
    }
}
