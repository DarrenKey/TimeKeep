//
//  HourFormat.swift
//  TimeKeep
//
//  Created by Mi Yan on 5/9/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//

import UIKit
import Charts

class HourFormat: IAxisValueFormatter{
    var monthArray = [12,1,2,3,4,5,6,7,8,9,10,11]
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        //am and pm at 12
        //hour format
        let hour = monthArray[Int(value/60) % 12]
        let minute = Int((value).truncatingRemainder(dividingBy: 60))
        var timeString = ""
        if minute < 10{
            timeString += "\(hour):0\(minute)"
        }
        else{
            timeString += "\(hour):\(minute)"
        }
        
        if value < 720{
            timeString += " AM"
        }
        else if value < 1440{
            timeString += " PM"
        }
        else if value == 1440{
            timeString += " AM"
        }
        return timeString
    }
}
