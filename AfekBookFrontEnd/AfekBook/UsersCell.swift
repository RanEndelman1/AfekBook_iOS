//
//  UsersCell.swift
//  AfekBook
//
//  Created by Ran Endelman on 05/11/2017.
//  Copyright © 2017 Ran Endelman. All rights reserved.
//

import UIKit

class UsersCell: UITableViewCell {

    @IBOutlet var fullnameLbl: UILabel!
    @IBOutlet var usernameLbl: UILabel!
    @IBOutlet var avaImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()

        // round corners
        avaImg.layer.cornerRadius = avaImg.bounds.width / 2
        avaImg.clipsToBounds = true

        // color
        usernameLbl.textColor = colorBrandBlue
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
