//
//  veryStartOfTheAppViewController.swift
//  Calendar
//
//  Created by Mi Yan on 1/1/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//

import UIKit
import UserNotifications
import CoreData

class veryStartOfTheAppViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        
        Singleton.dateTracker = dateFormatter.string(from: Date())
        
        
        
        
        
        // Do any additional setup after loading the view.
        //test data 
        /*
        Singleton.categories = ["Work", "Play"]
        Singleton.totalTime = [10.0, 5.0]
        Singleton.colorsC = [UIColor(hue: 0.1, saturation: 1, brightness: 1, alpha: 1),UIColor(hue: 0.2, saturation: 1, brightness: 1, alpha: 1)]
        Singleton.timeData = [[Calendar.current.date(from: DateComponents(year: 2020, month: 1, day: 8, hour: 13, minute:5, second: 2))!,Calendar.current.date(from: DateComponents(year: 2020, month: 1, day: 8, hour: 25, minute:5, second: 2))!],[]]
        Singleton.displayTime = [0,0]
        Singleton.hue = [1,2]
        Singleton.attributesN = ["Homework", "Chores", "Keep Tract"]
        Singleton.attributes = [["Homework", "Keep Tract"], ["Chores"]]*/
        //notification system
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
