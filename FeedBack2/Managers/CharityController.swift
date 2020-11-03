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
    
    func loadCharities( category: Category, size: Int, positionIndex: Int, completed: @escaping Handler){
        NetworkManager.shared.getCharities(searchParameter: category.parameter, size: size) { [weak self] (result) in
            guard let self = self else { return }
            switch result{
            case .failure(let error):
                print(error)
                completed(.failure(error))
            case .success(let charities):
                self.generateCharityCollections(for: charities, category: category, positionIndex: positionIndex)
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
