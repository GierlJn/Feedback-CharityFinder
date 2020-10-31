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
        let category: Category
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
    }
    
    var collections = [CharityCollection]()
    
    typealias Handler = (Result<[Charity], FBError>) -> Void
    
    func loadHighImpactCharities( completed: @escaping Handler){
        NetworkManager.shared.getCharities(searchParameter: Categories.highImpact.category.parameter, size: 8) { [weak self] (result) in
            guard let self = self else { return }
            switch result{
            case .failure(let error):
                print(error)
                completed(.failure(error))
            case .success(let charities):
                self.generateCharityCollections(for: charities, category: Categories.highImpact.category, positionIndex: 0)
                completed(.success(charities))
            }
        }
    }
    
    func loadSecoundaryCharities( completed: @escaping Handler){
        NetworkManager.shared.getCharities(searchParameter: Categories.animals.category.parameter, size: 8) { [weak self] (result) in
            guard let self = self else { return }
            switch result{
            case .failure(let error):
                print(error)
                completed(.failure(error))
            case .success(let charities):
                self.generateCharityCollections(for: charities, category: Categories.animals.category, positionIndex: 1)
                completed(.success(charities))
            }
        }
    }
    
}


extension CharityController {
    func generateCharityCollections(for charities: [Charity], category: Category, positionIndex: Int){
        collections.append(CharityCollection(title: category.name, charities: charities, position: positionIndex, category: category))
        collections.sort { $0.position < $1.position }
        
    }
}
