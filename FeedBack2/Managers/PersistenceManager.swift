//
//  PersistenceManager.swift
//  FeedBack2
//
//  Created by Julian Gierl on 09.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import Foundation

enum PersistenceActionType{
    case add, remove
}

class PersistenceManager {
    
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let currency = "currency"
        static let favourites = "favourites"
    }
    
    static func setCurrency(curency: Currency)->FBError?{
        do{
            let encoder = JSONEncoder()
            let encodedCurrency = try encoder.encode(curency)
            defaults.set(encodedCurrency, forKey: Keys.currency)
        }catch{
            return .invalidData
        }
        return nil
    }
    
    static func retrieveCurrency()->Currency{
        guard let data = defaults.object(forKey: Keys.currency) as? Data else{
            return Currency.euro
        }
        
        do{
            let decoder = JSONDecoder()
            let currency = try decoder.decode(Currency.self, from: data)
            return currency
        }catch{
            return Currency.euro
        }
        
    }
    
    static func updateFavorites(charity: Charity, persistenceActionType: PersistenceActionType, completed: @escaping(FBError?) -> Void){
        retrieveFavorites { (result) in
            switch result{
            case .success(var charities):
                switch persistenceActionType{
                case .add:
                    guard !charities.contains(charity) else {
                        completed(.alreadyFavorite)
                        return
                    }
                    charities.append(charity)
                    
                    
                case .remove:
                    charities.removeAll(where: {$0.id == charity.id})
                    
                }
                completed(save(charities: charities))
            
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    static func isCharityFavorite(charity: Charity, completed: @escaping(Bool) -> Void){
        retrieveFavorites { (result) in
            switch result{
            case .failure( _ ):
                completed(false)
            case .success(let charities):
                completed(charities.contains(charity))
            }
        }
    }
    
    static func retrieveFavorites(completed: @escaping(Result<[Charity], FBError>) -> Void){
        guard let data = defaults.object(forKey: Keys.favourites) as? Data else {
            completed(.success([Charity]()))
            return
        }
        
        do{
            let decoder = JSONDecoder()
            let favourites = try decoder.decode([Charity].self, from: data)
            completed(.success(favourites))
        }catch {
            completed(.failure(.invalidData))
        }
    }
    
    static func save(charities: [Charity]) -> FBError? {
        do{
            let encoder = JSONEncoder()
            let encodedFavoruites = try encoder.encode(charities)
            defaults.set(encodedFavoruites, forKey: Keys.favourites)
            return nil
        }catch{
            return .unableToFavourite
        }
    }
}
