//
//  FBLogoImageView.swift
//  FeedBack2
//
//  Created by Julian Gierl on 02.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit
import SDWebImage

class FBLogoImageView: UIImageView{
    
    let insetValue: CGFloat = -16
    let networkManager = NetworkManager()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        //translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFit
        //self.image = Images.image_placeholder!
        //self.image!.withAlignmentRectInsets(UIEdgeInsets(top: self.insetValue, left: self.insetValue, bottom: self.insetValue, right: self.insetValue))
        //backgroundColor = .logoImageBackground
    }
    
    func setRoundCorners(){
        layer.cornerRadius = 16
        clipsToBounds = true
    }
    
    func setLogoImage(urlString: String?){
        guard let logoString = urlString else { return }
        guard let logoUrl = URL(string: logoString) else { return }
        self.sd_setImage(with: logoUrl, placeholderImage: Images.image_placeholder!, completed: { (image, error, cache, url) in
        })
        
//            guard let logoUrl = logoUrl else { return }
//            guard let logoImage = ImageCache.shared.getImage(for: logoUrl) else{
//                downloadLogoImage(logoUrl)
//                return
//            }
//            self.image = logoImage.withAlignmentRectInsets(UIEdgeInsets(top: self.insetValue, left: self.insetValue, bottom: self.insetValue, right: self.insetValue))

        }
    
    private func downloadLogoImage(_ logoUrl: String) {
        networkManager.downloadImage(urlString: logoUrl) { [weak self](result) in
            guard let self = self else {return}
            switch(result){
            case .failure(let error):
                print(error)
            case .success(let logoImage):
                DispatchQueue.main.async {
                    self.image = logoImage.withAlignmentRectInsets(UIEdgeInsets(top: self.insetValue, left: self.insetValue, bottom: self.insetValue, right: self.insetValue))
                        ImageCache.shared.setImage(image: logoImage, key: logoUrl)
                }
                
            }
        }
    }
}
