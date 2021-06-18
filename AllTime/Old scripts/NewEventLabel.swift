//
//  NewEventLabel.swift
//  Calendar
//
//  Created by Mi Yan on 1/26/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//

import UIKit

class NewEventLabel: UITableViewCell {

    @IBOutlet weak var newEventLabel: UILabel!
    
    @IBOutlet weak var xButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
