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
    
    let charityController = CharityController()
    var collectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<CharityController.CharityCollection, Charity>! = nil
    var currentSnapshot: NSDiffableDataSourceSnapshot<CharityController.CharityCollection, Charity>! = nil
    static let titleElementKind = "title-element-kind"
    static let footerElementKind = "footer-element-kind"
    
    var firstCharityDataReceived = false
    
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
        let cellRegistration = UICollectionView.CellRegistration
        <ExploreCharityCell, Charity> { (cell, indexPath, charity) in
            cell.titleLabel.text = charity.name
            cell.imageView.setLogoImage(urlString: charity.logoUrl)
        }
        
        dataSource = UICollectionViewDiffableDataSource
        <CharityController.CharityCollection, Charity>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, charity: Charity) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: charity)
        }
        
        let headerSupplementaryRegistration = UICollectionView.SupplementaryRegistration
        <TitleSupplementaryView>(elementKind: "Header") {
            (supplementaryView, string, indexPath) in
            if let snapshot = self.currentSnapshot {
                let charityCollection = snapshot.sectionIdentifiers[indexPath.section]
                supplementaryView.label.text = charityCollection.title
                supplementaryView.category = charityCollection.category
                supplementaryView.delegate = self
            }
        }
        
        let footerSupplementaryRegistration = UICollectionView.SupplementaryRegistration
        <FooterView>(elementKind: "Footer") {
            (supplementaryView, string, indexPath) in
            supplementaryView.delegate = self
        }
        
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
    
    func applyCurrentSnapshot() {
        currentSnapshot = NSDiffableDataSourceSnapshot
        <CharityController.CharityCollection, Charity>()
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

extension ShowCaseVC: FooterViewDelegate{
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

extension ShowCaseVC: TitleSupplementaryViewDelegate{
    func viewAllButtonPressed(category: Category) {
        delegate?.showCategories(category: category)
    }
}


protocol TitleSupplementaryViewDelegate{
    func viewAllButtonPressed(category: Category)
}


class TitleSupplementaryView: UICollectionReusableView {
    let label = UILabel()
    let viewAllButton = UIButton()
    var category: Category!
    static let reuseIdentifier = "title-supplementary-reuse-identifier"
    var delegate: TitleSupplementaryViewDelegate?
    
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
