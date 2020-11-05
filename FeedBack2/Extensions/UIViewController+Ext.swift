//
//  UIViewController+Ext.swift
//  FeedBack2
//
//  Created by Julian Gierl on 06.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit
import SafariServices

fileprivate var containerView: UIView!

extension UIViewController{
    
    func presentFavoriteAlert(charity: Charity, completed: @escaping (Bool) -> ()){
        PersistenceManager.isCharityFavorite(charity: charity) { [self] (isFavourite) in
            if (isFavourite){
                PersistenceManager.updateFavorites(charity: charity, persistenceActionType: .remove) { (error) in
                    if ((error) != nil){
                        presentGFAlertOnMainThread(title: "Error", message: error!.errorMessage, buttonTitle: "Ok")
                    }
                    else{
                        //charityTitleLabelView.isFavourite = false
                        presentGFAlertOnMainThread(title: "Removed", message: "\(charity.name) has been removed from your favorites", buttonTitle: "Ok")
                        completed(false)
                        
                    }
                }
            }else{
                PersistenceManager.updateFavorites(charity: charity, persistenceActionType: .add) { (error) in
                    if ((error) != nil){
                        presentGFAlertOnMainThread(title: "Error", message: error!.errorMessage, buttonTitle: "Ok")
                    }
                    else{
                        //charityTitleLabelView.isFavourite = true
                        presentGFAlertOnMainThread(title: "Added", message: "\(charity.name) has been added to your favorites", buttonTitle: "Ok")
                        completed(true)
                    }
                }
            }
        }
    }
    
    func presentGFAlertOnMainThread(title: String, message: String, buttonTitle: String){
        DispatchQueue.main.async {
            let alert = FBAlertVC(title: title, message: message, buttonTitle: buttonTitle)
            alert.modalPresentationStyle = .overFullScreen
            alert.modalTransitionStyle = .crossDissolve
            self.present(alert, animated: true)
        }
    }
    
    func presentCurrencySelectionOnMainThread(){
        DispatchQueue.main.async {
            let vc = CurrencySelectionVC()
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true)
        }
    }
    
    func presentSafariVC(with url: URL){
           let safariVC = SFSafariViewController(url: url)
           safariVC.preferredControlTintColor = .systemBlue
           present(safariVC, animated: true)
       }
    
    func add(childVC: UIViewController, to containerView: UIView){
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    func showLoadingView(){
        containerView = UIView()
        view.addSubview(containerView)
        containerView.pinToEdges(of: view)
        containerView.backgroundColor = .lightBlueBackgroundGradientEnd
        containerView.alpha = 1
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(containerView.snp.centerX)
            maker.centerY.equalTo(containerView.snp.centerY)
        }
        loadingIndicator.startAnimating()
    }
    
    func hideLoadingView(){
        DispatchQueue.main.async {
            if(containerView != nil){ containerView.removeFromSuperview()}
            containerView = nil
        }
    }
}
