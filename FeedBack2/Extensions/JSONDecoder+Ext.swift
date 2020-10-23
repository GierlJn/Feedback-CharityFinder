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
            var charityOutputs = [Output]()
            var charityMainOutput: Output?
            let name = hit.displayName ?? hit.name
            if let projects = hit.projects{
                for project in projects{
                    if var projectOutputs = project.outputs{
                        projectOutputs.removeAll(where: {$0.costPerBeneficiary == nil || $0.name == nil})
                        for output in projectOutputs{
                            if let value = output.costPerBeneficiary?.value{
                                charityOutputs.append(output)
                                if(value > charityMainOutput?.costPerBeneficiary!.value ?? 0.0){
                                    charityMainOutput = output
                                }
                            }
                        }
                    }
                }
                
            }
            if(charityMainOutput != nil && name != nil && hit.id != nil && hit.logo != nil && hit.url != nil){
                #warning("refactor")
                let charity = Charity(name: name!, id: hit.id!, logoUrl: hit.logo!, mainOutput: charityMainOutput!, outputs: charityOutputs, url: hit.url!, impactEstimation: hit.estimatedImpact)
                charities.append(charity)
            }
        }
        return charities
    }
}
