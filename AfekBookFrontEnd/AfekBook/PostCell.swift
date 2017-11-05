//
//  PostCell.swift
//  AfekBook
//
//  Created by Ran Endelman on 04/11/2017.
//  Copyright © 2017 Ran Endelman. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    @IBOutlet var userNameLbl: UILabel!
    @IBOutlet var textLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var pictureImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()

        userNameLbl.textColor = colorBrandBlue
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
