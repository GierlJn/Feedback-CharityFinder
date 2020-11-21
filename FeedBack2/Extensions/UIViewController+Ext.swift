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
    
    func presentErrorAlert(_ error: FBError){
        presentGFAlertOnMainThread(title: FBError.titleMessage, message: error.errorMessage, buttonTitle: "Ok")
    }
    
    func presentGFAlertOnMainThread(title: String, message: String, buttonTitle: String){
        DispatchQueue.main.async {
            let alert = FBAlertVC(title: title, message: message, actionButtonTitle: buttonTitle)
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
    
    func hideLoadingSubView(in view: UIView){
        DispatchQueue.main.async {
            view.subviews.forEach { (view) in
                if(view.tag == 13){
                    view.removeFromSuperview()
                }
            }
            if(containerView != nil){
                containerView!.removeFromSuperview()
                containerView = nil
                
            }
            
        }
    }
    
    func showLoadingSubView(in view: UIView){
        DispatchQueue.main.async {
        guard  containerView == nil else { return }
        
        containerView = UIView()
        containerView.tag = 13
        view.addSubview(containerView!)
        containerView!.pinToEdges(of: view)
        containerView!.alpha = 1
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.tag = 13
        containerView!.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(containerView!.snp.centerX)
            maker.centerY.equalTo(containerView!.snp.centerY)
        }
        loadingIndicator.startAnimating()
        }
    }
    
    
}
