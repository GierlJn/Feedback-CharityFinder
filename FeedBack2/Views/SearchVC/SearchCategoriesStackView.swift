//
//  SearchParameterStackView.swift
//  FeedBack2
//
//  Created by Julian Gierl on 14.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit


final class SearchCategoriesStackView: UIView, CategoryButtonDelegate{

    var scrollView = UIScrollView()
    var stackView = UIStackView()
    var categories = Categories.allCategories
    
    var delegate: HeaderViewDelegate?
    var categoryButtons = [CategoryButton]()
    
    var selectedCategory: Category? {
        didSet {
            if(selectedCategory != nil){
                setInitialButtonAsSelected()
                delegate?.categoryChanged(category: selectedCategory!)
            }else{
                updateCategorySelection()
            }
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
        scrollView.showsHorizontalScrollIndicator = false
        
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
        
        let fillerUILabel = UILabel()
        fillerUILabel.backgroundColor = .init(white: 0, alpha: 0)
        fillerUILabel.text = " "
        fillerUILabel.snp.makeConstraints { (maker) in
            maker.width.equalTo(20)
        }
        stackView.addArrangedSubview(fillerUILabel)
    }
    
    private func setInitialButtonAsSelected(){
        let selectedButton = categoryButtons.first { $0.category == selectedCategory }
        selectedButton?.isSelected = true
    }
    
    func categoryButtonPressed(category: Category) {
        if(category != self.selectedCategory){
            self.selectedCategory = category
            updateCategorySelection()
        }
    }
    
    private func clearAllSelections(){
        for button in categoryButtons{
            button.isSelected = false
        }
    }
    
    private func clearCategoriesExcept(category: Category){
        let selectedButton = categoryButtons.first { $0.category == selectedCategory }
        for button in categoryButtons{
            if(button != selectedButton){
                button.isSelected = false
            }
        }
    }
    
    func updateCategorySelection() {
        if let selectedCategory = selectedCategory{
            clearCategoriesExcept(category: selectedCategory)
        }else{
            clearAllSelections()
        }
    }
    
}
