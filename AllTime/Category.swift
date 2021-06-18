//
//  Category.swift
//  TimeKeep
//
//  Created by Mi Yan on 4/17/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//

import Foundation
import RealmSwift

//save category info
class Category: Object{
    @objc dynamic var name = ""
    
    //hsba of color
    @objc dynamic var h: Float = 0.0
    @objc dynamic var s: Float = 0.0
    @objc dynamic var b: Float = 0.0
    @objc dynamic var a: Float = 0.0
    
    //category color number
    //if -1 => no colorNum
    @objc dynamic var colorNum: Int = -1
    
    let time = List<Date>()
    @objc dynamic var displayTime: Double = 0.0
    
    ///List of dates to be added and modified with because it's in the future
    let timeToBeAdded = List<Date>()
    
    ///last reset date; nil = never reset
    @objc dynamic var lastResetDate: Date? = nil
}
