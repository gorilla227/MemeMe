//
//  ViewMemeVC.swift
//  MemeMe
//
//  Created by Andy on 16/5/2.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import UIKit

class ViewMemeVC: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    var memedImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let image = memedImage {
            imageView.image = image
        }
    }
}
