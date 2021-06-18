
//
//  Routine.swift
//  TimeKeep
//
//  Created by Mi Yan on 5/17/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//

import Foundation
import RealmSwift


//save Routine info
class Routine: Object{
    @objc dynamic var name = ""
    
    //hsba of color
    @objc dynamic var h: Float = 0.0
    @objc dynamic var s: Float = 0.0
    @objc dynamic var b: Float = 0.0
    @objc dynamic var a: Float = 0.0
    
    @objc dynamic var categoryNum: Int = -1
    @objc dynamic var categoryName: String = ""
    
    @objc dynamic var type: String = "Time"
    
    @objc dynamic var numCompleted: Int = 0
    @objc dynamic var goal: Int = 0
    
    @objc dynamic var currentDay: String = ""
    
    @objc dynamic var displayTime: Double = 0
    
    let time = List<Date>()
    
    ///List of dates to be added and modified with because it's in the future
    let timeToBeAdded = List<Date>()
    
    ///last reset date; nil = never reset
    @objc dynamic var lastResetDate: Date? = nil
}
