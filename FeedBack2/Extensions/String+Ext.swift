//
//  String+Ext.swift
//  FeedBack2
//
//  Created by Julian Gierl on 09.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

extension String{
    
    //MARK: Text formatting
    
    var firstUppercased: String { prefix(1).uppercased() + dropFirst() }
    
    var condensed: String { replacingOccurrences(of: "[\\s\n]+", with: " ", options: .regularExpression) }
    
    var withoutParanthesis: String { self.replacingOccurrences(of: "\\([^()]*\\)", with: "", options: .regularExpression) }
    
    var withoutStartingWhiteSpace: String {
        guard let index = self.firstIndex(where: {!$0.isWhitespace}) else { return "" }
        return String(self.suffix(from: index))
    }
    
    func formatPluralOutputName(with currency: Currency)->String{
        getPluralWording().replaceCurrencyWording(with: currency).withoutParanthesis.lowercased().condensed
    }
    
    func formatSingularOutputName(with currency: Currency)->String{
        getSingularWording().replaceCurrencyWording(with: currency).withoutParanthesis.lowercased().firstUppercased.condensed
    }
    
    func getSingularWording()->String{
        guard let parenthesisRange = self.range(of: #"(?<=\()(.*?)(?=\))"#, options: .regularExpression) else { return self }
        var paranthesisContent = self[parenthesisRange]
        
        if(paranthesisContent.hasPrefix("singular: ")){
            paranthesisContent.removeFirst("singular: ".count)
        }else{ return self }
        
        var array = self.withoutParanthesis.condensed.components(separatedBy: " ")
        array.removeFirst()
        return "\(paranthesisContent) \(array.joined(separator: " "))"
    }
    
    func getPluralWording()->String{
        var string = self
        guard let parenthesisRange = string.range(of: #"(?<=\()(.*?)(?=\))"#, options: .regularExpression) else { return self }
        var paranthesisContent = string[parenthesisRange]
        
        if(paranthesisContent.hasPrefix("plural: ")){
            paranthesisContent.removeFirst("plural: ".count)
        }else if(paranthesisContent == "s"){
            string = string.replacingOccurrences(of: "(", with: "")
            string = string.replacingOccurrences(of: ")", with: "")
            return string
        }else{ return self }
        
        var array = string.withoutParanthesis.condensed.components(separatedBy: " ")
        array.removeFirst()
        
        return "\(paranthesisContent) \(array.joined(separator: " "))"
    }
    
    func replaceCurrencyWording(with currency: Currency)->String{ return self.replacingOccurrences(of: Currency.pound.rawValue, with: currency.rawValue) }
    
    //MARK: Utilities
    
    func height(withWidth width: CGFloat, font: UIFont) -> CGFloat {
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let actualSize = self.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [.font : font], context: nil)
        return actualSize.height
    }
    
    var isNumeric: Bool{
        CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: self))
    }
    
}
