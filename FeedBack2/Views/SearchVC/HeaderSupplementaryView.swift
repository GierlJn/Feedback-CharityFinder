//
//  HeaderSupplementaryView.swift
//  FeedBack
//
//  Created by Julian Gierl on 07.12.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

protocol HeaderSupplementaryViewDelegate{
    func viewAllButtonPressed(category: Category)
}

final class HeaderSupplementaryView: UICollectionReusableView {
    
    let label = UILabel()
    let viewAllButton = UIButton()
    
    static let reuseIdentifier = "title-supplementary-reuse-identifier"
    let inset = CGFloat(10)
    
    var category: Category!
    var delegate: HeaderSupplementaryViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure() {
        configureLabel()
        configureButton()
    }
    
    private func configureLabel(){
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.snp.makeConstraints { (maker) in
            maker.left.equalTo(snp.left).offset(inset)
            maker.top.equalTo(snp.top).offset(inset)
            maker.bottom.equalTo(snp.bottom).offset(-inset)
        }
        label.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    private func configureButton(){
        addSubview(viewAllButton)
        viewAllButton.setTitle("View All", for: .normal)
        viewAllButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .footnote)
        viewAllButton.setTitleColor(.textTitleLabel, for: .normal)
        viewAllButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        viewAllButton.snp.makeConstraints { (maker) in
            maker.top.equalTo(snp.top).offset(inset)
            maker.right.equalTo(snp.right).offset(-inset)
            maker.bottom.equalTo(snp.bottom).offset(-inset)
        }
    }
    
    @objc func buttonPressed(){
        delegate?.viewAllButtonPressed(category: category)
    }
}
