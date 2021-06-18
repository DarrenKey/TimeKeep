//
//  ShouldTutorial.swift
//  TimeKeep
//
//  Created by Mi Yan on 7/21/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//

import Foundation
import RealmSwift

//provides info on whether or not to tutorial
class ShouldTutorial: Object{
    @objc dynamic var shouldBeginningMain: Bool = true
    
    @objc dynamic var shouldCategoryTutorial: Bool = true
    @objc dynamic var shouldPlannerTutorial: Bool = true
    @objc dynamic var shouldRoutineTutorial: Bool = true
    @objc dynamic var shouldStopwatchTutorial: Bool = true
    @objc dynamic var shouldChartsTutorial: Bool = true
    @objc dynamic var shouldTimelineTutorial: Bool = true
    
    @objc dynamic var shouldCalendarTutorial: Bool = true
    @objc dynamic var shouldCustomColorTutorial: Bool = true
}
