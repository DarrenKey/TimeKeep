//
//  LabelCellNormalAttribute.swift
//  Calendar
//
//  Created by Mi Yan on 12/30/19.
//  Copyright © 2019 Darren Key. All rights reserved.
//

import UIKit

class LabelCellNormalAttribute: UITableViewCell {

    @IBOutlet weak var imageCell: UIImageView!

    @IBOutlet weak var checkedCircle: UIImageView!
    @IBOutlet weak var cellL: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
       // imageCell.frame = CGRect(x: checkedCircle.frame.origin.x + 0.5 * (checkedCircle.frame.size.width - imageCell.frame.size.width), y: checkedCircle.frame.origin.y + 0.5 * (checkedCircle.frame.size.height - imageCell.frame.size.height), width: imageCell.frame.size.width, height: imageCell.frame.size.height)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
