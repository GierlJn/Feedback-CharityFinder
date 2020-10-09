//
//  String+Ext.swift
//  FeedBack2
//
//  Created by Julian Gierl on 09.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import Foundation

extension String{
    
    var firstUppercased: String { return prefix(1).uppercased() + dropFirst() }
    
    var condensed: String { return replacingOccurrences(of: "[\\s\n]+", with: " ", options: .regularExpression)}
    
    func cleanOutputName(with currency: Currency)->String{ self.removePluralParanthesis().replaceCurrencyWording(with: currency).lowercased().firstUppercased.condensed }
    
    func removePluralParanthesis()->String{ self.replacingOccurrences(of: "\\([^()]*\\)", with: "", options: .regularExpression) }
    
    func replaceCurrencyWording(with currency: Currency)->String{ return self.replacingOccurrences(of: "pound", with: currency.rawValue) }
}
