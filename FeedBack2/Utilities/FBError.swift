//
//  FBError.swift
//  FeedBack2
//
//  Created by Julian Gierl on 01.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import Foundation

enum FBError: Error {
    case unableToConnect
    case invalidResponseCode(Int)
    case invalidResponse
    case invalidData
    case unableToFavourite
    case alreadyFavorite
    
    var errorMessage: String{
        switch self {
        case .unableToConnect:
            return "Was not able to connect to the server"
        case .invalidResponseCode(let statusCode):
            return "Invalid Response code from server \(statusCode)"
        case .invalidData:
            return "Response data not valid"
        case .invalidResponse:
            return "Response data not valid"
        case .unableToFavourite:
            return "Could not be added to favourites"
        case .alreadyFavorite:
            return "Charity is already a favourite"
        }
    }
    
    var statusCode: Int?{
        switch self {
        case .invalidResponseCode(let statusCode):
            return statusCode
        default:
            return nil
        }
    }
}
