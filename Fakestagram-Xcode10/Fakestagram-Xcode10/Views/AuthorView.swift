//
//  AuthorView.swift
//  Fakestagram-Xcode10
//
//  Created by Alejandro Mendoza D4 on 10/12/19.
//  Copyright © 2019 unam. All rights reserved.
//

import UIKit

class AuthorView: UIView {
    let avatar: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage()
        
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Some text"
        return label
    }()
    
    convenience init(){
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupConstraints()
    }
    
    func setupConstraints() {
        addSubview(avatar)
        
        avatar.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        avatar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
        avatar.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}
