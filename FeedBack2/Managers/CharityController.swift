//
//  CharityController.swift
//  FeedBack2
//
//  Created by Julian Gierl on 15.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

class CharityController {
    
    struct CharityCollection: Hashable {
        let title: String
        let charities: [Charity]
        let position: Int
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
        NetworkManager.shared.getCharities(searchParameter: "impact=high", size: 8) { [weak self] (result) in
            guard let self = self else { return }
            switch result{
            case .failure(let error):
                print(error)
                completed(.failure(error))
            case .success(let charities):
                self.generateCharityCollections(for: charities, title: "High Impact", positionIndex: 0)
                completed(.success(charities))
            }
        }
    }
    
    func loadSecoundaryCharities( completed: @escaping Handler){
        NetworkManager.shared.getCharities(searchParameter: "q=animals", size: 8) { [weak self] (result) in
            guard let self = self else { return }
            switch result{
            case .failure(let error):
                print(error)
                completed(.failure(error))
            case .success(let charities):
                self.generateCharityCollections(for: charities, title: "Animals", positionIndex: 1)
                completed(.success(charities))
            }
        }
    }
    
}


extension CharityController {
    func generateCharityCollections(for charities: [Charity], title: String, positionIndex: Int){
        _collections.append(CharityCollection(title: title, charities: charities, position: positionIndex))
        _collections.sort { $0.position < $1.position }
        
    }
}
