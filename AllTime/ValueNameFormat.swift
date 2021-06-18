//
//  ValueNameFormat.swift
//  TimeKeep
//
//  Created by Mi Yan on 7/11/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//

import UIKit
import Charts

class ValueNameFormat: IValueFormatter{
    
    
    //lazy solution - find value and replace name
    //should FIX later but right now this is the best solution I have
    //:( please FIX
    var timelineArray: [Double] = []
    var nameString: [String] = []
    
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        if timelineArray.count == 0{
            return ""
        }
        else if nameString.count == 0{
            return ""
        }
        return nameString[timelineArray.firstIndex(of: value) ?? 0]
    }
}
