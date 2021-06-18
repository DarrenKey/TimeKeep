//
//  Singleton.swift
//  Calendar
//
//  Created by Mi Yan on 11/1/19.
//  Copyright © 2019 Darren Key. All rights reserved.
//

import Foundation
import UIKit

struct Singleton{
    
    //Global variables - call from anywhere
    
    
    /*four variables for info - categories(category name), attributes(attributes for a category), timeData(time
    for a category), color (color for a category)
    */
    static var categories = [String]()
    
    static var attributes = [[String]]()
    
    //odd elements - when it starts, even elements - when it ends
    static var timeData = [[Date]]()
    
    static var colorsC = [UIColor]()
    
    //time to display
    static var displayTime = [Double]()
    static var displayT: Double = 0
    
    //whether or not category is editing
    static var isEditing = false
    static var pathOfCell = 0
    static var cellName = ""
    static var colorPath = [[Int]]()
    
    
    //for new category from new event tab
    static var newEventCategory = false
    
    
    //number of hue for editing purposes
    static var hue = [Int]()
    
    //all types of attributes
    static var attributesN = [String]()
    
    static var lastReset = Date.distantPast
    
    //for today menu
    static var dateTracker = ""
    static var selectedDate = Date()
    
    //second for animation of trail after ball in stopwatch vc
    static var secondC = 0
    
    //tasks for each day in the form of a dictionary: String(date) -> Array(tasks)
    //Array - [Name,Category,Category Path, UIColor,startTime, endTime, alarm, repeats,  Bool:whether or not marked as complete, UUID string, type]
    //if no alarm, alarm returns nil
    static var dayDict = [String:[[Any?]]]()
    
    //sizeforanimation =in trail animation
    static var sizeForAnimation = CGPoint()
    static var radiusBall = CGFloat()
    static var pathWidth = CGFloat()
    
    //whether or not event is editing
    static var isEditingEvent = false
    static var pathOfCellEvent = 0
    
    //calender creation
    static var dayEnded = [4, 7, 1, 4, 6, 2, 4, 7, 3, 5, 1, 3, 6, 2, 2, 5, 7, 3, 5, 1, 4, 6,2, 4, 7, 3, 3, 6, 1, 4, 6, 2, 5, 7, 3, 5, 1, 4, 4, 7, 2, 5, 7, 3, 6, 1, 4, 6, 2, 5, 6, 2, 4, 7, 2, 5, 1, 3, 6, 1, 4, 7, 7, 3, 5, 1, 3, 6, 2, 4, 7, 2, 5, 1, 1, 4, 6, 2, 4, 7, 3, 5, 1, 3, 6, 2, 2, 5, 7,3, 5, 1, 4, 6, 2, 4, 7, 3, 4, 7, 2, 5, 7, 3, 6, 1, 4, 6, 2, 5, 5, 1, 3, 6, 1, 4, 7, 2, 5, 7, 3, 6, 6, 2, 4, 7, 2, 5, 1, 3, 6, 1, 4, 7, 7, 3, 5, 1, 3, 6, 2, 4, 7, 2, 5, 1, 2, 5, 7, 3, 5, 1, 4, 6, 2, 4,7, 3, 3, 6, 1, 4, 6, 2, 5, 7, 3, 5, 1, 4, 4, 7, 2, 5, 7, 3, 6, 1, 4, 6, 2, 5, 5, 1, 3, 6, 1, 4, 7, 2, 5, 7, 3, 6, 7, 3, 5, 1, 3, 6, 2, 4, 7, 2, 5, 1, 1, 4, 6, 2, 4, 7, 3, 5, 1, 3, 6, 2, 2, 5, 7, 3, 5,1, 4, 6, 2, 4, 7, 3, 3, 6, 1, 4, 6, 2, 5, 7, 3, 5, 1, 4, 5, 1, 3, 6, 1, 4, 7, 2, 5, 7, 3, 6, 6, 2, 4, 7, 2, 5, 1, 3, 6, 1, 4, 7, 7, 3, 5, 1, 3, 6, 2, 4, 7, 2, 5, 1, 1, 4, 6, 2, 4, 7, 3, 5, 1, 3, 6, 2,3, 6, 1, 4, 6, 2, 5, 7, 3, 5, 1, 4, 4, 7, 2, 5, 7, 3, 6, 1, 4, 6, 2, 5, 5, 1, 3, 6, 1, 4, 7, 2, 5, 7, 3, 6, 6, 2, 4, 7, 2, 5, 1, 3, 6, 1, 4, 7, 1, 4, 6, 2, 4, 7, 3, 5, 1, 3, 6, 2, 2, 5, 7, 3, 5, 1, 4,6, 2, 4, 7]
    static var daysPerMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    static var monthArray = ["January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"]
    
    
    //timeline date
    static var isTimeline = false
    static var timelineDate = Date()
    
    //has launched - for graphics on the first launch
    static var hasLaunched = false
    
    //is in override event
    static var isInOverride = false
}
