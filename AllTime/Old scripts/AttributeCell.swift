//
//  AttributeCell.swift
//  Calendar
//
//  Created by Mi Yan on 12/29/19.
//  Copyright © 2019 Darren Key. All rights reserved.
//

import UIKit

class AttributeCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var textviewT: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
