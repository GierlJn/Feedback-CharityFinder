//
//  FBTabBarController.swift
//  FeedBack2
//
//  Created by Julian Gierl on 30.09.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

class FBTabBarController: UITabBarController{
    
    override func viewDidLoad() {
        UITabBar.appearance().tintColor = .headerButtonGradientStart
        viewControllers = [createSearchVC(), createFavoritesVC(), createDonationHistoryVC()]
    }
    
    
    private func createSearchVC() -> UINavigationController{
        let searchVC = SearchVC()
        searchVC.tabBarItem = UITabBarItem(title: "Browse", image: Images.magnifyingGlass, tag: 0)
        return UINavigationController(rootViewController: searchVC)
    }
    
    private func createFavoritesVC() -> UINavigationController{
        let favouritesVC = FavouritesVC()
        favouritesVC.title = "Favorites"
        favouritesVC.tabBarItem = UITabBarItem(title: "Favorites", image: Images.bookMark, selectedImage: Images.bookMarkFill)
        return UINavigationController(rootViewController: favouritesVC)
    }
    
    private func createDonationHistoryVC() -> UINavigationController{
        let donationHistoryVC = DonationHistoryVC()
        donationHistoryVC.title = "Donations"
        donationHistoryVC.tabBarItem = UITabBarItem(title: "Donations", image: Images.scroll, selectedImage: Images.scrollFill)
        return UINavigationController(rootViewController: donationHistoryVC)
    }
    
    
}

