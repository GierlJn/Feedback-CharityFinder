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
        contentMode = .scaleAspectFit
    }
    
    func setRoundCorners(){
        layer.cornerRadius = 16
        clipsToBounds = true
    }
    
    func setLogoImage(urlString: String?){
        guard let logoString = urlString else { return }
        guard let logoUrl = URL(string: logoString) else { return }
        self.sd_setImage(with: logoUrl, placeholderImage: Images.imagePlaceholder!, completed: { (image, error, cache, url) in
        })

        }
}
