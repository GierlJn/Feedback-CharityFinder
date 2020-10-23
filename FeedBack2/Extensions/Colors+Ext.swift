//
//  Colors.swift
//  FeedBack2
//
//  Created by Julian Gierl on 08.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit



extension UIColor {
    static var pineApplePurple: UIColor { return UIColor(rgb: 0x413C58)}
    static var columbiaBlue: UIColor { return UIColor(rgb: 0xC4D7F2)}
    static var cambridgeBlue: UIColor { return UIColor(rgb: 0xA3C4BC)}
    static var turquoiseGreen: UIColor { return UIColor(rgb: 0xBFD7B5)}
    static var lightBlueBackground: UIColor { return UIColor(rgb: 0xEAD7ED)}
    static var buttonDarkBlue: UIColor { return UIColor(rgb: 0x5637D1)}
    static var buttonDarkBlueGradientStart: UIColor { return UIColor(rgb: 0xAE71E0)}
    static var buttonDarkBlueGradientEnd: UIColor { return UIColor(rgb: 0x7573FF)}
    static var hedaerViewGradientStart: UIColor { return UIColor(rgb: 0xab6fdb)}
    static var headerViewGradientEnd: UIColor { return UIColor(rgb: 0x2c299a)}
    static var lightBlueBackgroundGradientStart: UIColor { return UIColor(rgb: 0xFFF6FF)}
    static var lightBlueBackgroundGradientEnd: UIColor { return UIColor(rgb: 0xEAD7ED)}
    static var mainTextColor: UIColor { return UIColor(rgb: 0x676568)}
    static var iconColor: UIColor { return UIColor(rgb: 0xFF797A)}
    static var categoriesTransparentColor: UIColor { return UIColor(rgb: 0xFEF9FC)}
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }}


