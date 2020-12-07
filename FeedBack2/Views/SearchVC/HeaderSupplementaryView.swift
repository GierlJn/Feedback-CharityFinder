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


class HeaderSupplementaryView: UICollectionReusableView {
    
    let label = UILabel()
    let viewAllButton = UIButton()
    var category: Category!
    static let reuseIdentifier = "title-supplementary-reuse-identifier"
    var delegate: HeaderSupplementaryViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            label.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset)
        ])
        label.font = UIFont.boldSystemFont(ofSize: 20)
        
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
