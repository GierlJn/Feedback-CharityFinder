//
//  SearchTextField.swift
//  FeedBack
//
//  Created by Julian Gierl on 07.12.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

final class SearchTextField: FBTextField{
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configurePlaceholder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configurePlaceholder() {
        let magnifyingGlassAttachment = NSTextAttachment(data: nil, ofType: nil)
        magnifyingGlassAttachment.image = UIImage(systemName: "magnifyingglass")?.withTintColor(.systemGray)
        let magnifyingGlassString = NSAttributedString(attachment: magnifyingGlassAttachment)
        let attributedText = NSMutableAttributedString(attributedString: magnifyingGlassString)
        let searchString = NSAttributedString(string: "  Search Charity here")
        attributedText.append(searchString)
        attributedPlaceholder = attributedText
    }
}
