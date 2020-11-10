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
            if(isSelected){
                setGradientBackgroundColor(colors: [.headerButtonGradientStart, .headerButtonGradientEnd], axis: .custom(angle: CGFloat(90)))
            }else{
                removeGradientBackground()
                backgroundColor = UIColor.categoriesTransparentColor
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if(isSelected){
            setGradientBackgroundColor(colors: [.headerButtonGradientStart, .headerButtonGradientEnd], axis: .custom(angle: CGFloat(90)))
        }else{
            removeGradientBackground()
            backgroundColor = UIColor.categoriesTransparentColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        configure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
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
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .footnote)
        
        layer.masksToBounds = true
        layer.cornerRadius = 7
        addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    @objc func buttonPressed(){
        isSelected = true
        delegate?.categoryButtonPressed(category: category!)
    }
    
    private func addShadow(){
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 3, height: 0.0)
        layer.shadowRadius = 3
        clipsToBounds = true
        
    }

    
}
