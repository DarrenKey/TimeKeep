//
//  alarmT.swift
//  Calendar
//
//  Created by Mi Yan on 1/1/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//

import UIKit

class alarmT: UITableViewCell{
    
    @IBOutlet weak var alarmText: UILabel!
    @IBOutlet weak var labelT: UILabel!
    @IBOutlet weak var switchT: UISwitch!
    var whenAlarm = Date()
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy h:mm a"
        var selectedDate = dateFormatter.string(from: whenAlarm)

        datePicker.setDate(whenAlarm, animated: true)
        
        // change font color
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        datePicker.datePickerMode = .countDownTimer
        datePicker.datePickerMode = .dateAndTime //or whatever your original mode was
        
        
        if Singleton.isEditingEvent == true{
            let arrayOfEverything = Singleton.dayDict[Singleton.dateTracker]?[Singleton.pathOfCellEvent] as! [Any]
            if arrayOfEverything[6] as? Date != nil{
                let alarmT = arrayOfEverything[6] as! Date
                switchT.setOn(true, animated: false)
                datePicker.setDate(alarmT, animated: false)
                selectedDate = dateFormatter.string(from: alarmT)
            }
        }
        
        labelT.text = selectedDate
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
        // Configure the view for the selected state
    }
    
    @IBAction func datePickerVC(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy h:mm a"
        let selectedDate = dateFormatter.string(from: datePicker.date)
        
        
        //when the alarm should come
        whenAlarm = datePicker.date
        
        labelT.text = selectedDate
    }
    
  
}
