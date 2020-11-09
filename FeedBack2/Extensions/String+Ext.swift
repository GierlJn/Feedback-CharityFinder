//
//  String+Ext.swift
//  FeedBack2
//
//  Created by Julian Gierl on 09.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

extension String{
    
    var firstUppercased: String { prefix(1).uppercased() + dropFirst() }
    
    var condensed: String { replacingOccurrences(of: "[\\s\n]+", with: " ", options: .regularExpression)}
    
    var withoutParanthesis: String { self.replacingOccurrences(of: "\\([^()]*\\)", with: "", options: .regularExpression) }
    
    var withoutStartingWhiteSpace: String {
        guard let index = self.firstIndex(where: {!$0.isWhitespace}) else { return "" }
        return String(self.suffix(from: index))
    }
    
    func tail(s: String) -> String {
        return String(s.suffix(from: s.index(s.startIndex, offsetBy: 1)))
    }
    
    func formatOutputName(with currency: Currency)->String{ self.withoutParanthesis.replaceCurrencyWording(with: currency).lowercased().firstUppercased.condensed }
    
    func replaceCurrencyWording(with currency: Currency)->String{ return self.replacingOccurrences(of: "pound", with: currency.rawValue) }
    
    func height(withWidth width: CGFloat, font: UIFont) -> CGFloat {
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let actualSize = self.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [.font : font], context: nil)
        return actualSize.height
    }
    
    
    
}
