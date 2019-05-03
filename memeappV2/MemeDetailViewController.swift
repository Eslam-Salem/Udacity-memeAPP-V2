//
//  MemeDetailViewController.swift
//  memeappV2
//
//  Created by Eslam  on 3/5/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    
    @IBOutlet weak var memedDetailedImage: UIImageView!
    var memeImage : UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {

        self.memedDetailedImage.image = self.memeImage
    }


}
