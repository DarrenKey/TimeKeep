//
//  CustomUITabBar.swift
//  Calendar
//
//  Created by Mi Yan on 12/26/19.
//  Copyright © 2019 Darren Key. All rights reserved.
//

import Foundation
import UIKit

var homeVC: UIViewController!
var categoriesVC: UIViewController!
var stopwatchVC: UIViewController!
var statisticsVC: UIViewController!

var viewControllers: [UIViewController]!

var selectedIndex:Int = 0
func startingF(){
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    homeVC = storyboard.instantiateViewController(identifier: "Main")
    categoriesVC = storyboard.instantiateViewController(identifier: "Categories")
    stopwatchVC = storyboard.instantiateViewController(identifier: "Timer")
    statisticsVC = storyboard.instantiateViewController(identifier: "Chart")
    
    viewControllers = [categoriesVC,stopwatchVC, statisticsVC, homeVC]
    
}
