//
//  CharityController.swift
//  FeedBack2
//
//  Created by Julian Gierl on 15.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

class CharityController {
    
    var initialCategories = [Categories.highImpact, Categories.animals, Categories.environment]
    
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
    let networkManager = NetworkManager()
    typealias Handler = (Result<[Charity], FBError>) -> Void
    
    func loadInitialCharities(completed: @escaping (FBError?) -> ()){
        var responses = 0
        var successfulResponses = 0
        
        func completeIfLoaded(_ error: FBError?){
            responses += 1
            if error == nil{
                successfulResponses += 1
            }
            if( responses >= initialCategories.count ){
                if(successfulResponses == 0){
                    completed(FBError.unableToConnect)
                }else{
                    collections.sort { $0.position < $1.position }
                    completed(nil)
                }
            }
            
        }
        
        for index in 0..<initialCategories.count{
            loadCharities(category: initialCategories[index].category, size: 4, positionIndex: index) { (error) in
                    completeIfLoaded(nil)
            }
        }
    }
    
    func loadCharities( category: Category, size: Int, positionIndex: Int, completed: @escaping (FBError?) -> ()){
        networkManager.getCharities(searchParameter: category.parameter, size: size, startFrom: 0) { [weak self] (result) in
            guard let self = self else { return }
            switch result{
            case .failure(let error):
                completed(error)
            case .success(let charities):
                self.generateCharityCollections(for: charities, category: category, positionIndex: positionIndex)
                completed(nil)
            }
        }
    }
    
}


extension CharityController {
    func generateCharityCollections(for charities: [Charity], category: Category, positionIndex: Int){
        collections.append(CharityCollection(title: category.name, charities: charities, position: positionIndex, category: category))
        
    }
}
