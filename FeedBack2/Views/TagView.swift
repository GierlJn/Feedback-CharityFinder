//
//  TagView.swift
//  FeedBack2
//
//  Created by Julian Gierl on 14.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

class TagView: UIView{
    
    var scrollView = UIScrollView()
    var stackView = UIStackView()
    var tags = [String]()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(tags: String){
        self.tags = seperateTags(tags: tags)
        updateUI()
    }
    
    private func configure(){
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        scrollView.pinToEdges(of: self)
        stackView.pinToEdges(of: scrollView)
        
        stackView.spacing = 12
    }
    
    private func updateUI(){
        for tag in tags{
            let textLabel = TagLabel()
            textLabel.text = tag
            textLabel.sizeToFit()
            
            stackView.addArrangedSubview(textLabel)
        }
    }
    
    private func seperateTags(tags: String)->[String]{
        tags.lowercased().components(separatedBy: ", ")
    }
}
