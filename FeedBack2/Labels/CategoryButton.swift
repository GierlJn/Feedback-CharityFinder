//
//  CategoryButton.swift
//  FeedBack2
//
//  Created by Julian Gierl on 14.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

protocol CategoryButtonDelegate{
    func categoryButtonPressed(category: Category)
}

class CategoryButton: UIButton{
    var category: Category?
    var delegate: CategoryButtonDelegate?
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? UIColor.buttonDarkBlueGradientEnd : UIColor.categoriesTransparentColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(category: Category){
        self.category = category
        setTitle(category.name, for: .normal)
    }
    
    private func configure(){
        backgroundColor = .categoriesTransparentColor
        tintColor = .gray
        setTitleColor(.gray, for: .normal)
        setTitleColor(.white, for: .selected)
        
        layer.masksToBounds = true
        layer.cornerRadius = 7
        addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    @objc func buttonPressed(){
        isSelected = true
        delegate?.categoryButtonPressed(category: category!)
    }

    
}
