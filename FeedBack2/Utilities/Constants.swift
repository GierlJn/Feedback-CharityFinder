//
//  Constants.swift
//  FeedBack2
//
//  Created by Julian Gierl on 10.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

enum Images {
    static let image_placeholder = UIImage(named: "logo_heart_transparent")
    static let logo_placeholder = UIImage(named: "logo_heart_transparent")
    static let searchActionButton = UIImage(systemName: "slider.horizontal.3")
    static let backButton = UIImage(systemName: "chevron.left.square.fill")
    static let bookMarkFill = UIImage(systemName: "bookmark.fill")!
    static let bookMark = UIImage(systemName: "bookmark")!
    static let magnifyingGlass = UIImage(systemName: "magnifyingglass")!
    static let facebookIcon = UIImage(named: "facebook_icon")!
    static let twitterIcon = UIImage(named: "twitter_icon")!
    static let whatsappIcon = UIImage(named: "whatsapp_icon")!
    static let outputLogoIcon = UIImage(named: "outputlogo1")!
}

enum URLS {
    static let soGiveUrl = URL(string: "https://sogive.org/")!
}

enum ScreenSize {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let maxLength = max(ScreenSize.width, ScreenSize.height)
    static let minLength = min(ScreenSize.width, ScreenSize.height)
}


enum DeviceType {
    static let idiom = UIDevice.current.userInterfaceIdiom
    static let nativeScale = UIScreen.main.nativeScale
    static let scale = UIScreen.main.scale
    
    static let isiPhoneSE = idiom == .phone && ScreenSize.maxLength == 568.0
    static let isiPhone8Standard = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale == scale
    static let isiPhone8Zoomed  = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale > scale
    static let isiPhone8PlusStandard = idiom == .phone && ScreenSize.maxLength == 736.0
    static let isiPhone8PlusZoomed = idiom == .phone && ScreenSize.maxLength == 736.0 && nativeScale < scale
    static let isiPhoneX = idiom == .phone && ScreenSize.maxLength == 812.0
    static let isiPhoneXsMaxAndXr = idiom == .phone && ScreenSize.maxLength == 896.0
    static let isiPad = idiom == .pad && ScreenSize.maxLength >= 1024.0

    static func isiPhoneXAspectRation() -> Bool {
        return isiPhoneX || isiPhoneXsMaxAndXr
    }
}
