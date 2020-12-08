//
//  FBImpactImageView.swift
//  FeedBack2
//
//  Created by Julian Gierl on 05.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit
import SDWebImage

final class FBImpactImageView: UIImageView{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFit
        backgroundColor = .systemGray6
        self.image = Images.imagePlaceholder!
    }
    
    func setImage(imageUrl: String?, completed: @escaping () -> ()){
        guard let imageUrl = imageUrl else {
            completed()
            return
        }
        sd_setImage(with: URL(string: imageUrl)) { [weak self](image, error, type, url) in
            guard let self = self else { return }
            if error == nil{
                self.contentMode = .scaleToFill
            }
            completed()
            return
        }
    }
}
