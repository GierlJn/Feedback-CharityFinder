//
//  TagView.swift
//  FeedBack2
//
//  Created by Julian Gierl on 14.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

final class TagLabelScrollView: UIView{
    
    var scrollView = UIScrollView()
    var stackView = UIStackView()
    var tags = [String]()
    var color: UIColor = .label
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    convenience init(color: UIColor) {
        self.init(frame: .zero)
        self.color = color
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(tags: String){
        self.tags = seperateTags(tags: tags)
        for tag in self.tags{
            if(tag.isEmpty){return}
            let textLabel = TagLabel()
            textLabel.text = tag
            textLabel.sizeToFit()
            textLabel.backgroundColor = color
            stackView.addArrangedSubview(textLabel)
        }
    }
    
    private func configure(){
        addSubview(scrollView)
        scrollView.pinToEdges(of: self)
        scrollView.addSubview(stackView)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -30, right: 0)
        stackView.pinToEdges(of: scrollView)
        stackView.spacing = 12
    }
    
    private func seperateTags(tags: String)->[String]{
        tags.lowercased().components(separatedBy: ", ")
    }
}
