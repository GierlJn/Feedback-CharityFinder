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
        
        UITabBar.appearance().tintColor = .systemBlue
        viewControllers = [createSearchVC(), createFavoritesVC()]
    }
    
    
    private func createSearchVC() -> UINavigationController{
        let searchVC = SearchVC()
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        return UINavigationController(rootViewController: searchVC)
    }
    
    private func createFavoritesVC() -> UINavigationController{
        let favouritesVC = FavouritesVC()
        favouritesVC.title = "Favourites"
        favouritesVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        return UINavigationController(rootViewController: favouritesVC)
    }

}
