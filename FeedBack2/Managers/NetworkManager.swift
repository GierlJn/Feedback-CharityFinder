//
//  NetworkManager.swift
//  FeedBack2
//
//  Created by Julian Gierl on 01.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit
import SwiftSVG

class NetworkManager{
    
    typealias Handler = (Result<[Charity], FBError>) -> Void
    
    func getCharities(urlString: String, completed: @escaping Handler){
        guard let url = URL(string: urlString) else {
            completed(.failure(.unableToConnect))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil{
                completed(.failure(.invalidData))
            }
            guard let response = response as? HTTPURLResponse else{
                completed(.failure(.invalidResponse))
                return
            }
            guard response.statusCode == 200 else{
                completed(.failure(.invalidResponseCode(Int(response.statusCode))))
                return 
            }
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            do{
                let decoder = JSONDecoder()
                let rawServerResponse = try decoder.decode(SearchResponse.self, from: data)
                completed(.success(try self.decodeRawServerResponse(rawServerResponse)))
                return
            }catch{
                completed(.failure(.invalidData))
                return
            }
        }
        task.resume()
    }
    
    func getCharityInfo(urlString: String, completed: @escaping (Result<InfoCharity, FBError>) -> Void){
        guard let url = URL(string: urlString) else {
            completed(.failure(.unableToConnect))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil{
                completed(.failure(.invalidData))
            }
            guard let response = response as? HTTPURLResponse else{
                completed(.failure(.invalidResponse))
                return
            }
            guard response.statusCode == 200 else{
                completed(.failure(.invalidResponseCode(Int(response.statusCode))))
                return
            }
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            do{
                let decoder = JSONDecoder()
                let rawServerResponse = try decoder.decode(InfoResponse.self, from: data)
                guard let cargo = rawServerResponse.cargo else { throw FBError.invalidData }
                guard let singleImpact = cargo.simpleImpact else { throw FBError.invalidData }
                guard let name = cargo.name else { throw FBError.invalidData }
                guard let id = cargo.id else { throw FBError.invalidData }
                guard let logo = cargo.logo else { throw FBError.invalidData }
                guard let description = cargo.descriptionField else { throw FBError.invalidData}
                guard let url = cargo.url else { throw FBError.invalidData}
                guard let tags = cargo.tags else { throw FBError.invalidData }
                
                #warning("Refactor")
                
                let charity = InfoCharity(name: name, id: id, logoUrl: logo, singleImpact: singleImpact, imageUrl: cargo.images, description: description, url: url, tags: tags)
                
                completed(.success(charity))
                return
            }catch{
                completed(.failure(.invalidData))
                return
            }
        }
        task.resume()
    }
    
    private func decodeRawServerResponse(_ rawServerResponse: SearchResponse) throws -> [Charity] {
        guard let cargo = rawServerResponse.cargo else { throw FBError.invalidData }
        guard let hits = cargo.hits else { throw FBError.invalidData }
        var charities = [Charity]()
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
                let charity = Charity(name: name!, id: hit.id!, logoUrl: hit.logo!, mainOutput: charityMainOutput!, outputs: charityOutputs, url: hit.url!)
                charities.append(charity)
            }
        }
        return charities
    }
    
    func downloadImage(urlString: String, completed: @escaping(Result<UIImage, FBError>) -> Void){
        guard let url = URL(string: urlString) else {
            completed(.failure(.unableToConnect))
            return
        }
        
        
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completed(.failure(.invalidResponse))
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            
            guard let image = UIImage(data: data) else {
                completed(.failure(.invalidData))
                return
            }
            
            
            
            
            completed(.success(image))
        }
        task.resume()
    }
    
}
