//
//  NetworkManager.swift
//  FeedBack2
//
//  Created by Julian Gierl on 01.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import Foundation

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
    
}
extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}

//private extension NetworkManager {
//    func decode(_ data: Data) {
//        let decoder = JSONDecoder()
//        //decoder.dateDecodingStrategy = .formatted(DateFormatter.fullISO8601)
//        launches = (try? decoder.decode([Launch].self, from: data)) ?? []
//        for launch in launches {
//            fetchPatch(for: launch)
//        }
//    }
//
//    func fetchPatch(for launch: Launch) {
//        let request = NetworkRequest(url: launch.patchURL)
//        request.execute { [weak self] (data) in
//            guard let data = data else { return }
//            guard let index = self?.launches.firstIndex(where: { $0.id == launch.id }) else { return }
//            self?.launches[index].patch = UIImage(data: data)
//        }
//    }
//}
