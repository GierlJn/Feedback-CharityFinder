//
//  NetworkManager.swift
//  FeedBack2
//
//  Created by Julian Gierl on 01.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

final class NetworkManager{
    
    var baseSearchUrl = "https://app.sogive.org/search.json?"
    var baseCharityInfoUrl = "https://app.sogive.org/charity/"
    
    func cancelCurrentTasks(){
        URLSession.shared.getTasksWithCompletionHandler { (dataTasks, uploadTasks, downloadTasks) in
            for task in dataTasks{
                task.cancel()
            }
        }
    }
    
    func getCharities(searchParameter: String, size: Int, startFrom: Int, completed: @escaping (Result<[Charity], FBError>) -> Void){
        let stringUrl = "\(baseSearchUrl)\(searchParameter)&size=\(size)&from=\(startFrom)"
        
        guard let url = URL(string: stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? stringUrl) else {
            completed(.failure(.invalidSearchParameter))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil{
                if(error?.localizedDescription == "cancelled"){
                    completed(.failure(.userCancelled))
                }else{
                    completed(.failure(.unableToConnect))
                }
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
                let charities = try decoder.decodeDataToCharities(data: data)
                completed(.success(charities))
                return
            }catch{
                completed(.failure(.unableToDecodeData))
                return
            }
        }.resume()
    }
    
    func getCharityInfo(charityId: String, completed: @escaping (Result<InfoCharity, FBError>) -> Void){
        guard let url = URL(string: "\(baseCharityInfoUrl)\(charityId)/.json") else {
            completed(.failure(.unableToConnect))
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
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
                let charity = try decoder.decodeInfoCharity(data: data)
                completed(.success(charity))
                return
            }catch{
                completed(.failure(.invalidData))
                return
            }
        }.resume()
    }
}
