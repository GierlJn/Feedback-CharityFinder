//
//  ImageCache.swift
//  FeedBack2
//
//  Created by Julian Gierl on 02.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

class ImageCache{
    static let shared = ImageCache()
    
    private init(){}
    
    let cache = NSCache<NSString, UIImage>()
    
    func setImage(image: UIImage, key: String){
        cache.setObject(image, forKey: NSString(string: key))
    }
    
    func getImage(for key: String)->UIImage?{
        return cache.object(forKey: NSString(string: key))
    }
    
    func hasImage(for key: String)->Bool{
        if(cache.object(forKey: NSString(string: key)) != nil){
            return true
        }else {
            return false
        }
    }
}
