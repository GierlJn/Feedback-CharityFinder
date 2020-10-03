//
//  NetworkManager.swift
//  FeedBack2
//
//  Created by Julian Gierl on 01.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

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
                let jsonResponse = try decoder.decode(RawServerResponse.self, from: data)
                completed(.success(jsonResponse.charities))
                return
            }catch{
                completed(.failure(.invalidData))
                return
            }
        }
        task.resume()
    }
    
    func downloadLogo(urlString: String, completed: @escaping(Result<UIImage, FBError>) -> Void){
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
            ImageCache.shared.setImage(image: image, key: urlString)
            completed(.success(image))
        }
        task.resume()
    }
    
}
