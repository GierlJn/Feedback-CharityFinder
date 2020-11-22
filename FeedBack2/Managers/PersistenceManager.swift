//
//  PersistenceManager.swift
//  FeedBack2
//
//  Created by Julian Gierl on 09.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import Foundation

enum PersistenceActionType: String{
    case add = "Added"
    case remove = "Removed"
}

class PersistenceManager {
    
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let currency = "currency"
        static let favourites = "favourites"
        static let sort = "sort"
        static let donations = "donations"
    }
    
    static func setImpactSort(_ setOn: Bool){
        defaults.setValue(setOn, forKey: Keys.sort)
    }
    
    static func getImpactSort()->Bool{
        let isOn = defaults.value(forKey: Keys.sort) as? Bool ?? false
        return isOn
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
    
    static func updateDonations(donation: Donation, persistenceActionType: PersistenceActionType, completed: @escaping(FBError?)->Void){
        retrieveDonations { (result) in
            switch result{
            case .success(var donations):
                switch persistenceActionType{
                case .add:
                    guard !donations.contains(donation) else {
                        completed(.donationAlreadySaved)
                        return
                    }
                    donations.append(donation)
                    
                case .remove:
                    donations.removeAll(where: {$0.id == donation.id})
                }
                completed(saveDonations(donations: donations))
                
            case .failure(let error):
                completed(error)
            }
            
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
                completed(saveCharities(charities: charities))
            
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    static func retrieveDonations(completed: @escaping(Result<[Donation], FBError>) -> Void){
        guard let data = defaults.object(forKey: Keys.donations) as? Data else {
            completed(.success([Donation]()))
            return
        }
        
        do{
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode([Donation].self, from: data)
            completed(.success(decodedData))
        }catch{
            completed(.failure(.alreadyFavorite))
            return
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
    
    static func saveCharities(charities: [Charity]) -> FBError? {
        do{
            let encoder = JSONEncoder()
            let encodedFavoruites = try encoder.encode(charities)
            defaults.set(encodedFavoruites, forKey: Keys.favourites)
            return nil
        }catch{
            return .unableToFavourite
        }
    }
    
    static func saveDonations(donations: [Donation]) -> FBError? {
        do{
            let encoder = JSONEncoder()
            let encodedFavoruites = try encoder.encode(donations)
            defaults.set(encodedFavoruites, forKey: Keys.donations)
            return nil
        }catch{
            return .donationCantBeSaved
        }
    }
}
