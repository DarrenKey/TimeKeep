//
//  CustomEvent.swift
//  TimeKeep
//
//  Created by Mi Yan on 9/20/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//

import UIKit
import RealmSwift
import BEMCheckBox

class CustomEvent: UIViewController {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var categoryOrRoutineLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var customEventLabel: UILabel!
    
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var routineButton: UIButton!
    @IBOutlet weak var routineLabel: UILabel!
    
    @IBOutlet weak var selectedView: UIView!
    
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var trashCanIcon: UIImageView!
    @IBOutlet weak var trashCanButton: UIButton!
    
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var blurButton: UIButton!
    
    @IBOutlet weak var calendarContainerView: UIView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var firstSeperator: UIView!
    @IBOutlet weak var secondSeperator: UIView!
    
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var startDateView: UIView!
    @IBOutlet weak var startDateButton: UIButton!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var timeLabelStartDate: UILabel!
    @IBOutlet weak var timeStartDateTextField: UITextField!
    
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var endDateView: UIView!
    @IBOutlet weak var endDateButton: UIButton!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var timeLabelEndDate: UILabel!
    @IBOutlet weak var timeEndDateTextField: UITextField!
    
    ///array of months for label
    var monthArray: [String] = ["January","February","March","April","May","June","July", "August","September","October","November","December"]
    
    ///if should modify stopwatch
    var changeCurrentStopWatchStop = false
    var changeCurrentStopWatchResumeDate = false
    
    ///start and end dates
    var startMonth: Int = -1
    var startDay: Int = -1
    
    var endMonth: Int = -1
    var endDay: Int = -1
    
    ///start and end hours
    var startHour: Int = -1
    var startMinute: Int = -1
    
    var endHour: Int = -1
    var endMinute: Int = -1
    
    var finalStartDate = Date()
    var finalEndDate = Date()
    
    ///get CalendarPopup
    var calendarContainer = CalendarPopup()
    
    ///haptic feedback
    var mediumGenerator: UIImpactFeedbackGenerator? = nil
    
    ///resize
    var screenHeight: CGFloat = 0
    var screenWidth: CGFloat = 0
    
    ///enumeration of which type -- category or routine
    enum addEventTimeType{
        case category
        case routine
    }
    
    var chosenAddEventTimeType = addEventTimeType.category
    
    ///actually chosen cell # and type
    var actualAddEventTimeType = addEventTimeType.category
    var cellNumber = -1
    
    ///which tab it's from
    enum vcFromType{
        case stopwatch
        case charts
        case timeline
    }
    
    var actualVCFrom = vcFromType.stopwatch
    
    ///enumeration of which type of date -- start or end
    enum startOrEndType{
        case startDate
        case endDate
    }
    
    var chosenDateType = startOrEndType.startDate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        
        let categoryRealm = realm.objects(Category.self)
        let routineRealm = realm.objects(Routine.self)
        print(cellNumber, "cellNumber")
        print(categoryRealm, "categoryRealm")
        
        ///standard tableView setup
        tableView.delegate = self
        tableView.dataSource = self
        
        ///set tableview border color
        tableView.layer.borderColor = UIColor.black.cgColor
        tableView.layer.borderWidth = 2
        
        ///resize everything
        let screen = UIScreen.main.bounds
        screenWidth = screen.size.width
        screenHeight = screen.size.height
        print(view.frame, screenWidth, screenHeight)
        
        ///date picker as keyboard
        timeStartDateTextField.setInputViewDatePicker(target: self, selector: #selector(tapDoneStartDate))
        timeEndDateTextField.setInputViewDatePicker(target: self, selector: #selector(tapDoneEndDate))
        
        ///date setup
        //Jan 1 2020
        var dateComponents = DateComponents()
        dateComponents.year = 2020
        dateComponents.month = 1
        dateComponents.day = 1
        
        let firstDate = Calendar.current.date(from: dateComponents)!
        
        //get current date month since Jan 1 2020
        let monthFromFirstMonth: Int = Calendar.current.dateComponents([.month], from: firstDate, to: Date()).month ?? 0
        
        //get current day
        let currentDay: Int = Calendar.current.dateComponents([.day], from: Date()).day ?? 0
        
        let currentHour: Int = Calendar.current.dateComponents([.hour], from: Date()).hour ?? 0
        
        let currentMinute: Int = Calendar.current.dateComponents([.minute], from: Date()).minute ?? 0
        
        ///start + end date format
        startMonth = monthFromFirstMonth
        endMonth = monthFromFirstMonth
        
        startDay = currentDay
        endDay = currentDay
        
        startHour = currentHour
        endHour = currentHour
        
        startMinute = currentMinute
        endMinute = currentMinute
        
        startLabel.text = "\(monthArray[monthFromFirstMonth % 12]) \(currentDay), \(Int(monthFromFirstMonth/12) + 2020)"
        
        endLabel.text = "\(monthArray[monthFromFirstMonth % 12]) \(currentDay), \(Int(monthFromFirstMonth/12) + 2020)"
        
        ///time format
        let dateformatter = DateFormatter()
        dateformatter.timeStyle = .short
        dateformatter.dateStyle = .none
        
        let currentDate = Date()
        
        timeStartDateTextField.text = dateformatter.string(from: currentDate)
        timeEndDateTextField.text = dateformatter.string(from: currentDate)
        
        finalStartDate = currentDate
        finalEndDate = currentDate
        
        print(startHour,endHour)
    }
    
    ///choose category or routine
    @IBAction func categoryButtonPressed(_ sender: Any) {
        chosenAddEventTimeType = .category
        
        ///change label to "Category:"
        categoryOrRoutineLabel.text = "Category:"

        tableView.reloadData()
        
        ///haptic feedback
        let selectionGenerator = UISelectionFeedbackGenerator()
        selectionGenerator.selectionChanged()
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.selectedView.frame.origin = self.categoryButton.frame.origin
        }, completion: nil)
    }
    
    @IBAction func routineButtonPressed(_ sender: Any) {
        chosenAddEventTimeType = .routine
        
        ///change label to "Category:"
        categoryOrRoutineLabel.text = "Routine:"

        tableView.reloadData()
        print("routine")
        
        ///haptic feedback
        let selectionGenerator = UISelectionFeedbackGenerator()
        selectionGenerator.selectionChanged()
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.selectedView.frame.origin = self.routineButton.frame.origin
        }, completion: nil)
    }
    
    ///date picker as keyboard for both start date and end date
    @objc func tapDoneStartDate() {
        if let datePicker = self.timeStartDateTextField.inputView as? UIDatePicker {
            let dateformatter = DateFormatter()
            dateformatter.timeStyle = .short
            dateformatter.dateStyle = .none
            self.timeStartDateTextField.text = dateformatter.string(from: datePicker.date)
            
            let startTime = Calendar.current.dateComponents([.hour,.minute], from: datePicker.date)
            
            startHour = startTime.hour ?? 0
            startMinute = startTime.minute ?? 0
            
            ///turn start date into actual date
            var dateComponents = DateComponents()
            dateComponents.year = 2020 + Int(startMonth/12)
            dateComponents.month = startMonth % 12 + 1
            dateComponents.day = startDay
            dateComponents.hour = startHour
            dateComponents.minute = startMinute
            dateComponents.second = 0
            
            finalStartDate = Calendar.current.date(from: dateComponents)!
            
            ///check save enable
            checkSaveEnable()
        }
        
    
        self.timeStartDateTextField.resignFirstResponder()
    }
    
    @objc func tapDoneEndDate() {
        if let datePicker = self.timeEndDateTextField.inputView as? UIDatePicker {
            let dateformatter = DateFormatter()
            dateformatter.timeStyle = .short
            dateformatter.dateStyle = .none
            self.timeEndDateTextField.text = dateformatter.string(from: datePicker.date)
            
            let endTime = Calendar.current.dateComponents([.hour,.minute], from: datePicker.date)
            
            endHour = endTime.hour ?? 0
            endMinute = endTime.minute ?? 0
            
            ///turn end date into actual date
            var dateComponents = DateComponents()
            dateComponents.year = 2020 + Int(endMonth/12)
            dateComponents.month = endMonth % 12 + 1
            dateComponents.day = endDay
            dateComponents.hour = endHour
            dateComponents.minute = endMinute
            dateComponents.second = 0
            
            finalEndDate = Calendar.current.date(from: dateComponents)!
            
            ///check save enable
            checkSaveEnable()
        }
        
        self.timeEndDateTextField.resignFirstResponder()
    }
    
    ///bring down calendar
    @IBAction func startDatePressed(_ sender: Any) {
        chosenDateType = .startDate
        
        openCalendar()
    }
    
    @IBAction func endDatePressed(_ sender: Any) {
        chosenDateType = .endDate
        
        openCalendar()
    }
    
    //open calendar
    func openCalendar(){
        switch chosenDateType{
        case .startDate:
            calendarContainer.highlightedMonth = startMonth
            calendarContainer.highlightedDay = startDay
            
        case .endDate:
            calendarContainer.highlightedMonth = endMonth
            calendarContainer.highlightedDay = endDay
        }
        
        //enable blurview
        blurView.isHidden = false
        
        calendarContainer.collectionView.reloadData()
        calendarContainer.collectionView.scrollToItem(at: [0,calendarContainer.highlightedMonth], at: .centeredHorizontally, animated: false)
        
        
        self.presentationController?.presentedView?.gestureRecognizers?.forEach {
            $0.isEnabled = false
        }
        
        //haptic feedback
        mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
        mediumGenerator?.prepare()
        mediumGenerator?.impactOccurred()
        mediumGenerator = nil
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.25, options: .curveEaseOut, animations: {
            
            self.calendarContainerView.frame.origin.y = (self.view.frame.height - self.calendarContainerView.frame.size.height)/2
            
        }, completion: nil)
        
        //calendar tutorial
//        startingCalendarTutorial()
    }
    
    ///get calendarcontainer
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CalendarPopup"{
            calendarContainer = segue.destination as! CalendarPopup
            
            calendarContainer.delegate = self
        }
        
        if segue.identifier == "unwindCustomEvent"{
            switch actualVCFrom{
            case .stopwatch:
                let stopwatch = segue.destination as! Stopwatch
                
                saveTask()
                
                print(changeCurrentStopWatchStop, changeCurrentStopWatchResumeDate)
                ///change current stopwatch
                if changeCurrentStopWatchStop == true && stopwatch.selectedCategoryNum >= 0{
                    stopwatch.stopDateAfterCustomEvent()
                }
                
                else if changeCurrentStopWatchResumeDate == true{
                    stopwatch.resumeDate()
                }
                
                else if stopwatch.selectedCategoryNum >= 0{
                    stopwatch.stopDateAfterCustomEvent()
                }
            case .charts:
                let charts = segue.destination as! Charts
                
                saveTask()
                
                charts.viewWillAppear(false)
            case .timeline:
                let timeline = segue.destination as! Timeline
                
                saveTask()
                
                timeline.viewWillAppear(false)
            }
        }
    }
    
    ///Calculate the display time for either removal or additions.
    func calculateDisplayTime(hasNeverReset: Bool, lastResetDate: Date, startDate: Date, endDate: Date) -> Double{
        ///add to displayTime
        let currentDate = Date()
        
        var firstDate = currentDate
        var secondDate = currentDate
        
        ///firstDate
        if hasNeverReset == false{
            ///resetDate between startDate and endDate
            if lastResetDate.isBetween(startDate, and: endDate){
                firstDate = lastResetDate
            }
            else if lastResetDate <= startDate{
                if startDate <= currentDate{
                    firstDate = startDate
                }
            }
        }
        else{
            if startDate <= currentDate{
                firstDate = startDate
            }
        }
        
        ///secondDate
        if hasNeverReset == false{
            if lastResetDate <= endDate{
                if endDate <= currentDate{
                    secondDate = endDate
                }
                else{
                    secondDate = currentDate
                }
            }
        }
        else{
            if endDate <= currentDate{
                secondDate = endDate
            }
            else{
                secondDate = currentDate
            }
        }
        
        return (secondDate.timeIntervalSince(firstDate))
    }
    
    ///actually save task
    func saveTask(){
        let realm = try! Realm()
        
        let categoryRealm = realm.objects(Category.self)
        let routineRealm = realm.objects(Routine.self)
        print(cellNumber, "cellNumber")
        print(categoryRealm, "categoryRealm")
        try! realm.write{
            ///for each category
            for category in categoryRealm{
                ///for each time stored in each category
                let numOfDates = category.time.count - 1
                let amountOfDates = Int(category.time.count/2)
                
                for dateNum in 0..<amountOfDates{
                    ///if start date > finalStartDate - move startDate to endDate
                    print(dateNum)
                    ///reverse the category - makes it easier to remove stuff
                    var startDate = category.time[numOfDates - (dateNum * 2 + 1)]
                    var endDate = category.time[numOfDates - dateNum * 2]
                    
                    ///subtract displayTime
                    var displayTime: Double = 0
                    
                    if let lastResetDate = category.lastResetDate{
                        displayTime = calculateDisplayTime(hasNeverReset: false, lastResetDate: lastResetDate, startDate: startDate, endDate: endDate)
                    }
                    else{
                        displayTime = calculateDisplayTime(hasNeverReset: true, lastResetDate: Date(), startDate: startDate, endDate: endDate)
                    }
                    
                    category.displayTime -= displayTime
                    
                    if startDate.isBetween(finalStartDate, and: finalEndDate) == true{
                        category.time[numOfDates - (dateNum * 2 + 1)] = finalEndDate
                    }
                    
                    if endDate.isBetween(finalStartDate, and: finalEndDate) == true{
                        category.time[numOfDates - dateNum * 2] = finalStartDate
                    }
                    
                    startDate = category.time[numOfDates - (dateNum * 2 + 1)]
                    endDate = category.time[numOfDates - dateNum * 2]
                    
                    if startDate >= endDate{
                        ///remove start date and enddate
                        category.time.remove(at: numOfDates - (dateNum * 2))
                        category.time.remove(at: numOfDates - (dateNum * 2 + 1))
                    }
                    else{
                        ///subtract displayTime
                        var displayTime: Double = 0
                        
                        if let lastResetDate = category.lastResetDate{
                            displayTime = calculateDisplayTime(hasNeverReset: false, lastResetDate: lastResetDate, startDate: startDate, endDate: endDate)
                        }
                        else{
                            displayTime = calculateDisplayTime(hasNeverReset: true, lastResetDate: Date(), startDate: startDate, endDate: endDate)
                        }
                        
                        
                        category.displayTime += displayTime
                    }
                }
                
                ///if a timer is still running
                if category.time.count % 2 != 0{
                    let lastTimeStarted = category.time.last!
                    
                    let currentDate = Date()
                    
                    print("timer still running")
                    
                    if lastTimeStarted <= finalEndDate{
                        
                        ///if between finalStartDate and finalEndDate
                        if lastTimeStarted >= finalStartDate{
                            if finalEndDate > currentDate{
                                category.time.remove(at: category.time.count - 1)
                                
                                changeCurrentStopWatchStop = true
                            }
                            
                            else if finalEndDate <= currentDate{
                                category.time[category.time.count - 1] = finalEndDate
                                
                                changeCurrentStopWatchResumeDate = true
                            }
                        }
                        
                        ///if before finalStartDate
                        if lastTimeStarted < finalStartDate{
                            if finalEndDate > currentDate{
                                category.time.append(finalStartDate)
                                
                                category.displayTime += finalStartDate.timeIntervalSince(lastTimeStarted)
                                
                                changeCurrentStopWatchStop = true
                            }
                            
                            else if finalEndDate <= currentDate{
                                category.time.append(finalStartDate)
                                
                                category.displayTime += finalStartDate.timeIntervalSince(lastTimeStarted)
                                
                                category.time.append(finalEndDate)
                                
                                changeCurrentStopWatchResumeDate = true
                            }
                        }
                    }
                }
            }
            
            ///for each routine
            for routine in routineRealm{
                ///for each time stored in each routine
                let numOfDates = routine.time.count - 1
                let amountOfDates = Int(routine.time.count/2)
                
                for dateNum in 0..<amountOfDates{
                    ///if start date > finalStartDate - move startDate to endDate
                    
                    ///reverse the routine - makes it easier
                    var startDate = routine.time[numOfDates - (dateNum * 2 + 1)]
                    var endDate = routine.time[numOfDates - dateNum * 2]
                    
                    ///subtract displayTime
                    var displayTime: Double = 0
                    
                    if let lastResetDate = routine.lastResetDate{
                        displayTime = calculateDisplayTime(hasNeverReset: false, lastResetDate: lastResetDate, startDate: startDate, endDate: endDate)
                    }
                    else{
                        displayTime = calculateDisplayTime(hasNeverReset: true, lastResetDate: Date(), startDate: startDate, endDate: endDate)
                    }
                    
                    routine.displayTime -= displayTime
                    
                    if startDate.isBetween(finalStartDate, and: finalEndDate) == true{
                        routine.time[numOfDates - (dateNum * 2 + 1)] = finalEndDate
                    }
                    
                    if endDate.isBetween(finalStartDate, and: finalEndDate) == true{
                        routine.time[numOfDates - dateNum * 2] = finalStartDate
                    }
                    
                    startDate = routine.time[numOfDates - (dateNum * 2 + 1)]
                    endDate = routine.time[numOfDates - dateNum * 2]
                    
                    if startDate >= endDate{
                        ///remove start date and enddate
                        routine.time.remove(at: numOfDates - (dateNum * 2))
                        routine.time.remove(at: numOfDates - (dateNum * 2 + 1))
                    }
                    else{
                        ///subtract displayTime
                        var displayTime: Double = 0
                        
                        if let lastResetDate = routine.lastResetDate{
                            displayTime = calculateDisplayTime(hasNeverReset: false, lastResetDate: lastResetDate, startDate: startDate, endDate: endDate)
                        }
                        else{
                            displayTime = calculateDisplayTime(hasNeverReset: true, lastResetDate: Date(), startDate: startDate, endDate: endDate)
                        }
                        routine.displayTime += displayTime
                    }
                }
                
                ///if a timer is still running
                if routine.time.count % 2 != 0{
                    let lastTimeStarted = routine.time.last!
                    
                    let currentDate = Date()
                    
                    if lastTimeStarted <= finalEndDate{
                        ///if between finalStartDate and finalEndDate
                        if lastTimeStarted >= finalStartDate{
                            if finalEndDate > currentDate{
                                changeCurrentStopWatchStop = true
                                
                                routine.time.remove(at: routine.time.count - 1)
                            }
                            
                            else if finalEndDate <= currentDate{
                                changeCurrentStopWatchResumeDate = true
                                
                                routine.time[routine.time.count - 1] = finalEndDate
                            }
                        }
                        
                        ///if before finalStartDate
                        if lastTimeStarted < finalStartDate{
                            if finalEndDate > currentDate{
                                changeCurrentStopWatchStop = true
                                
                                routine.time.append(finalStartDate)
                                
                                routine.displayTime += finalStartDate.timeIntervalSince(lastTimeStarted)
                            }
                            
                            else if finalEndDate <= currentDate{
                                changeCurrentStopWatchResumeDate = true
                                
                                routine.time.append(finalStartDate)
                                
                                routine.displayTime += finalStartDate.timeIntervalSince(lastTimeStarted)
                                
                                routine.time.append(finalEndDate)
                            }
                        }
                    }
                }
            }
            
            ///add timeEvent
            switch actualAddEventTimeType {
            case .category:
                categoryRealm[cellNumber].time.insert(finalEndDate,at: 0)
                categoryRealm[cellNumber].time.insert(finalStartDate,at: 0)
                
                ///If finalEndDate > current Date, add it to the timeToBeAdded section
                if finalEndDate > Date(){
                    categoryRealm[cellNumber].timeToBeAdded.append(finalStartDate)
                    categoryRealm[cellNumber].timeToBeAdded.append(finalEndDate)
                }
                
                ///add to displayTime
                var displayTime: Double = 0
                
                if let lastResetDate = categoryRealm[cellNumber].lastResetDate{
                    displayTime = calculateDisplayTime(hasNeverReset: false, lastResetDate: lastResetDate, startDate: finalStartDate, endDate: finalEndDate)
                }
                else{
                    displayTime = calculateDisplayTime(hasNeverReset: true, lastResetDate: Date(), startDate: finalStartDate, endDate: finalEndDate)
                }
                
                categoryRealm[cellNumber].displayTime += displayTime
            case .routine:
                routineRealm[cellNumber].time.insert(finalEndDate,at: 0)
                routineRealm[cellNumber].time.insert(finalStartDate,at: 0)
                
                ///If finalEndDate > current Date, add it to the timeToBeAdded section
                if finalEndDate > Date(){
                    routineRealm[cellNumber].timeToBeAdded.append(finalStartDate)
                    routineRealm[cellNumber].timeToBeAdded.append(finalEndDate)
                }
                
                ///add to displayTime
                var displayTime: Double = 0
                
                if let lastResetDate = routineRealm[cellNumber].lastResetDate{
                    displayTime = calculateDisplayTime(hasNeverReset: false, lastResetDate: lastResetDate, startDate: finalStartDate, endDate: finalEndDate)
                }
                else{
                    displayTime = calculateDisplayTime(hasNeverReset: true, lastResetDate: Date(), startDate: finalStartDate, endDate: finalEndDate)
                }
                
                routineRealm[cellNumber].displayTime += displayTime
            }
            
        }
    }
    
    ///check if should save
    func checkSaveEnable(){
        if cellNumber >= 0 && finalEndDate > finalStartDate{
            saveButton.isUserInteractionEnabled = true
            UIView.animate(withDuration: 0.5, animations: {
                self.saveButton.backgroundColor = UIColor(hex: "5DD048")
            })
        }
        else{
            saveButton.isUserInteractionEnabled = false
            
            UIView.animate(withDuration: 0.5, animations: {
                self.saveButton.backgroundColor = UIColor(hex: "C8C8C8")
            })
        }
        
    }
}

extension CustomEvent: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch chosenAddEventTimeType{
        case .category:
            ///start realm
            let realm = try! Realm()
            
            ///call category from realms
            let categoryRealm = realm.objects(Category.self)
            
            return categoryRealm.count
            
        case .routine:
            ///start realm
            let realm = try! Realm()
            
            ///call category from realms
            let routineRealm = realm.objects(Routine.self)
            
            return routineRealm.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell") as! NewTaskCategoryCell
        
        ///start realm
        let realm = try! Realm()
        
        switch chosenAddEventTimeType{
        case .category:
            let categoryRealm = realm.objects(Category.self)
            
            let categoryItem = categoryRealm[indexPath.item]
            
            ///set name
            cell.categoryName.text = categoryItem.name
            
            ///set color
            cell.colorView.backgroundColor = UIColor(hue: CGFloat(categoryItem.h), saturation: CGFloat(categoryItem.s), brightness: CGFloat(categoryItem.b), alpha: CGFloat(categoryItem.a))
        case .routine:
            let routineRealm = realm.objects(Routine.self)
            
            let routineItem = routineRealm[indexPath.item]
            
            ///set name
            cell.categoryName.text = routineItem.name
            
            ///set color
            cell.colorView.backgroundColor = UIColor(hue: CGFloat(routineItem.h), saturation: CGFloat(routineItem.s), brightness: CGFloat(routineItem.b), alpha: CGFloat(routineItem.a))
            
        }
        
        ///cell checkmark settings
        cell.checkMark.boxType = .square
        cell.checkMark.onAnimationType = .oneStroke
        cell.checkMark.tintColor = .clear
        cell.checkMark.onCheckColor = .white
        cell.checkMark.onTintColor = .white
        cell.checkMark.setOn(false, animated: false)
        
        if screenWidth == 375 && screenHeight == 812{
            cell.colorView.frame = CGRect(x: 0, y: 0, width: 40, height: 44)
            cell.seperator.frame = CGRect(x: 0, y: 42, width: 299, height: 2)
            cell.categoryName.frame = CGRect(x: 50, y: 9, width: 209, height: 26)
            cell.checkMark.frame = CGRect(x: 269, y: 9, width: 25, height: 25)
        }
        
        else if screenWidth == 375 && screenHeight == 667{
            cell.colorView.frame = CGRect(x: 0, y: 0, width: 40, height: 44)
            cell.seperator.frame = CGRect(x: 0, y: 43, width: 299, height: 1)
            cell.categoryName.frame = CGRect(x: 50, y: 9.5, width: 209, height: 26)
            cell.checkMark.frame = CGRect(x: 269, y: 9.5, width: 25, height: 25)
        }
        else if screenWidth == 320 && screenHeight == 568{
            cell.colorView.frame = CGRect(x: 0, y: 0, width: 30, height: 32)
            cell.seperator.frame = CGRect(x: 0, y: 31, width: 244, height: 1)
            cell.categoryName.font = cell.categoryName.font.withSize(15)
            cell.categoryName.frame = CGRect(x: 35, y: 5.5, width: 179, height: 20)
            cell.checkMark.frame = CGRect(x: 219, y: 5.5, width: 20, height: 20)
        }
        else if screenWidth == 768 && screenHeight == 1024{
            cell.colorView.frame = CGRect(x: 0, y: 0, width: 70, height: 59)
            cell.seperator.frame = CGRect(x: 0, y: 59, width: 634, height: 2)
            cell.categoryName.font = cell.categoryName.font.withSize(30)
            cell.categoryName.frame = CGRect(x: 80, y: 10, width: 488, height: 39)
            cell.checkMark.frame = CGRect(x: 578, y: 10, width: 41, height: 41)
        }
        else if screenWidth == 834 && screenHeight == 1112{
            cell.colorView.frame = CGRect(x: 0, y: 0, width: 70, height: 59)
            cell.seperator.frame = CGRect(x: 0, y: 59, width: 634, height: 2)
            cell.categoryName.font = cell.categoryName.font.withSize(30)
            cell.categoryName.frame = CGRect(x: 80, y: 10, width: 488, height: 39)
            cell.checkMark.frame = CGRect(x: 578, y: 10, width: 41, height: 41)
        }
        else if screenWidth == 1024 && screenHeight == 1366{
            cell.colorView.frame = CGRect(x: 0, y: 0, width: 70, height: 59)
            cell.seperator.frame = CGRect(x: 0, y: 59, width: 634, height: 2)
            cell.categoryName.font = cell.categoryName.font.withSize(30)
            cell.categoryName.frame = CGRect(x: 80, y: 10, width: 488, height: 39)
            cell.checkMark.frame = CGRect(x: 578, y: 10, width: 41, height: 41)
        }
        else if screenWidth == 834 && screenHeight == 1194{
            cell.colorView.frame = CGRect(x: 0, y: 0, width: 70, height: 59)
            cell.seperator.frame = CGRect(x: 0, y: 59, width: 634, height: 2)
            cell.categoryName.font = cell.categoryName.font.withSize(30)
            cell.categoryName.frame = CGRect(x: 80, y: 10, width: 488, height: 39)
            cell.checkMark.frame = CGRect(x: 578, y: 10, width: 41, height: 41)
        }
        else if screenWidth == 810 && screenHeight == 1080{
            cell.colorView.frame = CGRect(x: 0, y: 0, width: 70, height: 59)
            cell.seperator.frame = CGRect(x: 0, y: 59, width: 634, height: 2)
            cell.categoryName.font = cell.categoryName.font.withSize(30)
            cell.categoryName.frame = CGRect(x: 80, y: 10, width: 488, height: 39)
            cell.checkMark.frame = CGRect(x: 578, y: 10, width: 41, height: 41)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! NewTaskCategoryCell
        
        cell.checkMark.setOn(true, animated: true)
        
        ///give a cell number and set actual type
        cellNumber = indexPath.row
        actualAddEventTimeType = chosenAddEventTimeType
        
        ///check save enable
        checkSaveEnable()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! NewTaskCategoryCell
        print(indexPath, "turn off")
        cell.checkMark.setOn(false, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow,
            indexPathForSelectedRow == indexPath {
            tableView.deselectRow(at: indexPath, animated: false)
            
            let cell = tableView.cellForRow(at: indexPath) as! NewTaskCategoryCell
            print(indexPath, "turn off")
            cell.checkMark.setOn(false, animated: true)
            
            cellNumber = -1
            
            ///check save enable
            checkSaveEnable()
            
            return nil
        }
        
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        ///start realm
        let realm = try! Realm()
        
        ///call category from realms
        let categoryRealm = realm.objects(Category.self)
        
        ///if last row - get rid of seperator
        if indexPath.row == categoryRealm.count - 1{
            if screenWidth == 320 && screenHeight == 568{
                return 30
            }
            else if screenWidth == 768 && screenHeight == 1024{
                return 59
            }
            else if screenWidth == 1024 && screenHeight == 1366{
                return 59
            }
            else if screenWidth == 834 && screenHeight == 1194{
                return 59
            }
            else if screenWidth == 834 && screenHeight == 1112{
                return 59
            }
            else if screenWidth == 810 && screenHeight == 1080{
                return 59
            }
            return 42
        }

        if screenWidth == 320 && screenHeight == 568{
            return 32
        }
        else if screenWidth == 768 && screenHeight == 1024{
            return 61
        }
        else if screenWidth == 1024 && screenHeight == 1366{
            return 61
        }
        else if screenWidth == 834 && screenHeight == 1194{
            return 61
        }
        else if screenWidth == 834 && screenHeight == 1112{
            return 61
        }
        else if screenWidth == 810 && screenHeight == 1080{
            return 61
        }
        return 44
        
    }
}


extension CustomEvent: registerPress{
    func registerPress(day: Int, monthsSince: Int) {
        //haptic feedback
        let selectionGenerator = UISelectionFeedbackGenerator()
        selectionGenerator.selectionChanged()
        
        //save + label
        switch chosenDateType{
        case .startDate:
            startDay = day
            startMonth = monthsSince
            startLabel.text = "\(monthArray[monthsSince % 12]) \(day), \(Int(monthsSince/12) + 2020)"
            
        case .endDate:
            endDay = day
            endMonth = monthsSince
            endLabel.text = "\(monthArray[monthsSince % 12]) \(day), \(Int(monthsSince/12) + 2020)"
        }
        
        self.presentationController?.presentedView?.gestureRecognizers?.forEach {
            $0.isEnabled = true
        }
        
        //turn off blurview
        blurView.isHidden = true
        
        //close calendar
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            
            self.calendarContainerView.frame.origin.y = -self.calendarContainerView.frame.size.height
            
        }, completion:nil)
        
        calendarContainer.isYearEnabled = false
        
        ///turn start and end dates into actual dates
        switch chosenDateType{
        case .startDate:
            var dateComponents = DateComponents()
            dateComponents.year = 2020 + Int(startMonth/12)
            dateComponents.month = startMonth % 12 + 1
            dateComponents.day = startDay
            dateComponents.hour = startHour
            dateComponents.minute = startMinute
            
            finalStartDate = Calendar.current.date(from: dateComponents)!
            
        case .endDate:
            var dateComponents = DateComponents()
            dateComponents.year = 2020 + Int(endMonth/12)
            dateComponents.month = endMonth % 12 + 1
            dateComponents.day = endDay
            dateComponents.hour = endHour
            dateComponents.minute = endMinute
            
            finalEndDate = Calendar.current.date(from: dateComponents)!
        }
        
        ///check save enable
        checkSaveEnable()
    }
}
