//
//  UIViewController+Ext.swift
//  FeedBack2
//
//  Created by Julian Gierl on 06.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit
import SafariServices

extension UIViewController{
    func presentSafariVC(with url: URL){
           let safariVC = SFSafariViewController(url: url)
           safariVC.preferredControlTintColor = .systemBlue
           present(safariVC, animated: true)
       }
}
