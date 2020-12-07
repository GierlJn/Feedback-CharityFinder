//
//  TagLabel.swift
//  FeedBack2
//
//  Created by Julian Gierl on 14.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

final class TagLabel: UILabel{
    
    var edgeInsets: UIEdgeInsets
    
    override init(frame: CGRect) {
        self.edgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: edgeInsets))
    }
    
    override var intrinsicContentSize: CGSize {
        let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + edgeInsets.left + edgeInsets.right
        let height = superContentSize.height + edgeInsets.top + edgeInsets.bottom
        return CGSize(width: width, height: height)
    }
    
    private func configure(){
        layer.masksToBounds = true
        layer.cornerRadius = 7
        font = UIFont.preferredFont(forTextStyle: .footnote)
        textColor = .white
    }
}
