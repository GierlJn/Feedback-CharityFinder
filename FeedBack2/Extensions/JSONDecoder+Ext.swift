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
    
    private func decodeRawServerResponse(_ rawServerResponse: SearchResponse) throws -> [Charity] {
        var charities = [Charity]()
        let cargo = rawServerResponse.cargo
        let hits = cargo.hits
        
        for hit in hits {
            if let name = hit.displayName ?? hit.name{
                let charity = Charity(name: name, id: hit.id, logoUrl: hit.logo, url: hit.url)
                charities.append(charity)
            }
            
        }
        return charities
    }
}
