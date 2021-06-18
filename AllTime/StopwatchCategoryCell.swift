//
//  StopwatchCategoryCell.swift
//  TimeKeep
//
//  Created by Mi Yan on 5/3/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//

import UIKit

class StopwatchCategoryCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var seperatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
