//
//  overridetextTableViewCell.swift
//  Calendar
//
//  Created by Mi Yan on 2/27/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//

import UIKit

class overridetextTableViewCell: UITableViewCell {

    @IBOutlet weak var textT: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let screenHeight = UIScreen.main.bounds.height
        textT.font = textT.font.withSize(min(30,30 * screenHeight/842))
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
