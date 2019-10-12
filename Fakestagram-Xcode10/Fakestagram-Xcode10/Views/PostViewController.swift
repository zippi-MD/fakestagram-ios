//
//  PostViewController.swift
//  Fakestagram-Xcode10
//
//  Created by Alejandro Mendoza D4 on 10/12/19.
//  Copyright © 2019 unam. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likeCounter: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func onTapLike(_ sender: Any) {
    }
    @IBAction func onTapCreateComment(_ sender: Any) {
    }
    @IBAction func onTapToggleComments(_ sender: Any) {
    }
    

}
