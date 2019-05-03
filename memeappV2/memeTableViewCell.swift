//
//  memeTableViewCell.swift
//  memeappV2
//
//  Created by Eslam  on 3/5/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import UIKit

class memeTableViewCell: UITableViewCell {

    
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var topText: UILabel!
    @IBOutlet weak var bottomText: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
