//
//  ShowCaseVC.swift
//  FeedBack2
//
//  Created by Julian Gierl on 16.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

protocol ShowCaseVCDelegate{
    func showCharityInfo(charityId: String, charity: Charity)
    func showCategories(category: Category)
    func finishedLoading()
}


final class ShowCaseVC: UIViewController{
    
    let charityController = CharityCollectionManager()
    var collectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<CharityCollectionManager.CharityCollection, Charity>! = nil
    var currentSnapshot: NSDiffableDataSourceSnapshot<CharityCollectionManager.CharityCollection, Charity>! = nil
    static let titleElementKind = "title-element-kind"
    static let footerElementKind = "footer-element-kind"
    
    var delegate: ShowCaseVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
        loadCharities()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

extension ShowCaseVC {
    func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { [self] (sectionIndex: Int,
                                        layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
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
            
            if(sectionIndex == self.charityController.collections.count-1){
                let footerSupplementary = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                                                         heightDimension: .estimated(60)),
                                                                                      elementKind: ShowCaseVC.footerElementKind,
                                                                                      alignment: .bottom)
                section.boundarySupplementaryItems.append(footerSupplementary)
            }

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
        collectionView.pinToEdges(of: view)
        collectionView.delegate = self
    }
    
    func configureDataSource() {
        let cellRegistration = createCellRegistration()
        
        dataSource = UICollectionViewDiffableDataSource<CharityCollectionManager.CharityCollection, Charity>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, charity: Charity) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: charity)
        }
        
        let headerSupplementaryRegistration = createHeaderSupplementary()
        let footerSupplementaryRegistration = createFooterSupplementary()
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            if(kind == ShowCaseVC.titleElementKind){
                return self.collectionView.dequeueConfiguredReusableSupplementary(
                    using: headerSupplementaryRegistration, for: index)
            }else{
                return self.collectionView.dequeueConfiguredReusableSupplementary(
                    using: footerSupplementaryRegistration, for: index)
            }
        }
    }
    
    fileprivate func createCellRegistration() -> UICollectionView.CellRegistration<ExploreCharityCell, Charity> {
        return UICollectionView.CellRegistration
        <ExploreCharityCell, Charity> { (cell, indexPath, charity) in
            cell.titleLabel.text = charity.name
            cell.imageView.setLogoImage(urlString: charity.logoUrl)
        }
    }
    
    fileprivate func createHeaderSupplementary() -> UICollectionView.SupplementaryRegistration<HeaderSupplementaryView> {
        return UICollectionView.SupplementaryRegistration
        <HeaderSupplementaryView>(elementKind: "Header") {
            (supplementaryView, string, indexPath) in
            if let snapshot = self.currentSnapshot {
                let charityCollection = snapshot.sectionIdentifiers[indexPath.section]
                supplementaryView.label.text = charityCollection.title
                supplementaryView.category = charityCollection.category
                supplementaryView.delegate = self
            }
        }
    }
    
    fileprivate func createFooterSupplementary() -> UICollectionView.SupplementaryRegistration<FooterSupplementaryView> {
        return UICollectionView.SupplementaryRegistration
        <FooterSupplementaryView>(elementKind: "Footer") {
            (supplementaryView, string, indexPath) in
            supplementaryView.delegate = self
        }
    }
    
    fileprivate func applyCurrentSnapshot() {
        currentSnapshot = NSDiffableDataSourceSnapshot
        <CharityCollectionManager.CharityCollection, Charity>()
        charityController.collections.forEach {
            let collection = $0
            currentSnapshot.appendSections([collection])
            currentSnapshot.appendItems(collection.charities)
        }
        dataSource.apply(currentSnapshot, animatingDifferences: false)
    }
    
    fileprivate func loadCharities() {
        charityController.loadInitialCharities { [weak self] (error) in
            guard let self = self else { return }
            self.delegate?.finishedLoading()
            guard let error = error else {
                self.applyCurrentSnapshot()
                return
            }
            self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.errorMessage, buttonTitle: "Ok")
        }
    }
}

extension ShowCaseVC: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let collections = charityController.collections[indexPath.section]
        let charity = collections.charities[indexPath.row]
        delegate?.showCharityInfo(charityId: charity.id, charity: charity)
    }
}

extension ShowCaseVC: FooterSupplementaryViewDelegate{
    
    func buttonPressed() {
        DispatchQueue.main.async {
            let fbAlertVC = FBAlertVC(title: "Notice", message: "This will open a link in your browser", actionButtonTitle: "Ok", dismissButtonTitle: "Cancel"){ [weak self] in
                guard let self = self else { return }
                self.presentSafariVC(with: URLS.soGiveUrl)
            }
            fbAlertVC.modalPresentationStyle = .overFullScreen
            fbAlertVC.modalTransitionStyle = .crossDissolve
            self.present(fbAlertVC, animated: true)
        }
    }
}

extension ShowCaseVC: HeaderSupplementaryViewDelegate{
    
    func viewAllButtonPressed(category: Category) {
        delegate?.showCategories(category: category)
    }
}




