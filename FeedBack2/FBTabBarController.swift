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
        
        UITabBar.appearance().tintColor = .headerViewGradientEnd
        viewControllers = [createSearchVC(), createFavoritesVC()]
    }
    
    
    private func createSearchVC() -> UINavigationController{
        let searchVC = SearchVC()
        searchVC.tabBarItem = UITabBarItem(title: "Browse", image: Images.magnifyingGlass, tag: 0)
        return UINavigationController(rootViewController: searchVC)
    }
    
    private func createFavoritesVC() -> UINavigationController{
        let favouritesVC = FavouritesVC()
        favouritesVC.tabBarItem = UITabBarItem(title: "Saved", image: Images.bookMark, selectedImage: Images.bookMarkFill)
        return UINavigationController(rootViewController: favouritesVC)
    }

}
