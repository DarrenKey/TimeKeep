//
//  ChartsFormat.swift
//  TimeKeep
//
//  Created by Mi Yan on 5/16/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//

import UIKit
import Charts

class ChartsFormat: IAxisValueFormatter{
    var monthArray = [12,1,2,3,4,5,6,7,8,9,10,11]
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let hour = monthArray[Int(value/60) % 12]
        let minute = Int((value).truncatingRemainder(dividingBy: 60))
        if minute < 10{
            return "\(hour):0\(minute)"
        }
        else{
            return "\(hour):\(minute)"
        }
    }
}
