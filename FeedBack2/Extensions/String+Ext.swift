//
//  String+Ext.swift
//  FeedBack2
//
//  Created by Julian Gierl on 09.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

enum Wording{
    case singular, plural
}

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
    
    func formatOutputName(with currency: Currency, wording: Wording)->String{
        
        switch(wording){
        case .plural:
            return getPluralWording().replaceCurrencyWording(with: currency).withoutParanthesis.lowercased().condensed
        case .singular:
            return getSingularWording().replaceCurrencyWording(with: currency).withoutParanthesis.lowercased().firstUppercased.condensed
        }
    }
    
    func getSingularWording()->String{
        
        let fullString = self
        
        guard let parenthesisRange = fullString.range(of: #"(?<=\()(.*?)(?=\))"#, options: .regularExpression) else {
            return self
        }

        var paranthesisContent = fullString[parenthesisRange]

        if(paranthesisContent.hasPrefix("singular: ")){
            paranthesisContent.removeFirst("singular: ".count)
        }else{
            return self
        }

        let withoutParenthesis = fullString.withoutParanthesis.condensed
        
        var array = withoutParenthesis.components(separatedBy: " ")
        array.removeFirst()
        
        let result = String(paranthesisContent) + " " + String(array.joined(separator: " "))
        return result
    }
    
    func getPluralWording()->String{
        
        var fullString = self
        
        guard let parenthesisRange = fullString.range(of: #"(?<=\()(.*?)(?=\))"#, options: .regularExpression) else {
            return self
        }

        var paranthesisContent = fullString[parenthesisRange]

        if(paranthesisContent.hasPrefix("plural: ")){
            paranthesisContent.removeFirst("plural: ".count)
        }else if(paranthesisContent == "s"){
            fullString = fullString.replacingOccurrences(of: "(", with: "")
            fullString = fullString.replacingOccurrences(of: ")", with: "")
            return fullString
        }
        else{
            return self
        }

        let withoutParenthesis = fullString.withoutParanthesis.condensed
        
        var array = withoutParenthesis.components(separatedBy: " ")
        array.removeFirst()
        
        let result = String(paranthesisContent) + " " + String(array.joined(separator: " "))
        return result
    }
    
    func replaceCurrencyWording(with currency: Currency)->String{ return self.replacingOccurrences(of: "pound", with: currency.rawValue) }
    
    func height(withWidth width: CGFloat, font: UIFont) -> CGFloat {
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let actualSize = self.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [.font : font], context: nil)
        return actualSize.height
    }

    var isNumeric: Bool{
        CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: self))
    }
    
}
