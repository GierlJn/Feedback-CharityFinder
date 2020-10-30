//
//  FBTextField.swift
//  FeedBack2
//
//  Created by Julian Gierl on 02.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

class FBTextField: UITextField{
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray4.cgColor
        
        textColor = .label
        tintColor = .label
        textAlignment = .center
        font = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 12
        
        backgroundColor = .tertiarySystemBackground
        autocorrectionType = .no
        returnKeyType = .search
        clearButtonMode = .whileEditing
        
        configurePlaceholder()
    }
    
    fileprivate func configurePlaceholder() {
        let magnifyingGlassAttachment = NSTextAttachment(data: nil, ofType: nil)
        magnifyingGlassAttachment.image = UIImage(systemName: "magnifyingglass")?.withTintColor(.systemGray)
        let magnifyingGlassString = NSAttributedString(attachment: magnifyingGlassAttachment)
        let attributedText = NSMutableAttributedString(attributedString: magnifyingGlassString)
        let searchString = NSAttributedString(string: "  Search Charity here")
        attributedText.append(searchString)
        attributedPlaceholder = attributedText
    }
}
