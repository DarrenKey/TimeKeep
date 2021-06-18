//
//  TaskSaved.swift
//  TimeKeep
//
//  Created by Mi Yan on 4/30/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//

import Foundation
import RealmSwift

//save category info
class TaskSaved: Object{
    @objc dynamic var name = ""
    
    //hsba of color
    @objc dynamic var h: Float = 0.0
    @objc dynamic var s: Float = 0.0
    @objc dynamic var b: Float = 0.0
    @objc dynamic var a: Float = 0.0
    
    //color number
    @objc dynamic var colorNum: Int = -1
    
    //startdate
    @objc dynamic var startMonth: Int = 0
    @objc dynamic var startDay: Int = 0
    
    //enddate
    @objc dynamic var endMonth: Int = 0
    @objc dynamic var endDay: Int = 0
    
    //category
    @objc dynamic var category: Int = 0
    @objc dynamic var categoryName: String = ""
    
    //whether or not alarm enabled
    @objc dynamic var alarmEnabled: Bool = false
    
    //alarmdate
    @objc dynamic var alarmMonth: Int = 0
    @objc dynamic var alarmDay: Int = 0
    @objc dynamic var alarmHour: Int = 0
    @objc dynamic var alarmMinute: Int = 0
    
    //alarm id
    @objc dynamic var alarmID: String = ""
    
    //list of dates
    let doneTasks = List<Date>()
}
