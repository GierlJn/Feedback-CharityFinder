//
//  CharityController.swift
//  FeedBack2
//
//  Created by Julian Gierl on 15.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

final class CharityCollectionManager {
    
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
    
    func loadInitialCharities(completed: @escaping (FBError?) -> ()){
        var responses = 0
        var successfulResponses = 0
        
        func completeLoading(_ error: FBError?){
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
                completeLoading(error)
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
    
    func generateCharityCollections(for charities: [Charity], category: Category, positionIndex: Int){
        collections.append(CharityCollection(title: category.name, charities: charities, position: positionIndex, category: category))
    }
}

