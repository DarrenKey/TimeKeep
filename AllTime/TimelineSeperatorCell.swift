//
//  TimelineSeperatorCell.swift
//  TimeKeep
//
//  Created by Mi Yan on 5/7/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//

import UIKit

class TimelineSeperatorCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var seperatorView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
