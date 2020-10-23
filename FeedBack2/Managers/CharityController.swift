//
//  CharityController.swift
//  FeedBack2
//
//  Created by Julian Gierl on 15.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

class CharityController {
    
    let networkManager = NetworkManager()
    
    struct CharityCollection: Hashable {
        let title: String
        let charities: [Charity]

        let identifier = UUID()
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
    }
    
    var collections: [CharityCollection] {
        return _collections
    }
    
    fileprivate var _collections = [CharityCollection]()
    
    typealias Handler = (Result<[Charity], FBError>) -> Void
    
    func loadHighImpactCharities( completed: @escaping Handler){
        networkManager.getCharities(searchParameter: "high") { [weak self] (result) in
            guard let self = self else { return }
            switch result{
            case .failure(let error):
                print(error)
                completed(.failure(error))
            case .success(let charities):
                self.generateCharityCollections(for: charities)
                completed(.success(charities))
            }
        }
    }
    
    
}


extension CharityController {
    func generateCharityCollections(for charities: [Charity]){
        _collections.append(CharityCollection(title: "High impact", charities: charities))
    }
}
