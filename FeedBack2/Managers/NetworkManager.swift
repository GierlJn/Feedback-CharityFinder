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
    
    var baseSearchUrl = "https://app.sogive.org/search.json?"
    var baseCharityInfoUrl = "https://app.sogive.org/charity/"
    
    
    func getCharities(searchParameter: String, size: Int, completed: @escaping (Result<[Charity], FBError>) -> Void){
        let cleanedSpacesParameter = searchParameter.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? searchParameter
        
        let stringUrl = "\(baseSearchUrl)\(cleanedSpacesParameter)&size=\(size)"
        print(stringUrl)
        guard let url = URL(string: stringUrl) else {
            completed(.failure(.unvalidSearchParameter))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil{
                completed(.failure(.unableToConnect))
            }
            guard let response = response as? HTTPURLResponse else{
                completed(.failure(.unableToConnect))
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
                let charities = try decoder.decodeReceivedCharitiyDataToCharities(data: data)
                
                completed(.success(charities))
                return
            }catch{
                completed(.failure(.unableToDecodeData))
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
                let charity = try decoder.decodeReceivedDataToInfoCharity(data: data)
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
