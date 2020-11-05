//
//  FBImpactImageView.swift
//  FeedBack2
//
//  Created by Julian Gierl on 05.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit
import SDWebImage

class FBImpactImageView: UIImageView{
    
    let networkManager = NetworkManager()
    
    let insetValue: CGFloat = -20
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        translatesAutoresizingMaskIntoConstraints = false
        //layer.cornerRadius = 2
        //clipsToBounds = true
        contentMode = .scaleAspectFit
        backgroundColor = .systemGray6
        self.image = Images.image_placeholder!//.withAlignmentRectInsets(UIEdgeInsets(top: insetValue, left: insetValue*4, bottom: insetValue, right: insetValue*4))
    }
    
    func setImage(imageUrl: String?, completed: @escaping () -> ()){
        guard let imageUrl = imageUrl else {
            completed()
            return }
        sd_setImage(with: URL(string: imageUrl)) { [weak self](image, error, type, url) in
            guard let self = self else { return }
            if( error == nil){
                self.contentMode = .scaleToFill
            }
            completed()
        }
    }
    
//    private func downloadImage(_ imageUrl: String, completed: @escaping(FBError?) -> Void) {
//        networkManager.downloadImage(urlString: imageUrl) { [weak self](result) in
//            guard let self = self else {return}
//            switch(result){
//            case .failure(let error):
//                completed(error)
//            case .success(let logoImage):
//                ImageCache.shared.setImage(image: logoImage, key: imageUrl)
//                DispatchQueue.main.async {
//                    self.image = logoImage
//                    completed(nil)
//                }
//            }
//        }
//    }
}
