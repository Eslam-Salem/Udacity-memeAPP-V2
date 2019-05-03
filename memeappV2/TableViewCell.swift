//
//  TableViewCell.swift
//  memeappV2
//
//  Created by Eslam  on 3/3/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var memText: UILabel!

    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
