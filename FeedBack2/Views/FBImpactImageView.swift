//
//  FBImpactImageView.swift
//  FeedBack2
//
//  Created by Julian Gierl on 05.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

class FBImpactImageView: UIImageView{
    
    static let placeholderImage = UIImage(named: "avatar-placeholder")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 2
        clipsToBounds = true
    }
    
    func setImage(imageUrl: String, completed: @escaping(FBError?) -> Void){
        let image = ImageCache.shared.getImage(for: imageUrl)
        if(image != nil){
            DispatchQueue.main.async {
                self.image = image
                completed(nil)
            }
        }else{
            downloadLogoImage(imageUrl) { (error) in
                completed(error)
            }
        }
    }
    
    private func downloadLogoImage(_ imageUrl: String, completed: @escaping(FBError?) -> Void) {
        let networkManager = NetworkManager()
        networkManager.downloadImage(urlString: imageUrl) { [weak self](result) in
            guard let self = self else {return}
            switch(result){
            case .failure(let error):
                completed(error)
                print(error)
            case .success(let logoImage):
                ImageCache.shared.setImage(image: logoImage, key: imageUrl)
                DispatchQueue.main.async {
                    self.image = logoImage
                    completed(nil)
                }
            }
        }
    }
}
