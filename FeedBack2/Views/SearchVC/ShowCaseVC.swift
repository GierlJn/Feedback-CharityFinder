//
//  ShowCaseVC.swift
//  FeedBack2
//
//  Created by Julian Gierl on 16.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

class ShowCaseVC: UIViewController{
    
    let charityController = CharityController()
    var collectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<CharityController.CharityCollection, CharityController.CharityC>! = nil
    var currentSnapshot: NSDiffableDataSourceSnapshot<CharityController.CharityCollection, CharityController.CharityC>! = nil
    static let titleElementKind = "title-element-kind"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //view.setGradientBackgroundColor(colors: [.lightBlueBackgroundGradientStart, .lightBlueBackgroundGradientEnd], axis: .horizontal)
    }
}

extension ShowCaseVC {
    func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int,
                                 layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            // if we have the space, adapt and go 2-up + peeking 3rd item
            let groupFractionalWidth = CGFloat(layoutEnvironment.container.effectiveContentSize.width > 500 ?
                                                0.325 : 0.65)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupFractionalWidth),
                                                   heightDimension: .absolute(200))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.interGroupSpacing = 20
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
            
            let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .estimated(44))
            let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: titleSize,
                elementKind: ShowCaseVC.titleElementKind,
                alignment: .top)
            section.boundarySupplementaryItems = [titleSupplementary]
            return section
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        
        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: sectionProvider, configuration: config)
        return layout
    }
}


extension ShowCaseVC {
    func configureHierarchy() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .init(white: 0, alpha: 0)
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration
        <ExploreCharityCell, CharityController.CharityC> { (cell, indexPath, charity) in
            // Populate the cell with our item description.
            
            cell.titleLabel.text = charity.title
            cell.imageView.image = charity.image
        }
        
        dataSource = UICollectionViewDiffableDataSource
        <CharityController.CharityCollection, CharityController.CharityC>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, charity: CharityController.CharityC) -> UICollectionViewCell? in
            // Return the cell.
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: charity)
        }
        
        let supplementaryRegistration = UICollectionView.SupplementaryRegistration
        <TitleSupplementaryView>(elementKind: "Footer") {
            (supplementaryView, string, indexPath) in
            if let snapshot = self.currentSnapshot {
                // Populate the view with our section's description.
                let charityCategory = snapshot.sectionIdentifiers[indexPath.section]
                supplementaryView.label.text = charityCategory.title
            }
        }
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(
                using: supplementaryRegistration, for: index)
        }
        
        currentSnapshot = NSDiffableDataSourceSnapshot
        <CharityController.CharityCollection, CharityController.CharityC>()
        charityController.collections.forEach {
            let collection = $0
            currentSnapshot.appendSections([collection])
            currentSnapshot.appendItems(collection.videos)
        }
        dataSource.apply(currentSnapshot, animatingDifferences: false)
    }
}

class TitleSupplementaryView: UICollectionReusableView {
    let label = UILabel()
    let viewAllButton = UIButton()
    static let reuseIdentifier = "title-supplementary-reuse-identifier"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension TitleSupplementaryView {
    func configure() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.adjustsFontForContentSizeCategory = true
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
        viewAllButton.setTitleColor(.blue, for: .normal)
        viewAllButton.snp.makeConstraints { (maker) in
            maker.top.equalTo(snp.top).offset(inset)
            maker.right.equalTo(snp.right).offset(-inset)
            maker.bottom.equalTo(snp.bottom).offset(-inset)
        }
    }
}
