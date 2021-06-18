//
//  NewTaskCategoryCell.swift
//  TimeKeep
//
//  Created by Mi Yan on 4/27/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//

import UIKit
import BEMCheckBox

class NewTaskCategoryCell: UITableViewCell {

    @IBOutlet weak var seperator: UIView!
    @IBOutlet weak var checkMark: BEMCheckBox!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var categoryName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
