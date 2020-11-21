//
//  FBError.swift
//  FeedBack2
//
//  Created by Julian Gierl on 01.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import Foundation

enum FBError: Error, Equatable {
    static var titleMessage = "Something went wrong!"
    
    case unableToConnect
    case invalidResponseCode(Int)
    case invalidResponse
    case invalidData
    case unableToFavourite
    case alreadyFavorite
    case noValidURL
    case unableToDecodeData
    case unvalidSearchParameter
    case userCancelled
    case donationAlreadySaved
    case donationsCouldNotBeRetrieved
    case donationCantBeSaved
    
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
        case .noValidURL:
            return "It seems like we don't have a valid url to this charity."
        case .unableToDecodeData:
            return "No charity data could be decoded"
        case .unvalidSearchParameter:
            return "The entered search is not a valid url"
        case .userCancelled:
            return "The user cancelled the task"
        case .donationAlreadySaved:
            return "Donation is already saved"
        case .donationsCouldNotBeRetrieved:
            return "Donations could not be retrieved"
        case .donationCantBeSaved:
            return "Donatin could not be saved"
            
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
