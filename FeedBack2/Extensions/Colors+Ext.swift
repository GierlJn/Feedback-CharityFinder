//
//  Colors.swift
//  FeedBack2
//
//  Created by Julian Gierl on 08.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

extension UIColor {
    static var standardButton = UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .dark:
            return UIColor(rgb: 0x286885)
        default:
            return UIColor(rgb: 0x2c299a)
        }
    }
    
    static var categoriesTransparentColor =  UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .dark:
            return UIColor(rgb: 0xf5f5f5)
        default:
            return .white
        }
    }
    
    static var textTitleLabel =  UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .dark:
            return UIColor(rgb: 0xf5f5f5)
        default:
            return .black
        }
    }
    
    static var headerViewGradientStart =  UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .dark:
            return UIColor(rgb: 0x302b63)
        default:
          return UIColor(rgb: 0xab6fdb)
        }
    }
    
    static var headerViewGradientEnd =  UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .dark:
            return UIColor(rgb: 0x24243e)
        default:
          return UIColor(rgb: 0x2c299a)
        }
    }
    
    static var favoriteButton =  UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .dark:
            return UIColor(rgb: 0x24243e)
        default:
          return UIColor(rgb: 0x4A758F)
        }
    }
    
    static var whyTagView =  UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .dark:
            return lightGray
        default:
          return UIColor(rgb: 0x008395)
        }
    }
    
    static var locationTagView =  UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .dark:
            return systemGray
        default:
          return UIColor(rgb: 0xB2A8B8)
        }
    }
    
    static var outputColor = UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .dark:
            return UIColor(rgb: 0xEAD7ED)
            
        default:
            return UIColor(rgb: 0x4A758F)
        }
    }
    
    static var aboutCharityTextColor =  UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .dark:
            return white
        default:
          return UIColor(rgb: 0x4C4452)
        }
    }
    
    static var headerButtonGradientStart =  UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .dark:
            return UIColor(rgb: 0x286885)
        default:
          return UIColor(rgb: 0xab6fdb)
        }
    }
    
    static var headerButtonGradientEnd =  UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .dark:
            return UIColor(rgb: 0x294463)
        default:
          return UIColor(rgb: 0x2c299a)
        }
    }
    
    
    static var lightBlueBackgroundGradientStart =  UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .dark:
            return UIColor(rgb: 0x434343)
        default:
          return UIColor(rgb: 0xFFF6FF)
        }
    }
    
    static var lightBlueBackgroundGradientEnd =  UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .dark:
            return UIColor(rgb: 0x000000)
        default:
          return UIColor(rgb: 0xEAD7ED)
        }
    }
    
    static var logoImageBackground = UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .dark:
            return UIColor.init(white: 0, alpha: 0 )
        default:
            return UIColor.white
        }
    }
        
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


