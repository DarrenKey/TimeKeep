//
//  textFieldinNewEventTableViewCell.swift
//  Calendar
//
//  Created by Mi Yan on 1/1/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//

import UIKit

class textFieldinNewEventTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var nameViewBox: UIView!
    @IBOutlet weak var textFieldCell: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textFieldCell.delegate = self
        
        nameViewBox.layer.borderWidth = 3
        nameViewBox.layer.borderColor = UIColor(red: 134/255, green: 134/255, blue: 134/255, alpha: 1).cgColor
        // Initialization code
        if Singleton.isEditingEvent == true{
            let arrayOfEverything = Singleton.dayDict[Singleton.dateTracker]?[Singleton.pathOfCellEvent] as! [Any]
            let name = arrayOfEverything[0] as! String
            textFieldCell.text = name
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        (self.superview?.endEditing(true))!
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
