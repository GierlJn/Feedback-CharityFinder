//
//  FBLogoImageView.swift
//  FeedBack2
//
//  Created by Julian Gierl on 02.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit

class FBLogoImageView: UIImageView{
    
    let placeholderImage = UIImage(named: "avatar-placeholder")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        layer.cornerRadius = 15
        clipsToBounds = true
    }
    
    func setLogoImage(logoUrl: String){
        let logoImage = ImageCache.shared.getImage(for: logoUrl)
        if(logoImage != nil){
            image = logoImage
        }else{
            downloadLogoImage(logoUrl)
        }
    }
    
    private func downloadLogoImage(_ logoUrl: String) {
        let networkManager = NetworkManager()
        networkManager.downloadLogo(urlString: logoUrl) { [weak self](result) in
            guard let self = self else {return}
            switch(result){
            case .failure(let error):
                print(error)
            case .success(let logoImage):
                self.image = logoImage
            }
        }
    }
}