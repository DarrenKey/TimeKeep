//
//  Stopwatch.swift
//  TimeKeep
//
//  Created by Mi Yan on 5/3/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//

import UIKit
import RealmSwift

class Stopwatch: UIViewController {

    @IBOutlet weak var stopwatchLabel: UILabel!
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerView: UIView!
    
    //start stop and pause
    @IBOutlet weak var stopView: UIButton!
    @IBOutlet weak var startView: UIButton!
    @IBOutlet weak var pauseView: UIButton!
    
    //haptic feedback
    var mediumGenerator: UIImpactFeedbackGenerator? = nil
    
    //category table view
    @IBOutlet weak var tableView: UITableView!
    
    //is selecting category
    var isSelectingCategory = false
    
    //00:00:00 layout
    var tenthSecond = 0
    var secondC = 0
    var minC = 0
    var hourC = 0
    
    //TIMER
    var timer = Timer()
    
    //realms
    var realm = try! Realm()
    
    //selected category
    var selectedCategory = ""
    var selectedCategoryNum = -1
    
    @IBOutlet weak var selectedCategoryLabel: UITextView!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var selectedCategoryButton: UIButton!
    
    @IBOutlet weak var addCustomEventButton: UIButton!
    
    //label of selected category height
    var increasedHeight: CGFloat! = 0
    var labelHeight: CGFloat! = 0
    
    //height variable
    var tempHeight: CGFloat! = 0
    
    //category or routine
    enum selectingType{
        case category
        case routine
    }
    
    //current type on the screen
    var chosenType = selectingType.category
    
    //type of the selected category
    var selectedType = selectingType.category
    
    //stop multiple animation completion jankiness
    var isOpeningTableAnimating = false
    
    //category and routine buttons
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var routineButton: UIButton!
    
    //screen height and width
    var screenHeight: CGFloat = 0
    var screenWidth: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //standard tableview setup
        tableView.delegate = self
        tableView.dataSource = self
        
        //only for XR
        selectedCategoryLabel.frame.origin = CGPoint(x: 24, y: 6)
        selectedCategoryLabel.frame.size.width = 366
        
        //category setup: setup label to sizetofit and setup
        selectedCategoryLabel.sizeToFit()
        
        //reposition tableview to right under selected category name
        tableView.frame.origin.y = categoryView.frame.origin.y + selectedCategoryLabel.frame.size.height + 12
        
        labelHeight = selectedCategoryLabel.frame.size.height
        
        //only for XR
        selectedCategoryLabel.frame = CGRect(x: 24, y: 6, width: 366, height: 51)
        
        let screen = UIScreen.main.bounds
        screenWidth = screen.size.width
        screenHeight = screen.size.height
        
        resizeDevice()
        
        increasedHeight = tableView.frame.origin.y - categoryView.frame.origin.y - categoryView.frame.size.height
        
        resumeDate()
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    //resize manually
    func resizeDevice(){
        
        if screenWidth == 375 && screenHeight == 812{
            stopwatchLabel.font = stopwatchLabel.font.withSize(35)
            stopwatchLabel.frame = CGRect(x: 24, y: 77, width: 214, height: 46)
            
            categoryView.frame = CGRect(x: 0, y: 156, width: 375, height: 52)
            selectedCategoryButton.frame = CGRect(x: 0, y: 0, width: 375, height: 52)
            selectedCategoryLabel.font = selectedCategoryLabel.font?.withSize(21)
            selectedCategoryLabel.frame = CGRect(x: 24, y: 4, width: 327, height: 44)
            tableView.frame = CGRect(x: 0, y: categoryView.frame.origin.y + categoryView.frame.size.height, width: 375, height: 0)
            
            timerView.frame = CGRect(x: 0, y: 530, width: 375, height: 122)
            timerLabel.font = timerLabel.font.withSize(70)
            timerLabel.frame = CGRect(x: 15, y: 15.5, width: 346.5, height: 91)
            
            categoryButton.titleLabel?.font = categoryButton.titleLabel?.font.withSize(20)
            routineButton.titleLabel?.font = routineButton.titleLabel?.font.withSize(20)
            categoryButton.frame = CGRect(x: 24, y: 470, width: 151.5, height: 50)
            routineButton.frame = CGRect(x: 199, y: 470, width: 151.5, height: 50)
            
            startView.frame = CGRect(x: 24, y: 662, width: 151.5, height: 50)
            pauseView.frame = CGRect(x: 24, y: 662, width: 151.5, height: 50)
            stopView.frame = CGRect(x: 206, y: 662, width: 151.5, height: 50)
        }
        else if screenWidth == 414 && screenHeight == 736{
            stopwatchLabel.frame = CGRect(x: 24, y: 50, width: 244, height: 52)
            
            categoryView.frame.origin = CGPoint(x: 0, y: 132)
            tableView.frame = CGRect(x: 0, y: categoryView.frame.origin.y + categoryView.frame.size.height, width: 414, height: 0)
            
            categoryButton.frame = CGRect(x: 24, y: 437, width: 171, height: 40)
            
            routineButton.frame = CGRect(x: 219, y: 437, width: 171, height: 40)
            
            timerView.frame = CGRect(x: 0, y: 487, width: 414, height: 119)
            timerLabel.frame = CGRect(x: 22, y: 10.5, width: 371, height: 98)
            
            startView.frame = CGRect(x: 24, y: 616, width: 169, height: 40)
            pauseView.frame = CGRect(x: 24, y: 616, width: 169, height: 40)
            
            stopView.frame = CGRect(x: 221, y: 616, width: 169, height: 40)
        }
        else if screenWidth == 375 && screenHeight == 667{
            stopwatchLabel.font = stopwatchLabel.font.withSize(35)
            stopwatchLabel.frame = CGRect(x: 24, y: 50, width: 214, height: 46)
            
            categoryView.frame = CGRect(x: 0, y: 126, width: 375, height: 52)
            
            selectedCategoryButton.frame = CGRect(x: 0, y: 0, width: 375, height: 52)
            selectedCategoryLabel.font = selectedCategoryLabel.font?.withSize(21)
            selectedCategoryLabel.frame = CGRect(x: 24, y: 4, width: 327, height: 44)
            tableView.frame = CGRect(x: 0, y: categoryView.frame.origin.y + categoryView.frame.size.height, width: 375, height: 0)
            
            timerView.frame = CGRect(x: 0, y: 428, width: 375, height: 122)
            timerLabel.font = timerLabel.font.withSize(70)
            timerLabel.frame = CGRect(x: 15, y: 15.5, width: 346.5, height: 91)
            
            categoryButton.titleLabel?.font = categoryButton.titleLabel?.font.withSize(20)
            routineButton.titleLabel?.font = routineButton.titleLabel?.font.withSize(20)
            categoryButton.frame = CGRect(x: 24, y: 382, width: 152, height: 36)
            routineButton.frame = CGRect(x: 199, y: 382, width: 152, height: 36)
            
            startView.frame = CGRect(x: 24, y: 560, width: 152, height: 36)
            pauseView.frame = CGRect(x: 24, y: 560, width: 152, height: 36)
            stopView.frame = CGRect(x: 199, y: 560, width: 152, height: 36)
        }
        else if screenWidth == 320 && screenHeight == 568{
            stopwatchLabel.font = stopwatchLabel.font.withSize(30)
            stopwatchLabel.frame = CGRect(x: 24, y: 40, width: 183, height: 39)
            
            categoryView.frame = CGRect(x: 0, y: 99, width: 320, height: 48)
            
            selectedCategoryButton.frame = CGRect(x: 0, y: 0, width: 320, height: 48)
            
            selectedCategoryLabel.font = selectedCategoryLabel.font?.withSize(21)
            selectedCategoryLabel.frame = CGRect(x: 24, y: 2, width: 272, height: 44)
            tableView.frame = CGRect(x: 0, y: categoryView.frame.origin.y + categoryView.frame.size.height, width: 320, height: 0)
            
            timerView.frame = CGRect(x: 0, y: 352, width: 320, height: 99)
            timerLabel.font = timerLabel.font.withSize(60)
            timerLabel.frame = CGRect(x: 11.5, y: 10.5, width: 297, height: 78)
            
            categoryButton.titleLabel?.font = categoryButton.titleLabel?.font.withSize(18)
            routineButton.titleLabel?.font = routineButton.titleLabel?.font.withSize(18)
            categoryButton.frame = CGRect(x: 24, y: 306, width: 126, height: 36)
            routineButton.frame = CGRect(x: 170, y: 306, width: 126, height: 36)
            
            startView.frame = CGRect(x: 24, y: 461, width: 126, height: 36)
            pauseView.frame = CGRect(x: 24, y: 461, width: 126, height: 36)
            stopView.frame = CGRect(x: 170, y: 461, width: 126, height: 36)
        }
        else if screenWidth == 768 && screenHeight == 1024{
            stopwatchLabel.font = stopwatchLabel.font.withSize(50)
            stopwatchLabel.frame = CGRect(x: 24, y: 60, width: 305, height: 65)
            
            categoryView.frame = CGRect(x: 0, y: 165, width: 768, height: 83)
            
            selectedCategoryButton.frame = CGRect(x: 0, y: 0, width: 768, height: 83)
            
            selectedCategoryLabel.font = selectedCategoryLabel.font?.withSize(35)
            selectedCategoryLabel.frame = CGRect(x: 24, y: 10, width: 720, height: 63)
            tableView.frame = CGRect(x: 0, y: categoryView.frame.origin.y + categoryView.frame.size.height, width: 768, height: 0)
            
            timerView.frame = CGRect(x: 0, y: 639, width: 768, height: 188)
            timerLabel.font = timerLabel.font.withSize(113)
            timerLabel.frame = CGRect(x: 105, y: 20.5, width: 558, height: 147)
            
            categoryButton.titleLabel?.font = categoryButton.titleLabel?.font.withSize(35)
            routineButton.titleLabel?.font = routineButton.titleLabel?.font.withSize(35)
            categoryButton.frame = CGRect(x: 24, y: 554, width: 340, height: 75)
            routineButton.frame = CGRect(x: 404, y: 554, width: 340, height: 75)
            
            startView.titleLabel?.font = startView.titleLabel?.font.withSize(35)
            pauseView.titleLabel?.font = pauseView.titleLabel?.font.withSize(35)
            stopView.titleLabel?.font = stopView.titleLabel?.font.withSize(35)
            
            startView.frame = CGRect(x: 24, y: 839, width: 340, height: 75)
            pauseView.frame = CGRect(x: 24, y: 839, width: 340, height: 75)
            stopView.frame = CGRect(x: 404, y: 839, width: 340, height: 75)
        }
        else if screenWidth == 834 && screenHeight == 1194{
            stopwatchLabel.font = stopwatchLabel.font.withSize(65)
            stopwatchLabel.frame = CGRect(x: 24, y: 50, width: 397, height: 85)
            
            categoryView.frame = CGRect(x: 0, y: 165, width: 834, height: 90)
            
            selectedCategoryButton.frame = CGRect(x: 0, y: 0, width: 834, height: 90)
            
            selectedCategoryLabel.font = selectedCategoryLabel.font?.withSize(40)
            selectedCategoryLabel.frame = CGRect(x: 24, y: 10, width: 768, height: 70)
            tableView.frame = CGRect(x: 0, y: categoryView.frame.origin.y + categoryView.frame.size.height, width: 834, height: 0)
            
            timerView.frame = CGRect(x: 0, y: 759, width: 834, height: 200)
            timerLabel.font = timerLabel.font.withSize(130)
            timerLabel.frame = CGRect(x: 96, y: 15.5, width: 642, height: 159)
            
            categoryButton.titleLabel?.font = categoryButton.titleLabel?.font.withSize(40)
            routineButton.titleLabel?.font = routineButton.titleLabel?.font.withSize(40)
            categoryButton.frame = CGRect(x: 24, y: 669, width: 373, height: 75)
            routineButton.frame = CGRect(x: 437, y: 669, width: 373, height: 75)
            
            startView.titleLabel?.font = startView.titleLabel?.font.withSize(40)
            pauseView.titleLabel?.font = pauseView.titleLabel?.font.withSize(40)
            stopView.titleLabel?.font = stopView.titleLabel?.font.withSize(40)
            
            startView.frame = CGRect(x: 24, y: 974, width: 373, height: 75)
            pauseView.frame = CGRect(x: 24, y: 974, width: 373, height: 75)
            stopView.frame = CGRect(x: 437, y: 974, width: 373, height: 75)
        }
        else if screenWidth == 834 && screenHeight == 1112{
            stopwatchLabel.font = stopwatchLabel.font.withSize(65)
            stopwatchLabel.frame = CGRect(x: 24, y: 50, width: 397, height: 85)
            
            categoryView.frame = CGRect(x: 0, y: 165, width: 834, height: 90)
            
            selectedCategoryButton.frame = CGRect(x: 0, y: 0, width: 834, height: 90)
            
            selectedCategoryLabel.font = selectedCategoryLabel.font?.withSize(40)
            selectedCategoryLabel.frame = CGRect(x: 24, y: 10, width: 768, height: 70)
            tableView.frame = CGRect(x: 0, y: categoryView.frame.origin.y + categoryView.frame.size.height, width: 834, height: 0)
            
            timerView.frame = CGRect(x: 0, y: 700, width: 834, height: 200)
            timerLabel.font = timerLabel.font.withSize(130)
            timerLabel.frame = CGRect(x: 96, y: 15.5, width: 642, height: 159)
            
            categoryButton.titleLabel?.font = categoryButton.titleLabel?.font.withSize(40)
            routineButton.titleLabel?.font = routineButton.titleLabel?.font.withSize(40)
            categoryButton.frame = CGRect(x: 24, y: 610, width: 373, height: 75)
            routineButton.frame = CGRect(x: 437, y: 610, width: 373, height: 75)
            
            startView.titleLabel?.font = startView.titleLabel?.font.withSize(40)
            pauseView.titleLabel?.font = pauseView.titleLabel?.font.withSize(40)
            stopView.titleLabel?.font = stopView.titleLabel?.font.withSize(40)
            
            startView.frame = CGRect(x: 24, y: 915, width: 373, height: 75)
            pauseView.frame = CGRect(x: 24, y: 915, width: 373, height: 75)
            stopView.frame = CGRect(x: 437, y: 915, width: 373, height: 75)
        }
        else if screenWidth == 810 && screenHeight == 1080{
            stopwatchLabel.font = stopwatchLabel.font.withSize(65)
            stopwatchLabel.frame = CGRect(x: 24, y: 50, width: 397, height: 85)
            
            categoryView.frame = CGRect(x: 0, y: 165, width: 810, height: 90)
            
            selectedCategoryButton.frame = CGRect(x: 0, y: 0, width: 810, height: 90)
            
            selectedCategoryLabel.font = selectedCategoryLabel.font?.withSize(40)
            selectedCategoryLabel.frame = CGRect(x: 24, y: 10, width: 762, height: 70)
            tableView.frame = CGRect(x: 0, y: categoryView.frame.origin.y + categoryView.frame.size.height, width: 810, height: 0)
            
            timerView.frame = CGRect(x: 0, y: 662, width: 810, height: 203)
            timerLabel.font = timerLabel.font.withSize(125)
            timerLabel.frame = CGRect(x: 96, y: 20, width: 618, height: 163)
            
            categoryButton.titleLabel?.font = categoryButton.titleLabel?.font.withSize(40)
            routineButton.titleLabel?.font = routineButton.titleLabel?.font.withSize(40)
            categoryButton.frame = CGRect(x: 24, y: 572, width: 361, height: 75)
            routineButton.frame = CGRect(x: 425, y: 572, width: 361, height: 75)
            
            startView.titleLabel?.font = startView.titleLabel?.font.withSize(40)
            pauseView.titleLabel?.font = pauseView.titleLabel?.font.withSize(40)
            stopView.titleLabel?.font = stopView.titleLabel?.font.withSize(40)
            
            startView.frame = CGRect(x: 24, y: 880, width: 361, height: 75)
            pauseView.frame = CGRect(x: 24, y: 880, width: 361, height: 75)
            stopView.frame = CGRect(x: 425, y: 880, width: 361, height: 75)
        }
        else if screenWidth == 1024 && screenHeight == 1366{
            stopwatchLabel.font = stopwatchLabel.font.withSize(75)
            stopwatchLabel.frame = CGRect(x: 24, y: 60, width: 458, height: 98)
            
            categoryView.frame = CGRect(x: 0, y: 198, width: 1024, height: 113)
            
            selectedCategoryButton.frame = CGRect(x: 0, y: 0, width: 1024, height: 113)
            
            selectedCategoryLabel.font = selectedCategoryLabel.font?.withSize(50)
            selectedCategoryLabel.frame = CGRect(x: 24, y: 15, width: 976, height: 83)
            tableView.frame = CGRect(x: 0, y: categoryView.frame.origin.y + categoryView.frame.size.height, width: 1024, height: 0)
            
            timerView.frame = CGRect(x: 0, y: 822, width: 1024, height: 274)
            timerLabel.font = timerLabel.font.withSize(180)
            timerLabel.frame = CGRect(x: 67, y: 20, width: 889, height: 234)
            
            categoryButton.titleLabel?.font = categoryButton.titleLabel?.font.withSize(50)
            routineButton.titleLabel?.font = routineButton.titleLabel?.font.withSize(50)
            categoryButton.frame = CGRect(x: 24, y: 707, width: 458, height: 100)
            routineButton.frame = CGRect(x: 542, y: 707, width: 458, height: 100)
            
            startView.titleLabel?.font = startView.titleLabel?.font.withSize(50)
            pauseView.titleLabel?.font = pauseView.titleLabel?.font.withSize(50)
            stopView.titleLabel?.font = stopView.titleLabel?.font.withSize(50)
            
            startView.frame = CGRect(x: 24, y: 1111, width: 458, height: 100)
            pauseView.frame = CGRect(x: 24, y: 1111, width: 458, height: 100)
            stopView.frame = CGRect(x: 540, y: 1111, width: 458, height: 100)
        }
        
        ///add custom event button resize
        addCustomEventButton.frame = CGRect(x: screenWidth - 24 - stopwatchLabel.frame.size.height, y: stopwatchLabel.frame.origin.y, width: stopwatchLabel.frame.size.height, height: stopwatchLabel.frame.size.height)
    }
    
    
    //get when application is in focus
    @objc func applicationForeground(){
        resumeDate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        
        print("appeared view will")
        
        //resume timer
        resumeDate()
    }
    
    
    //change timer
    @objc func timeL()
    {
        tenthSecond += 1
        
        //if too many hours passes
        if hourC == 999 && minC == 59 && secondC == 60{
            hourC = 0
        }
        
        if tenthSecond == 10{
            secondC += 1
            tenthSecond = 0
        }
        if secondC == 60{
            minC += 1
            secondC = 0
        }
        if minC == 60{
            minC = 0
            hourC += 1
        }
        
        timerLabel.text = String(format: "%03d:%02d:%02d", hourC, minC, secondC)
    }
    
    func addDate(num: Int){
        let realm = try! Realm()
        
        switch selectedType{
           case .category:
                let selectedCategoryRealm = realm.objects(Category.self)[num]

                //add start date
                try! realm.write{
                    selectedCategoryRealm.time.append(Date())
                }
        case .routine:
            let selectedRoutineRealm = realm.objects(Routine.self)[num]

            //add start date
            try! realm.write{
                selectedRoutineRealm.time.append(Date())
            }
        }
    }
    
    func stopDate(num: Int){
        let realm = try! Realm()
        
        switch selectedType{
           case .category:
                let selectedCategoryRealm = realm.objects(Category.self)[num]

                //add start date
                try! realm.write{
                    selectedCategoryRealm.time.append(Date())
                }
            case .routine:
                let selectedRoutineRealm = realm.objects(Routine.self)[num]

                //add start date
                try! realm.write{
                    selectedRoutineRealm.time.append(Date())
                }
        }
    }
    
    func resumeDate(){
        let realm = try! Realm()
        
        let selectedCategoryRealm = realm.objects(Category.self)
        let selectedRoutineRealm = realm.objects(Routine.self)
        
        var isResumedDate = false
        var resumedDateNum = -1
        
        
        //for the categories
        //check if any timer is still going, then resume
        for i in 0..<selectedCategoryRealm.count{
            //if list is odd - a timer is still going
            if selectedCategoryRealm[i].time.count % 2 == 1{
                isResumedDate = true
                chosenType = .category
                selectedType = .category
                
                //change colors
                categoryButton.backgroundColor = UIColor(hex: "E85A4F")
                routineButton.backgroundColor = UIColor(hex: "EEA097")
                
                resumedDateNum = i
            }
        }
        
        //for the routines
        for i in 0..<selectedRoutineRealm.count{
            //if list is odd - a timer is still going
            if selectedRoutineRealm[i].time.count % 2 == 1{
                isResumedDate = true
                chosenType = .routine
                selectedType = .routine
                
                //change colors
                categoryButton.backgroundColor = UIColor(hex: "EEA097")
                routineButton.backgroundColor = UIColor(hex: "E85A4F")
                resumedDateNum = i
            }
        }
        
        //change timer
        if isResumedDate == true{
            
            //selecting category & reload table
            selectedCategoryNum = resumedDateNum
            
            //set missing time based on last time it stopped
            var missingTime: Double = 0
            
            switch chosenType{
                case .category:
                    missingTime = selectedCategoryRealm[resumedDateNum].displayTime + Date().timeIntervalSince(selectedCategoryRealm[resumedDateNum].time.last!)
                case .routine:
                    missingTime = selectedRoutineRealm[resumedDateNum].displayTime + Date().timeIntervalSince(selectedRoutineRealm[resumedDateNum].time.last!)
            }
            
            
            tableView.reloadData()
            
            //timer format
            hourC = Int(missingTime/3600)
            
            missingTime = missingTime.truncatingRemainder(dividingBy: 3600)
            
            minC = Int(missingTime/60)
            
            missingTime = missingTime.truncatingRemainder(dividingBy: 60)
            
            secondC = Int(missingTime)
            
            tenthSecond = Int(missingTime.truncatingRemainder(dividingBy: 1) * 10)
            
            
            //pause timer
            timer.invalidate()
            
            //restart timer
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timeL), userInfo: nil, repeats: true)
            
            //disable start button and enable pause button
            self.pauseView.isHidden = false
            self.startView.isHidden = true
            
            //--------------------- resize tableview & label accordinly

            switch chosenType{
                case .category:
                    //set selected category text
                    selectedCategoryLabel.text = "CATEGORY: \(selectedCategoryRealm[resumedDateNum].name)"
                case .routine:
                    //set selected category text
                    selectedCategoryLabel.text = "ROUTINE: \(selectedRoutineRealm[resumedDateNum].name)"
            }
            
            //reset tableview size
            
            tableView.frame.origin.y = resizeTableAndButton()
        }
        else if selectedCategoryNum >= 0{
            stopDateAfterCustomEvent()
        }
    }
    
    ///unwind segue
    @IBAction func unwindFromCustomEvent(segue: UIStoryboardSegue) {
    }
    
    ///send data to custom event
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromStopwatch"{
            let customEvent = segue.destination as! CustomEvent
            
            customEvent.actualVCFrom = .stopwatch
        }
    }
    
    func stopDateAfterCustomEvent(){
        let realm = try! Realm()
        
        let selectedCategoryRealm = realm.objects(Category.self)
        let selectedRoutineRealm = realm.objects(Routine.self)
        
        //set missing time based on last time it stopped
        var missingTime: Double = 0
        
        switch chosenType{
            case .category:
                if selectedCategoryRealm[selectedCategoryNum].time.count % 2 != 0{
                    missingTime = selectedCategoryRealm[selectedCategoryNum].displayTime + Date().timeIntervalSince(selectedCategoryRealm[selectedCategoryNum].time.last!)
                }
                else{
                    missingTime = selectedCategoryRealm[selectedCategoryNum].displayTime
                }
            case .routine:
                if selectedRoutineRealm[selectedCategoryNum].time.count % 2 != 0{
                    missingTime = selectedRoutineRealm[selectedCategoryNum].displayTime + Date().timeIntervalSince(selectedRoutineRealm[selectedCategoryNum].time.last!)
                }
                else{
                    missingTime = selectedRoutineRealm[selectedCategoryNum].displayTime
                }
        }
        
        
        tableView.reloadData()
        
        //timer format
        hourC = Int(missingTime/3600)
        
        missingTime = missingTime.truncatingRemainder(dividingBy: 3600)
        
        minC = Int(missingTime/60)
        
        missingTime = missingTime.truncatingRemainder(dividingBy: 60)
        
        secondC = Int(missingTime)
        
        tenthSecond = Int(missingTime.truncatingRemainder(dividingBy: 1) * 10)
        
        //pause timer
        timer.invalidate()
        
        pauseView.isHidden = true
        startView.isHidden = false
        
        timerLabel.text = String(format: "%03d:%02d:%02d", hourC, minC, secondC)
    }
    
    //buttons pressed
    @IBAction func startButtonPressed(_ sender: Any) {
        
        //if currently a category chosen
        if selectedCategoryNum >= 0{
            //haptic feedback
            mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
            mediumGenerator?.prepare()
            mediumGenerator?.impactOccurred()
            mediumGenerator = nil
            
            //disable start button and enable pause button
            self.pauseView.isHidden = false
            self.startView.isHidden = true
            
            //stop existing timer
            timer.invalidate()
            
            //start timer
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timeL), userInfo: nil, repeats: true)
            
            //add date
            addDate(num: selectedCategoryNum)
        }
    }
    
    @IBAction func pauseButtonPressed(_ sender: Any) {
        
        //disable pause button and enable start button
        self.pauseView.isHidden = true
        self.startView.isHidden = false
        
        //haptic feedback
        mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
        mediumGenerator?.prepare()
        mediumGenerator?.impactOccurred()
        mediumGenerator = nil
        
        //pause timer
        timer.invalidate()

        //reset display time
        let realm = try! Realm()
        
        switch selectedType{
            case .category:
                let selectedCategoryRealm = realm.objects(Category.self)[selectedCategoryNum]
                
                //add to display time
                try! realm.write{
                    selectedCategoryRealm.displayTime += Date().timeIntervalSince(selectedCategoryRealm.time.last!)
                }
                
            case .routine:
                
                let selectedRoutineRealm = realm.objects(Routine.self)[selectedCategoryNum]
                
                //add to display time
                try! realm.write{
                    selectedRoutineRealm.displayTime += Date().timeIntervalSince(selectedRoutineRealm.time.last!)
                }
        }
        
        //stop date
        stopDate(num: selectedCategoryNum)
    }
    
    @IBAction func categorySelectionPressed(_ sender: Any?) {
        isSelectingCategory = !isSelectingCategory
        
        //haptic feedback
        mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
        mediumGenerator?.prepare()
        mediumGenerator?.impactOccurred()
        mediumGenerator = nil
        
        //opening of category
        if isSelectingCategory == true && isOpeningTableAnimating == false && tableView.numberOfRows(inSection: 0) > 0{
            isOpeningTableAnimating = true
            UIView.animate(withDuration: 0.3, delay: 0, animations: {
                
                self.categoryView.frame.size.height += self.increasedHeight
                
                self.selectedCategoryLabel.frame.size.height += self.increasedHeight
                
                self.selectedCategoryButton.frame.size.height += self.increasedHeight
                
            }, completion: {_ in
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                    
                    self.tableView.frame.size.height = self.timerView.frame.origin.y - self.tableView.frame.origin.y - 2
                    
                }, completion: {_ in
                    self.isOpeningTableAnimating = false
                })

            })
            
        }
        
        //retraction
        else if isSelectingCategory == false && isOpeningTableAnimating == false && tableView.numberOfRows(inSection: 0) > 0{
            
            isOpeningTableAnimating = true
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                
                self.tableView.frame.size.height = 0
                
            }, completion: {_ in

                UIView.animate(withDuration: 0.3, delay: 0, animations: {
                    if self.screenWidth == 414 && self.screenHeight == 896{
                        //only for XR
                        self.categoryView.frame.size.height = 63

                        //only for XR
                        self.selectedCategoryLabel.frame.size.height = 51
                        
                        //only for XR
                        self.selectedCategoryButton.frame.size.height = 63
                    }
                    else if self.screenWidth == 375 && self.screenHeight == 812{
                        self.categoryView.frame.size.height = 52
                        self.selectedCategoryLabel.frame.size.height = 44
                        self.selectedCategoryButton.frame.size.height = 52
                    }
                    else if self.screenWidth == 414 && self.screenHeight == 736{
                        //only for XR
                        self.categoryView.frame.size.height = 63

                        //only for XR
                        self.selectedCategoryLabel.frame.size.height = 51
                        
                        //only for XR
                        self.selectedCategoryButton.frame.size.height = 63
                    }
                    else if self.screenWidth == 375 && self.screenHeight == 667{
                        self.categoryView.frame.size.height = 52
                        self.selectedCategoryLabel.frame.size.height = 44
                        self.selectedCategoryButton.frame.size.height = 52
                    }
                    else if self.screenWidth == 320 && self.screenHeight == 568{
                        self.categoryView.frame.size.height = 48
                        self.selectedCategoryLabel.frame.size.height = 44
                        self.selectedCategoryButton.frame.size.height = 48
                    }
                    else if self.screenWidth == 768 && self.screenHeight == 1024{
                        self.categoryView.frame.size.height = 83
                        self.selectedCategoryLabel.frame.size.height = 63
                        self.selectedCategoryButton.frame.size.height = 83
                    }
                    else if self.screenWidth == 834 && self.screenHeight == 1194{
                        self.categoryView.frame.size.height = 90
                        self.selectedCategoryLabel.frame.size.height = 70
                        self.selectedCategoryButton.frame.size.height = 90
                    }
                    else if self.screenWidth == 834 && self.screenHeight == 1112{
                        self.categoryView.frame.size.height = 90
                        self.selectedCategoryLabel.frame.size.height = 70
                        self.selectedCategoryButton.frame.size.height = 90
                    }
                    else if self.screenWidth == 810 && self.screenHeight == 1080{
                        self.categoryView.frame.size.height = 90
                        self.selectedCategoryLabel.frame.size.height = 70
                        self.selectedCategoryButton.frame.size.height = 90
                    }
                    else if self.screenWidth == 1024 && self.screenHeight == 1366{
                        self.categoryView.frame.size.height = 113
                        self.selectedCategoryLabel.frame.size.height = 83
                        self.selectedCategoryButton.frame.size.height = 113
                    }
                    
                }, completion: {_ in
                    self.isOpeningTableAnimating = false
                })
            })
        }
    }
    
    @IBAction func stopButtonPressed(_ sender: Any) {
        
        //if a category selected
        if selectedCategoryNum >= 0{
            timer.invalidate()

            //haptic feedback
            mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
            mediumGenerator?.prepare()
            mediumGenerator?.impactOccurred()
            mediumGenerator = nil
            
            //if pause button on - hide it and show start
            if pauseView.isHidden == false{
                self.pauseView.isHidden = true
                self.startView.isHidden = false
                
                //if running - add stop date
                //stop date
                stopDate(num: selectedCategoryNum)
            }
            
            //reset all variables back to 0
            tenthSecond = 0
            secondC = 0
            minC = 0
            hourC = 0
            timerLabel.text = String(format: "%03d:%02d:%02d", hourC, minC, secondC)
            
            //reset display time
            let realm = try! Realm()
            
            switch selectedType{
                case .category:
                    let selectedCategoryRealm = realm.objects(Category.self)[selectedCategoryNum]
                    
                    //reset display time
                    try! realm.write{
                        selectedCategoryRealm.displayTime = 0
                        
                        selectedCategoryRealm.lastResetDate = selectedCategoryRealm.time.last!
                    }
                case .routine:
                    let selectedRoutineRealm = realm.objects(Routine.self)[selectedCategoryNum]
                    
                    //reset display time
                    try! realm.write{
                        selectedRoutineRealm.displayTime = 0
                        
                        selectedRoutineRealm.lastResetDate = selectedRoutineRealm.time.last!
                    }
            }
        }
    }
    
    //functions to resize everything
    func resizeTableAndButton() -> CGFloat{
        //category setup: setup label to sizetofit and setup
        
        if screenHeight == 896 && screenWidth == 414{
            selectedCategoryLabel.frame.origin = CGPoint(x: 24, y: 6)
            selectedCategoryLabel.frame.size.width = 366
        }
        else if screenHeight == 812 && screenWidth == 375{
            selectedCategoryLabel.frame = CGRect(x: 24, y: 4, width: 327, height: 44)
        }
        else if screenHeight == 667 && screenWidth == 375{
            selectedCategoryLabel.frame = CGRect(x: 24, y: 4, width: 327, height: 44)
        }
        else if screenHeight == 736 && screenWidth == 414{
            selectedCategoryLabel.frame.origin = CGPoint(x: 24, y: 6)
            selectedCategoryLabel.frame.size.width = 366
        }
        else if screenHeight == 568 && screenWidth == 320{
            selectedCategoryLabel.frame = CGRect(x: 24, y: 2, width: 272, height: 44)
        }
        else if screenHeight == 1024 && screenWidth == 768{
            selectedCategoryLabel.frame = CGRect(x: 24, y: 10, width: 720, height: 63)
        }
        else if screenHeight == 1194 && screenWidth == 834{
            selectedCategoryLabel.frame = CGRect(x: 24, y: 10, width: 786, height: 70)
        }
        else if screenHeight == 1112 && screenWidth == 834{
            selectedCategoryLabel.frame = CGRect(x: 24, y: 10, width: 786, height: 70)
        }
        else if screenHeight == 1080 && screenWidth == 810{
            selectedCategoryLabel.frame = CGRect(x: 24, y: 10, width: 762, height: 70)
        }
        else if screenHeight == 1366 && screenWidth == 1024{
            selectedCategoryLabel.frame = CGRect(x: 24, y: 15, width: 976, height: 83)
        }
        
        selectedCategoryLabel.sizeToFit()
        
        var newTableViewY: CGFloat = 0
        
        //set new table y value
        if screenHeight == 896 && screenWidth == 414{
            newTableViewY = categoryView.frame.origin.y + selectedCategoryLabel.frame.size.height + 12
        }
        else if screenHeight == 812 && screenWidth == 375{
            newTableViewY = categoryView.frame.origin.y + selectedCategoryLabel.frame.size.height + 8
        }
        else if screenHeight == 736 && screenWidth == 414{
            newTableViewY = categoryView.frame.origin.y + selectedCategoryLabel.frame.size.height + 12
        }
        else if screenHeight == 667 && screenWidth == 375{
            newTableViewY = categoryView.frame.origin.y + selectedCategoryLabel.frame.size.height + 8
        }
        else if screenHeight == 568 && screenWidth == 320{
            newTableViewY = categoryView.frame.origin.y + selectedCategoryLabel.frame.size.height + 4
        }
        else if screenHeight == 1024 && screenWidth == 768{
            newTableViewY = categoryView.frame.origin.y + selectedCategoryLabel.frame.size.height + 20
        }
        else if screenHeight == 1194 && screenWidth == 834{
            newTableViewY = categoryView.frame.origin.y + selectedCategoryLabel.frame.size.height + 20
        }
        else if screenHeight == 1112 && screenWidth == 834{
            newTableViewY = categoryView.frame.origin.y + selectedCategoryLabel.frame.size.height + 20
        }
        else if screenHeight == 1080 && screenWidth == 810{
            newTableViewY = categoryView.frame.origin.y + selectedCategoryLabel.frame.size.height + 20
        }
        else if screenHeight == 1366 && screenWidth == 1024{
            newTableViewY = categoryView.frame.origin.y + selectedCategoryLabel.frame.size.height + 30
        }

        //labelheight
        labelHeight = selectedCategoryLabel.frame.size.height
        
        if screenHeight == 896 && screenWidth == 414{
            increasedHeight = newTableViewY - (categoryView.frame.origin.y + 51 + 12)
        }
        else if screenHeight ==  812 && screenWidth == 375{
            increasedHeight = newTableViewY - (categoryView.frame.origin.y + 44 + 8)
        }
        else if screenHeight == 736 && screenWidth == 414{
            increasedHeight = newTableViewY - (categoryView.frame.origin.y + 51 + 12)
        }
        else if screenHeight == 667 && screenWidth == 375{
            increasedHeight = newTableViewY - (categoryView.frame.origin.y + 44 + 8)
        }
        else if screenHeight == 568 && screenWidth == 320{
            increasedHeight = newTableViewY - (categoryView.frame.origin.y + 44 + 4)
        }
        else if screenHeight == 1024 && screenWidth == 768{
            increasedHeight = newTableViewY - (categoryView.frame.origin.y + 63 + 20)
        }
        else if screenHeight == 1194 && screenWidth == 834{
            increasedHeight = newTableViewY - (categoryView.frame.origin.y + 70 + 20)
        }
        else if screenHeight == 1112 && screenWidth == 834{
            increasedHeight = newTableViewY - (categoryView.frame.origin.y + 70 + 20)
        }
        else if screenHeight == 1080 && screenWidth == 810{
            increasedHeight = newTableViewY - (categoryView.frame.origin.y + 70 + 20)
        }
        else if screenHeight == 1366 && screenWidth == 1024{
            increasedHeight = newTableViewY - (categoryView.frame.origin.y + 83 + 30)
        }
        
        //if text > avaliable text - reduce height
        
        if screenHeight == 896 && screenWidth == 414{
            if labelHeight > categoryView.frame.size.height - 12{
                selectedCategoryLabel.frame.size.height = 51
            }
        }
        else if screenHeight == 812 && screenWidth == 375{
            if labelHeight > categoryView.frame.size.height - 8{
                selectedCategoryLabel.frame.size.height = 44
            }
        }
        else if screenHeight == 667 && screenWidth == 375{
            if labelHeight > categoryView.frame.size.height - 8{
                selectedCategoryLabel.frame.size.height = 44
            }
        }
        else if screenHeight == 736 && screenWidth == 414{
            if labelHeight > categoryView.frame.size.height - 12{
                selectedCategoryLabel.frame.size.height = 51
            }
        }
        else if screenHeight == 568 && screenWidth == 320{
            if labelHeight > categoryView.frame.size.height - 4{
                selectedCategoryLabel.frame.size.height = 44
            }
        }
        else if screenHeight == 1024 && screenWidth == 768{
            if labelHeight > categoryView.frame.size.height - 20{
                selectedCategoryLabel.frame.size.height = 63
            }
        }
        else if screenHeight == 1194 && screenWidth == 834{
            if labelHeight > categoryView.frame.size.height - 20{
                selectedCategoryLabel.frame.size.height = 70
            }
        }
        else if screenHeight == 1112 && screenWidth == 834{
            if labelHeight > categoryView.frame.size.height - 20{
                selectedCategoryLabel.frame.size.height = 70
            }
        }
        else if screenHeight == 1080 && screenWidth == 810{
            if labelHeight > categoryView.frame.size.height - 20{
                selectedCategoryLabel.frame.size.height = 70
            }
        }
        else if screenHeight == 1366 && screenWidth == 1024{
            if labelHeight > categoryView.frame.size.height - 30{
                selectedCategoryLabel.frame.size.height = 83
            }
        }
        
        return newTableViewY
    }
    
    @IBAction func categoryChosen(_ sender: Any) {
        //haptic feedback
        let selectionGenerator = UISelectionFeedbackGenerator()
        selectionGenerator.selectionChanged()
        
        UIView.animate(withDuration: 0.3, animations: {
            self.categoryButton.backgroundColor = UIColor(hex: "E85A4F")
            self.routineButton.backgroundColor = UIColor(hex: "EEA097")
        })
        chosenType = .category
        
        if selectedType == .category && selectedCategoryNum >= 0{
            let selectedCategoryRealm = realm.objects(Category.self)[selectedCategoryNum]
            //set selected category text
            selectedCategoryLabel.text = "CATEGORY: \(selectedCategoryRealm.name)"
        }
        else{
            selectedCategoryLabel.text = "CATEGORY:"
        }
        
        //reposition tableview to right under selected category name
        tableView.frame.origin.y = resizeTableAndButton()
        
        //reload data
        tableView.reloadData()
    }
    
    @IBAction func routineChosen(_ sender: Any) {
        //haptic feedback
        let selectionGenerator = UISelectionFeedbackGenerator()
        selectionGenerator.selectionChanged()
        
        UIView.animate(withDuration: 0.3, animations: {
            self.categoryButton.backgroundColor = UIColor(hex: "EEA097")
            self.routineButton.backgroundColor = UIColor(hex: "E85A4F")
        })
        chosenType = .routine
        
        //reposition tableview to right under selected category name
        tableView.frame.origin.y = categoryView.frame.origin.y + selectedCategoryLabel.frame.size.height + 12

        if selectedType == .routine && selectedCategoryNum >= 0{
            let selectedRoutineRealm = realm.objects(Routine.self)[selectedCategoryNum]
            //set selected routine text
            selectedCategoryLabel.text = "ROUTINE: \(selectedRoutineRealm.name)"
        }
        else{
            selectedCategoryLabel.text = "ROUTINE:"
        }
        
        //reposition tableview to right under selected category name
        tableView.frame.origin.y = resizeTableAndButton()
        
        //reload data
        tableView.reloadData()
    }
    
}

extension Stopwatch: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch chosenType{
            case .category:
                let categoryRealm = realm.objects(Category.self)
            
                return categoryRealm.count
            case .routine:
                let routineRealm = realm.objects(Routine.self)
            
                return routineRealm.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //set cells to category name
        
        //if selected category
        if indexPath.row == selectedCategoryNum && chosenType == selectedType{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedCell") as! StopwatchSelectedCell
            
            //depending on type chosen, fix label
            switch selectedType{
                case .category:
                    let categoryRealm = realm.objects(Category.self)
                
                    cell.label.text = categoryRealm[indexPath.row].name
                case .routine:
                    let routineRealm = realm.objects(Routine.self)
                
                    cell.label.text = routineRealm[indexPath.row].name
            }
            
            //size dependent resizing
            if screenHeight == 896 && screenWidth == 414{
                cell.label.frame = CGRect(x: 24, y: 15, width: 366, height: 33)
            }
            else if screenHeight == 812 && screenWidth == 375{
                cell.label.frame = CGRect(x: 24, y: 15, width: 327, height: 33)
            }
            else if screenHeight == 667 && screenWidth == 375{
                cell.label.frame = CGRect(x: 24, y: 8, width: 327, height: 33)
            }
            else if screenHeight == 736 && screenWidth == 414{
                cell.label.frame = CGRect(x: 24, y: 15, width: 366, height: 33)
            }
            else if screenHeight == 568 && screenWidth == 320{
                cell.label.font = cell.label.font.withSize(20)
                cell.label.frame = CGRect(x: 24, y: 5, width: 281, height: 26)
            }
            else if screenHeight == 1024 && screenWidth == 768{
                cell.label.font = cell.label.font.withSize(35)
                cell.label.frame = CGRect(x: 24, y: 10, width: 720, height: 46)
            }
            else if screenHeight == 1194 && screenWidth == 834{
                cell.label.font = cell.label.font.withSize(40)
                cell.label.frame = CGRect(x: 24, y: 10, width: 786, height: 52)
            }
            else if screenHeight == 1112 && screenWidth == 834{
                cell.label.font = cell.label.font.withSize(40)
                cell.label.frame = CGRect(x: 24, y: 10, width: 786, height: 52)
            }
            else if screenHeight == 1080 && screenWidth == 810{
                cell.label.font = cell.label.font.withSize(40)
                cell.label.frame = CGRect(x: 24, y: 10, width: 762, height: 52)
            }
            else if screenHeight == 1366 && screenWidth == 1024{
                cell.label.font = cell.label.font.withSize(50)
                cell.label.frame = CGRect(x: 24, y: 15, width: 976, height: 65)
            }
            
            cell.label.sizeToFit()
            
            //dismiss tv
            cell.dismissTableViewButton.frame.size = cell.frame.size
            
            cell.delegate = self

            //seperator view resize
            if screenHeight == 568 && screenWidth == 320{
                cell.seperatorView.frame = CGRect(x: 0, y: cell.label.frame.size.height + 10, width: 320, height: 1)
            }
            else if screenHeight == 667 && screenWidth == 375{
                cell.seperatorView.frame = CGRect(x: 0, y: cell.label.frame.size.height + 16, width: 375, height: 2)
            }
            else if screenHeight == 1024 && screenWidth == 768{
                cell.seperatorView.frame.origin = CGPoint(x: 0, y: cell.label.frame.size.height + 20)
            }
            else if screenHeight == 1194 && screenWidth == 834{
                cell.seperatorView.frame.origin = CGPoint(x: 0, y: cell.label.frame.size.height + 20)
            }
            else if screenHeight == 1112 && screenWidth == 834{
                cell.seperatorView.frame.origin = CGPoint(x: 0, y: cell.label.frame.size.height + 20)
            }
            else if screenHeight == 1080 && screenWidth == 810{
                cell.seperatorView.frame.origin = CGPoint(x: 0, y: cell.label.frame.size.height + 20)
            }
            else if screenHeight == 1366 && screenWidth == 1024{
                cell.seperatorView.frame.origin = CGPoint(x: 0, y: cell.label.frame.size.height + 30)
            }
            else{
                //setup seperatorview to bottom
                cell.seperatorView.frame.origin = CGPoint(x: 0, y: cell.label.frame.size.height + 30 - 2)
            }
            
            cell.seperatorView.frame.size.width = screenWidth
            
            tempHeight = cell.label.frame.size.height
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! StopwatchCategoryCell
        //depending on type chosen, fix label
        switch chosenType{
           case .category:
               let categoryRealm = realm.objects(Category.self)
           
               cell.label.text = categoryRealm[indexPath.row].name
           case .routine:
               let routineRealm = realm.objects(Routine.self)
           
               cell.label.text = routineRealm[indexPath.row].name
        }
        
        //size dependent resizing
        if screenHeight == 896 && screenWidth == 414{
            cell.label.frame = CGRect(x: 24, y: 15, width: 366, height: 33)
        }
        else if screenHeight == 812 && screenWidth == 375{
            cell.label.frame = CGRect(x: 24, y: 15, width: 327, height: 33)
        }
        else if screenHeight == 667 && screenWidth == 375{
            cell.label.frame = CGRect(x: 24, y: 8, width: 327, height: 33)
        }
        else if screenHeight == 736 && screenWidth == 414{
            cell.label.frame = CGRect(x: 24, y: 15, width: 366, height: 33)
        }
        else if screenHeight == 568 && screenWidth == 320{
            cell.label.font = cell.label.font.withSize(20)
            cell.label.frame = CGRect(x: 24, y: 5, width: 281, height: 26)
        }
        else if screenHeight == 1024 && screenWidth == 768{
            cell.label.font = cell.label.font.withSize(35)
            cell.label.frame = CGRect(x: 24, y: 10, width: 720, height: 46)
        }
        else if screenHeight == 1194 && screenWidth == 834{
            cell.label.font = cell.label.font.withSize(40)
            cell.label.frame = CGRect(x: 24, y: 10, width: 786, height: 52)
        }
        else if screenHeight == 1112 && screenWidth == 834{
            cell.label.font = cell.label.font.withSize(40)
            cell.label.frame = CGRect(x: 24, y: 10, width: 786, height: 52)
        }
        else if screenHeight == 1080 && screenWidth == 810{
            cell.label.font = cell.label.font.withSize(40)
            cell.label.frame = CGRect(x: 24, y: 10, width: 762, height: 52)
        }

        else if screenHeight == 1366 && screenWidth == 1024{
            cell.label.font = cell.label.font.withSize(50)
            cell.label.frame = CGRect(x: 24, y: 15, width: 976, height: 65)
        }
        
        cell.label.sizeToFit()
        
        //seperator view resize
        if screenHeight == 568 && screenWidth == 320{
            cell.seperatorView.frame = CGRect(x: 0, y: cell.label.frame.size.height + 10, width: 320, height: 1)
        }
        else if screenHeight == 667 && screenWidth == 375{
            cell.seperatorView.frame = CGRect(x: 0, y: cell.label.frame.size.height + 15, width: 375, height: 1)
        }
        else if screenHeight == 1024 && screenWidth == 768{
            cell.seperatorView.frame.origin = CGPoint(x: 0, y: cell.label.frame.size.height + 20)
        }
        else if screenHeight == 1194 && screenWidth == 834{
            cell.seperatorView.frame.origin = CGPoint(x: 0, y: cell.label.frame.size.height + 20)
        }
        else if screenHeight == 1112 && screenWidth == 834{
            cell.seperatorView.frame.origin = CGPoint(x: 0, y: cell.label.frame.size.height + 20)
        }
        else if screenHeight == 1080 && screenWidth == 810{
            cell.seperatorView.frame.origin = CGPoint(x: 0, y: cell.label.frame.size.height + 20)
        }
        else if screenHeight == 1366 && screenWidth == 1024{
            cell.seperatorView.frame.origin = CGPoint(x: 0, y: cell.label.frame.size.height + 30)
        }
        else{
            //setup seperatorview to bottom
            cell.seperatorView.frame.origin = CGPoint(x: 0, y: cell.label.frame.size.height + 30 - 2)
        }
        
        cell.seperatorView.frame.size.width = screenWidth
        
        tempHeight = cell.label.frame.size.height
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //only for XR
        if indexPath.row == tableView.numberOfRows(inSection: 0) - 1{
            if screenHeight == 568 && screenWidth == 320{
                return tempHeight + 10
            }
            else if screenHeight == 667 && screenWidth == 375{
                return tempHeight + 15
            }
            else if screenHeight == 1024 && screenWidth == 768{
                return tempHeight + 20
            }
            else if screenHeight == 1194 && screenWidth == 834{
                return tempHeight + 20
            }
            else if screenHeight == 1112 && screenWidth == 834{
                return tempHeight + 20
            }
            else if screenHeight == 1080 && screenWidth == 810{
                return tempHeight + 20
            }
            else if screenHeight == 1366 && screenWidth == 1024{
                return tempHeight + 30
            }
            
            //get rid of seperator
            return tempHeight + 28
        }
        if screenHeight == 568 && screenWidth == 320{
            return tempHeight + 11
        }
        else if screenHeight == 667 && screenWidth == 375{
            return tempHeight + 16
        }
        else if screenHeight == 1024 && screenWidth == 768{
            return tempHeight + 22
        }
        else if screenHeight == 1194 && screenWidth == 834{
            return tempHeight + 22
        }
        else if screenHeight == 1112 && screenWidth == 834{
            return tempHeight + 22
        }
        else if screenHeight == 1080 && screenWidth == 810{
            return tempHeight + 22
        }
        else if screenHeight == 1366 && screenWidth == 1024{
            return tempHeight + 32
        }
        
        return tempHeight + 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //add stop date to previously selected cell if a previously selected cell was selected
        if selectedCategoryNum >= 0{
            
            //reset date
            
            //if pause button on - hide it and show start
            if pauseView.isHidden == false{
                self.pauseView.isHidden = true
                self.startView.isHidden = false
                
                //if timer is running - add stop date
                //add stop date
                stopDate(num: selectedCategoryNum)
            }
        }

        //haptic feedback
        let selectionGenerator = UISelectionFeedbackGenerator()
        selectionGenerator.selectionChanged()
        
        //no longer selected a category
        isSelectingCategory = false
        
        //selected category nother
        selectedCategoryNum = indexPath.row
        
        //type of selected category = current chosen type
        selectedType = chosenType

        //reset all variables back to the display time
        var missingTime: Double = 0
        switch selectedType{
        case .category:
            let selectedCategoryRealm = realm.objects(Category.self)[selectedCategoryNum]
            missingTime = selectedCategoryRealm.displayTime
            
        case .routine:
            let selectedRoutineRealm = realm.objects(Routine.self)[selectedCategoryNum]
            missingTime = selectedRoutineRealm.displayTime
            
        }
        
        
        //pause timer
        timer.invalidate()
        
        //timer format
        hourC = Int(missingTime/3600)
        
        missingTime = missingTime.truncatingRemainder(dividingBy: 3600)
        
        minC = Int(missingTime/60)
        
        missingTime = missingTime.truncatingRemainder(dividingBy: 60)
        
        secondC = Int(missingTime)
        
        tenthSecond = Int(missingTime.truncatingRemainder(dividingBy: 1) * 10)
        
        timerLabel.text = String(format: "%03d:%02d:%02d", hourC, minC, secondC)
        
        //reinstate another cell
        let cell = tableView.cellForRow(at: indexPath) as! StopwatchCategoryCell
        
        switch chosenType{
            case .category:
                //set selected category text
                selectedCategoryLabel.text = "CATEGORY: \(cell.label.text!)"
            case .routine:
                //set selected routine text
                selectedCategoryLabel.text = "ROUTINE: \(cell.label.text!)"
        }
        
        //reset tableview size
        let newTableViewY = resizeTableAndButton()
        
        //animation for retraction
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            
            self.tableView.frame.size.height = 0
            
        }, completion: {_ in

            UIView.animate(withDuration: 0.3, delay: 0, animations: {
                if self.screenWidth == 414 && self.screenHeight == 896{
                    //only for XR
                    self.categoryView.frame.size.height = 63

                    //only for XR
                    self.selectedCategoryLabel.frame.size.height = 51
                    
                    //only for XR
                    self.selectedCategoryButton.frame.size.height = 63
                }
                else if self.screenWidth == 375 && self.screenHeight == 812{
                    self.categoryView.frame.size.height = 52
                    self.selectedCategoryLabel.frame.size.height = 44
                    self.selectedCategoryButton.frame.size.height = 52
                }
                else if self.screenWidth == 375 && self.screenHeight == 667{
                    self.categoryView.frame.size.height = 52
                    self.selectedCategoryLabel.frame.size.height = 44
                    self.selectedCategoryButton.frame.size.height = 52
                }
                else if self.screenWidth == 414 && self.screenHeight == 736{
                    //only for XR
                    self.categoryView.frame.size.height = 63

                    //only for XR
                    self.selectedCategoryLabel.frame.size.height = 51
                    
                    //only for XR
                    self.selectedCategoryButton.frame.size.height = 63
                }
                else if self.screenWidth == 320 && self.screenHeight == 568{
                    self.categoryView.frame.size.height = 48
                    self.selectedCategoryLabel.frame.size.height = 44
                    self.selectedCategoryButton.frame.size.height = 48
                }
                else if self.screenWidth == 768 && self.screenHeight == 1024{
                    self.categoryView.frame.size.height = 83
                    self.selectedCategoryLabel.frame.size.height = 63
                    self.selectedCategoryButton.frame.size.height = 83
                }
                else if self.screenWidth == 834 && self.screenHeight == 1194{
                    self.categoryView.frame.size.height = 90
                    self.selectedCategoryLabel.frame.size.height = 70
                    self.selectedCategoryButton.frame.size.height = 90
                }
                else if self.screenWidth == 834 && self.screenHeight == 1112{
                    self.categoryView.frame.size.height = 90
                    self.selectedCategoryLabel.frame.size.height = 70
                    self.selectedCategoryButton.frame.size.height = 90
                }
                else if self.screenWidth == 810 && self.screenHeight == 1080{
                    self.categoryView.frame.size.height = 90
                    self.selectedCategoryLabel.frame.size.height = 70
                    self.selectedCategoryButton.frame.size.height = 90
                }
                else if self.screenWidth == 1024 && self.screenHeight == 1366{
                    self.categoryView.frame.size.height = 113
                    self.selectedCategoryLabel.frame.size.height = 83
                    self.selectedCategoryButton.frame.size.height = 113
                }
            }, completion: {_ in
                self.tableView.frame.origin.y = newTableViewY
                self.tableView.reloadData()
            })
        })
    }
    
}

extension Stopwatch: dismissTableView{
    func dismissTV() {
        categorySelectionPressed(nil)
    }
}
