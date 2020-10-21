//
//  SearchParameterStackView.swift
//  FeedBack2
//
//  Created by Julian Gierl on 14.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//6

import UIKit

protocol SearchCategoriesDelegate{
    func categoryHasChanged(category: Category)
}

class SearchCategoriesStackView: UIView, CategoryButtonDelegate{

    var scrollView = UIScrollView()
    var stackView = UIStackView()
    var categories = Categories.allCategories
    var delegate: SearchCategoriesDelegate?
    var searchVCdelegate: SearchVCDelegate?
    
    var categoryButtons = [CategoryButton]()
    var selectedCategory = Categories.all.category {
        didSet {
            delegate?.categoryHasChanged(category: selectedCategory)
            searchVCdelegate?.categoryChanged(category: selectedCategory)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        scrollView.pinToEdges(of: self)
        stackView.pinToEdges(of: scrollView)
        stackView.spacing = 12
        
        addButtons()
        setInitialButtonAsSelected()
    }
    
    private func addButtons() {
        for category in categories{
            let categoryButton = CategoryButton()
            categoryButton.set(category: category)
            categoryButton.sizeToFit()
            categoryButton.delegate = self
            categoryButtons.append(categoryButton)
            stackView.addArrangedSubview(categoryButton)
        }
    }
    
    private func setInitialButtonAsSelected(){
        let selectedButton = categoryButtons.first { $0.category == selectedCategory }
        selectedButton?.isSelected = true
    }
    
    func categoryButtonPressed(category: Category) {
        self.selectedCategory = category
        setButtonsNotSelected()
    }
    
    private func setButtonsNotSelected() {
        let selectedButton = categoryButtons.first { $0.category == selectedCategory }
        for button in categoryButtons{
            if(button != selectedButton){
                button.isSelected = false
            }
        }
    }
}
