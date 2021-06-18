//
//  datePickerCell.swift
//  Calendar
//
//  Created by Mi Yan on 1/1/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//

import UIKit

class datePickerCell: UITableViewCell{

    @IBOutlet weak var fromOrTo: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var dateP = Date()
    
    @IBOutlet weak var labelT: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy h:mm a"
        let selectedDate = dateFormatter.string(from: dateP)

        
        let screenHeight = UIScreen.main.bounds.height
        fromOrTo.font = fromOrTo.font.withSize(min(40,40 * screenHeight/842))
        
        datePicker.setDate(dateP, animated: true)
        
        // change font color
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        datePicker.datePickerMode = .countDownTimer
        datePicker.datePickerMode = .dateAndTime //or whatever your original mode was
        
        
        labelT.text = selectedDate

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state6    }
    }
    
    @IBAction func datePickerVC(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy h:mm a"
        let selectedDate = dateFormatter.string(from: datePicker.date)
        
        dateP = datePicker.date
        
        labelT.text = selectedDate
    }
}
