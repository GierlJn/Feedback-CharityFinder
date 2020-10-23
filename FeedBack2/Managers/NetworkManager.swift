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
    var baseSearchUrl = "https://app.sogive.org/search.json?q="
    var baseCharityInfoUrl = "https://app.sogive.org/charity/"
    
    func getCharities(searchParameter: String, completed: @escaping Handler){
        guard let url = URL(string: "\(baseSearchUrl)\(searchParameter)") else {
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
//                let rawServerResponse = try decoder.decode(SearchResponse.self, from: data)
                let charities = try decoder.decodeReceivedCharitiyDataToCharities(data: data)
                
                completed(.success(charities))
                return
            }catch{
                completed(.failure(.invalidData))
                return
            }
        }
        task.resume()
    }
    
    func getCharityInfo(charityId: String, completed: @escaping (Result<InfoCharity, FBError>) -> Void){
        guard let url = URL(string: "\(baseCharityInfoUrl)\(charityId)/.json") else {
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
                guard let summaryDescription = cargo.summaryDescription else { throw FBError.invalidData}
                guard let url = cargo.url else { throw FBError.invalidData}
                guard let tags = cargo.tags else { throw FBError.invalidData }
                guard let geoTags = cargo.geoTags else { throw FBError.invalidData }
                let description = cargo.description
                
                #warning("Refactor")
                
                let charity = InfoCharity(name: name, id: id, logoUrl: logo, singleImpact: singleImpact, imageUrl: cargo.images, summaryDescription: summaryDescription, description: description, url: url, tags: tags, geoTags: geoTags)
                
                completed(.success(charity))
                return
            }catch{
                completed(.failure(.invalidData))
                return
            }
        }
        task.resume()
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
