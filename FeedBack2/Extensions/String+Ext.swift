//
//  String+Ext.swift
//  FeedBack2
//
//  Created by Julian Gierl on 09.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import Foundation

extension String{
    
    func cleanOutputName(with currency: Currency)->String{ self.removePluralParanthesis().replaceCurrencyWording(with: currency).lowercased() }
    
    func removePluralParanthesis()->String{ self.replacingOccurrences(of: "\\([^()]*\\)", with: "", options: [.regularExpression]) }
    
    func replaceCurrencyWording(with currency: Currency)->String{ return self.replacingOccurrences(of: "pound", with: currency.rawValue) }
}
