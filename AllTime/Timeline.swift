//
//  Timeline.swift
//  TimeKeep
//
//  Created by Mi Yan on 5/9/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//

import UIKit
import Charts
import RealmSwift
import CoreGraphics

struct timeBetween{
    var timeSinceBeginning: Double
    var color: UIColor
    var name: String
    
    
    ///0 - first part, 1 - second part
    var partNum: Int
}

class Timeline: UIViewController {

    @IBOutlet weak var barChart: BarChartView!
    
    @IBOutlet weak var tapLabel: UILabel!
    @IBOutlet weak var dateButton: UIButton!
    
    //delegate to tell mainview to bring down calendar
    var delegate: toMainView?
    
    var touchLocation: CGPoint = CGPoint(x: 0, y: 0)
    
    var dateYear = 0
    var dateMonth = 0
    var dateDay = 0
    
    //get name of month array
    var monthArray: [String] = ["January","February","March","April","May","June","July",
    "August","September","October","November","December"]
    
    //aelected day, week, month
    enum dateType{
        case day
        case week
        case month
    }
    
    var chosenDateType = dateType.day
    
    @IBOutlet weak var typeView: UIView!
    
    @IBOutlet weak var dayButton: UIButton!
    @IBOutlet weak var weekButton: UIButton!
    @IBOutlet weak var monthButton: UIButton!
    
    var nameArray: [String] = []
    var dayArray: [[String]] = []
    
    @IBOutlet weak var timelineWidthSizeCalculationLabel: UILabel!
    
    @IBOutlet weak var xAxisLabelSizeCalculationLabel: UILabel!
    
    @IBOutlet weak var valueSizeHeightCalculationLbel: UILabel!
    
    //add custom event
    @IBOutlet weak var addCustomEventButton: UIButton!
    
    //month array name x axis
    var nameXAxisArray: [String] = []
    
    //array of bar chart set
    var barChartSetArray: [BarChartDataSet] = []
    
    @IBOutlet weak var timelineLabel: UILabel!
    
    //resizing
    var screenHeight: CGFloat = 0
    var screenWidth: CGFloat = 0
    
    var fontSizeXAxis: CGFloat = 15
    var fontSizeLeftAxis: CGFloat = 20
    
    var fontValue: CGFloat = 20
    
    var topChart: CGFloat = 25
    
    var showLabelBuffer: CGFloat = 5
    
    var labelSizeBuffer: CGFloat = 30
    
    var chartOffset: CGFloat = 10
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        barChart.leftAxis.valueFormatter = HourFormat()
        //barChart.viewPortHandler.setMaximumScaleY(200)
        barChart.leftAxis.axisMinimum = 0
        barChart.rightAxis.enabled = false
        barChart.xAxis.labelPosition = .top
        barChart.xAxis.granularity = 1
        barChart.xAxis.drawGridLinesEnabled = false
        barChart.legend.enabled = false
        barChart.delegate = self
        barChart.leftAxis.labelTextColor = UIColor(hex: "E85A4F")
        barChart.leftAxis.gridColor = UIColor(hex: "E85A4F")
        barChart.leftAxis.drawAxisLineEnabled = false
        barChart.leftAxis.gridLineDashLengths = [4,3]
        barChart.gridBackgroundColor = .white
        barChart.drawGridBackgroundEnabled = true
        barChart.backgroundColor = .white
        barChart.leftAxis.axisMaximum = 1440
        //barChart.leftAxis.axisMinLabels = 20
        //barChart.leftAxis.axisMaxLabels = 30com
        let transformer = barChart.getTransformer(forAxis:.left)
        let viewPortHandler = barChart.leftYAxisRenderer.viewPortHandler
        barChart.leftYAxisRenderer = TimelineYAxisRender(viewPortHandler: viewPortHandler, yAxis: barChart.leftAxis, transformer: transformer)
        barChart.moveViewToY(1440, axis: .left)
        barChart.leftAxis.labelAlignment = .right
        barChart.leftAxis.granularityEnabled = true
        barChart.xAxis.labelTextColor = UIColor(hex: "E85A4F")
        barChart.xAxis.drawAxisLineEnabled = false
        
        //change date label to current date
        let components = Calendar.current.dateComponents([.day,.month,.year], from: Date())
        
        dateYear = components.year!
        dateMonth = components.month! - 1
        dateDay = components.day!
        
        dateButton.setTitle("\(monthArray[dateMonth]) \(dateDay), \(dateYear)", for: .normal)
        
        let screen = UIScreen.main.bounds
        screenWidth = screen.size.width
        screenHeight = screen.size.height
        
        resizeDevice()
        
        barChart.xAxis.labelFont = UIFont(name: "Futura", size: fontSizeXAxis)!
        barChart.leftAxis.labelFont = UIFont(name: "Futura", size: fontSizeLeftAxis)!
        timelineWidthSizeCalculationLabel.font = UIFont(name: "Futura", size: fontSizeLeftAxis)!
        timelineWidthSizeCalculationLabel.text = "12:00 PM"
        timelineWidthSizeCalculationLabel.sizeToFit()
        barChart.leftAxis.minWidth = timelineWidthSizeCalculationLabel.frame.size.width + 15
        
        chartDay(day: dateDay, month: dateMonth + 1, year: dateYear, barChartNum: 0)
        
        //set data of bar chart
        let data = BarChartData(dataSets: barChartSetArray)
        
        data.setDrawValues(true)
        barChart.data = data
        
        barChart.drawValueAboveBarEnabled = false
        
        //set custom renderer
        let customRenderer = CustomRenderer(dataProvider: barChart, animator: barChart.chartAnimator, viewPortHandler: barChart.viewPortHandler)
        customRenderer.delegate = self
        barChart.renderer = customRenderer
        
        //set bar chart x axis name
        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: nameXAxisArray)
        
        //top of chart calculations
        xAxisLabelSizeCalculationLabel.font = xAxisLabelSizeCalculationLabel.font.withSize(fontSizeXAxis)
        xAxisLabelSizeCalculationLabel.sizeToFit()
        topChart = xAxisLabelSizeCalculationLabel.frame.size.height + 5
        
        barChart.xAxis.labelHeight = topChart
        
        //change tapLabel font
        tapLabel.font = tapLabel.font.withSize(fontValue)
    }
    
    //reszie
    func resizeDevice(){
        if screenWidth == 375 && screenHeight == 812{
            timelineLabel.font = timelineLabel.font.withSize(35)
            timelineLabel.frame = CGRect(x: 24, y: 77, width: 156, height: 46)
            
            dateButton.titleLabel?.font = dateButton.titleLabel?.font.withSize(15)
            dateButton.frame = CGRect(x: 0, y: 156, width: 375, height: 35)
            
            typeView.frame = CGRect(x: 0, y: 191, width: 375, height: 38)
            dayButton.frame = CGRect(x: 24, y: 8, width: 107, height: 22)
            weekButton.frame = CGRect(x: 134, y: 8, width: 107, height: 22)
            monthButton.frame = CGRect(x: 244, y: 8, width: 107, height: 22)
            
            barChart.frame = CGRect(x: 0, y: 229, width: 375, height: 493)
        }
        else if screenWidth == 414 && screenHeight == 736{
            timelineLabel.frame = CGRect(x: 24, y: 50, width: 179, height: 52)
            
            dateButton.frame = CGRect(x: 0, y: 132, width: 414, height: 42)
            typeView.frame = CGRect(x: 0, y: 174, width: 414, height: 42)
            
            barChart.frame = CGRect(x: 0, y: 216, width: 414, height: 449)
        }
        else if screenWidth == 375 && screenHeight == 667{
            timelineLabel.font = timelineLabel.font.withSize(35)
            timelineLabel.frame = CGRect(x: 24, y: 50, width: 156, height: 46)
            
            dateButton.titleLabel?.font = dateButton.titleLabel?.font.withSize(15)
            dateButton.frame = CGRect(x: 0, y: 126, width: 375, height: 35)
            
            typeView.frame = CGRect(x: 0, y: 161, width: 375, height: 38)
            
            dayButton.frame = CGRect(x: 24, y: 8, width: 107, height: 22)
            weekButton.frame = CGRect(x: 134, y: 8, width: 107, height: 22)
            monthButton.frame = CGRect(x: 244, y: 8, width: 107, height: 22)
            
            barChart.frame = CGRect(x: 0, y: 199, width: 375, height: 406)
            fontSizeXAxis = 15
            fontSizeLeftAxis = 15
            
            
            fontValue = 15
        }
        else if screenWidth == 320 && screenHeight == 568{
            timelineLabel.font = timelineLabel.font.withSize(30)
            timelineLabel.frame = CGRect(x: 24, y: 40, width: 134, height: 39)
            
            dateButton.titleLabel?.font = dateButton.titleLabel?.font.withSize(15)
            dateButton.frame = CGRect(x: 0, y: 99, width: 320, height: 30)
            
            typeView.frame = CGRect(x: 0, y: 129, width: 320, height: 30)
            
            dayButton.frame = CGRect(x: 24, y: 4, width: 88, height: 22)
            weekButton.frame = CGRect(x: 116, y: 4, width: 88, height: 22)
            monthButton.frame = CGRect(x: 208, y: 4, width: 88, height: 22)
            
            barChart.frame = CGRect(x: 0, y: 158, width: 320, height: 348)
            
            fontSizeXAxis = 12
            fontSizeLeftAxis = 15
            
            fontValue = 12
        }
        else if screenWidth == 768 && screenHeight == 1024{
            timelineLabel.font = timelineLabel.font.withSize(50)
            timelineLabel.frame = CGRect(x: 24, y: 60, width: 223, height: 65)
            
            dateButton.titleLabel?.font = dateButton.titleLabel?.font.withSize(30)
            dateButton.frame = CGRect(x: 0, y: 165, width: 768, height: 55)
            
            typeView.frame = CGRect(x: 0, y: 220, width: 768, height: 65)
            
            dayButton.titleLabel?.font = dayButton.titleLabel?.font.withSize(25)
            weekButton.titleLabel?.font = weekButton.titleLabel?.font.withSize(25)
            monthButton.titleLabel?.font = monthButton.titleLabel?.font.withSize(25)
            
            dayButton.frame = CGRect(x: 24, y: 10, width: 230, height: 45)
            weekButton.frame = CGRect(x: 269, y: 10, width: 230, height: 45)
            monthButton.frame = CGRect(x: 514, y: 10, width: 230, height: 45)
            
            barChart.frame = CGRect(x: 0, y: 285, width: 768, height: 638)

            fontSizeXAxis = 20
            fontSizeLeftAxis = 25
            fontValue = 30
        }
        else if screenWidth == 834 && screenHeight == 1194{
            timelineLabel.font = timelineLabel.font.withSize(65)
            timelineLabel.frame = CGRect(x: 24, y: 50, width: 290, height: 85)
            
            dateButton.titleLabel?.font = dateButton.titleLabel?.font.withSize(35)
            dateButton.frame = CGRect(x: 0, y: 165, width: 834, height: 70)
            
            typeView.frame = CGRect(x: 0, y: 235, width: 834, height: 70)
            
            dayButton.titleLabel?.font = dayButton.titleLabel?.font.withSize(30)
            weekButton.titleLabel?.font = weekButton.titleLabel?.font.withSize(30)
            monthButton.titleLabel?.font = monthButton.titleLabel?.font.withSize(30)
            
            dayButton.frame = CGRect(x: 24, y: 10, width: 254, height: 50)
            weekButton.frame = CGRect(x: 290, y: 10, width: 254, height: 50)
            monthButton.frame = CGRect(x: 556, y: 10, width: 254, height: 50)
            
            barChart.frame = CGRect(x: 0, y: 305, width: 834, height: 758)
            
            fontSizeXAxis = 20
            fontSizeLeftAxis = 25
            fontValue = 30
        }
        else if screenWidth == 834 && screenHeight == 1112{
            timelineLabel.font = timelineLabel.font.withSize(65)
            timelineLabel.frame = CGRect(x: 24, y: 50, width: 290, height: 85)
            
            dateButton.titleLabel?.font = dateButton.titleLabel?.font.withSize(30)
            dateButton.frame = CGRect(x: 0, y: 165, width: 834, height: 60)
            
            typeView.frame = CGRect(x: 0, y: 225, width: 834, height: 60)
            
            dayButton.titleLabel?.font = dayButton.titleLabel?.font.withSize(25)
            weekButton.titleLabel?.font = weekButton.titleLabel?.font.withSize(25)
            monthButton.titleLabel?.font = monthButton.titleLabel?.font.withSize(25)
            
            dayButton.frame = CGRect(x: 24, y: 10, width: 254, height: 40)
            weekButton.frame = CGRect(x: 290, y: 10, width: 254, height: 40)
            monthButton.frame = CGRect(x: 556, y: 10, width: 254, height: 40)
            
            barChart.frame = CGRect(x: 0, y: 285, width: 834, height: 716)
            
            fontSizeXAxis = 20
            fontSizeLeftAxis = 25
            fontValue = 30
        }
        else if screenWidth == 810 && screenHeight == 1080{
            timelineLabel.font = timelineLabel.font.withSize(65)
            timelineLabel.frame = CGRect(x: 24, y: 50, width: 290, height: 85)
            
            dateButton.titleLabel?.font = dateButton.titleLabel?.font.withSize(30)
            dateButton.frame = CGRect(x: 0, y: 165, width: 810, height: 60)
            
            typeView.frame = CGRect(x: 0, y: 225, width: 810, height: 60)
            
            dayButton.titleLabel?.font = dayButton.titleLabel?.font.withSize(25)
            weekButton.titleLabel?.font = weekButton.titleLabel?.font.withSize(25)
            monthButton.titleLabel?.font = monthButton.titleLabel?.font.withSize(25)
            
            dayButton.frame = CGRect(x: 24, y: 10, width: 246, height: 40)
            weekButton.frame = CGRect(x: 282, y: 10, width: 246, height: 40)
            monthButton.frame = CGRect(x: 540, y: 10, width: 246, height: 40)
            
            barChart.frame = CGRect(x: 0, y: 285, width: 810, height: 684)
            
            fontSizeXAxis = 20
            fontSizeLeftAxis = 25
            fontValue = 30
        }
        else if screenWidth == 1024 && screenHeight == 1366{
            timelineLabel.font = timelineLabel.font.withSize(75)
            timelineLabel.frame = CGRect(x: 24, y: 60, width: 334, height: 98)
            
            dateButton.titleLabel?.font = dateButton.titleLabel?.font.withSize(50)
            dateButton.frame = CGRect(x: 0, y: 210, width: 1024, height: 89)
            
            typeView.frame = CGRect(x: 0, y: 300, width: 1024, height: 86)
            
            dayButton.titleLabel?.font = dayButton.titleLabel?.font.withSize(40)
            weekButton.titleLabel?.font = weekButton.titleLabel?.font.withSize(40)
            monthButton.titleLabel?.font = monthButton.titleLabel?.font.withSize(40)
            
            dayButton.frame = CGRect(x: 24, y: 11, width: 316, height: 64)
            weekButton.frame = CGRect(x: 356, y: 11, width: 316, height: 64)
            monthButton.frame = CGRect(x: 684, y: 11, width: 316, height: 64)
            
            barChart.frame = CGRect(x: 0, y: 386, width: 1024, height: 839)
            
            fontSizeXAxis = 20
            fontSizeLeftAxis = 25
            fontValue = 30
        }
        
        ///add custom event button resize
        addCustomEventButton.frame = CGRect(x: screenWidth - 24 - timelineLabel.frame.size.height, y: timelineLabel.frame.origin.y, width: timelineLabel.frame.size.height, height: timelineLabel.frame.size.height)
    }
    
    //stop duplicate haptic feedback
    var alreadyHapticFeedback = true
    
    //change date
    @IBAction func bringCalendarButton(_ sender: Any) {
        delegate?.calendarDown(days: dateDay, months: 12 * (dateYear - 2020) + dateMonth)
    }
    
    ///modify future custom events added
    func modifyCustomEventsAdded(){
        let realm = try! Realm()
        
        let categoryRealm = realm.objects(Category.self)
        let routineRealm = realm.objects(Routine.self)
        
            ///for each catgory
            for category in categoryRealm{
                ///for each time stored in each category
                let numDatesToBeAdded = category.timeToBeAdded.count - 1
                let amountOfDatesToBeAdded = Int(category.timeToBeAdded.count/2)
                
                for dateNum in 0..<amountOfDatesToBeAdded{
                    ///reverse the category - makes it easier to remove stuff
                    var startDate = category.time[numDatesToBeAdded - (dateNum * 2 + 1)]
                    var endDate = category.time[numDatesToBeAdded - dateNum * 2]
                    
                    modifyCustomEventsAddedLoop(finalStartDate: startDate, finalEndDate: endDate)
                    
                    if Date() >= endDate{
                        try! realm.write{
                            category.timeToBeAdded.remove(at: numDatesToBeAdded - dateNum * 2)
                            category.timeToBeAdded.remove(at: numDatesToBeAdded - (dateNum * 2 + 1))
                        }
                    }
                }
            }
            
            ///for each routine
            for routine in routineRealm{
                ///for each time stored in each category
                let numDatesToBeAdded = routine.timeToBeAdded.count - 1
                let amountOfDatesToBeAdded = Int(routine.timeToBeAdded.count/2)
                
                for dateNum in 0..<amountOfDatesToBeAdded{
                    ///reverse the category - makes it easier to remove stuff
                    var startDate = routine.time[numDatesToBeAdded - (dateNum * 2 + 1)]
                    var endDate = routine.time[numDatesToBeAdded - dateNum * 2]
                    
                    modifyCustomEventsAddedLoop(finalStartDate: startDate, finalEndDate: endDate)
                    
                    if Date() >= endDate{
                        try! realm.write{
                            routine.timeToBeAdded.remove(at: numDatesToBeAdded - dateNum * 2)
                            routine.timeToBeAdded.remove(at: numDatesToBeAdded - (dateNum * 2 + 1))
                        }
                    }
                }
            }
    }
    
    
    //func to loop
    func modifyCustomEventsAddedLoop(finalStartDate: Date, finalEndDate: Date){
        let realm = try! Realm()
        
        let categoryRealm = realm.objects(Category.self)
        let routineRealm = realm.objects(Routine.self)
        
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
                            }
                            
                            else if finalEndDate <= currentDate{
                                category.time[category.time.count - 1] = finalEndDate
                            }
                        }
                        
                        ///if before finalStartDate
                        if lastTimeStarted < finalStartDate{
                            if finalEndDate > currentDate{
                                category.time.append(finalStartDate)
                            }
                            
                            else if finalEndDate <= currentDate{
                                category.time.append(finalStartDate)
                                
                                category.time.append(finalEndDate)
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
                }
                
                ///if a timer is still running
                if routine.time.count % 2 != 0{
                    let lastTimeStarted = routine.time.last!
                    
                    let currentDate = Date()
                    
                    if lastTimeStarted <= finalEndDate{
                        ///if between finalStartDate and finalEndDate
                        if lastTimeStarted >= finalStartDate{
                            if finalEndDate > currentDate{
                                routine.time.remove(at: routine.time.count - 1)
                            }
                            
                            else if finalEndDate <= currentDate{
                                routine.time[routine.time.count - 1] = finalEndDate
                            }
                        }
                        
                        ///if before finalStartDate
                        if lastTimeStarted < finalStartDate{
                            if finalEndDate > currentDate{
                                routine.time.append(finalStartDate)
                            }
                            
                            else if finalEndDate <= currentDate{
                                routine.time.append(finalStartDate)
                                
                                routine.time.append(finalEndDate)
                            }
                        }
                    }
                }
            }
        }
    }
    
    //change date function
    func changeDate(day: Int, monthsSince: Int){
        dateDay = day
        dateMonth = monthsSince % 12
        dateYear = Int(monthsSince/12) + 2020
        
        //change label
        dateButton.setTitle("\(monthArray[dateMonth]) \(dateDay), \(dateYear)", for: .normal)
        delegate?.calendarUp()
        
        //prevent duplicate vibrations
        alreadyHapticFeedback = true
        
        //change chart
        switch chosenDateType{
        case .day:
            dayButtonPressed(nil)
    
        case .week:
            weekButtonPressed(nil)
            
        case .month:
            monthButtonPressed(nil)
        }
        
    }
    
    //refresh charts
    override func viewWillAppear(_ animated: Bool) {
        ///run modify events
        modifyCustomEventsAdded()

        //stop duplicate haptic feedback
        alreadyHapticFeedback = true
        
        //change date label to current date
        let components = Calendar.current.dateComponents([.day,.month,.year], from: Date())
        
        dateYear = components.year!
        dateMonth = components.month! - 1
        dateDay = components.day!
        
        dateButton.setTitle("\(monthArray[dateMonth]) \(dateDay), \(dateYear)", for: .normal)

        //change back to day
        dayButtonPressed(nil)
    }
    
    ///unwind segue
    @IBAction func unwindFromCustomEvent(segue: UIStoryboardSegue) {
    }
    
    ///send data to custom event
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromTimeline"{
            let customEvent = segue.destination as! CustomEvent
            
            customEvent.actualVCFrom = .timeline
        }
    }
    
    //display one day
    func chartDay(day: Int, month: Int, year: Int, barChartNum: Double){
        let realm = try! Realm()
        let selectedCategoryRealm = realm.objects(Category.self)
        let selectedRoutineRealm = realm.objects(Routine.self)
        
        //[seconds since beginning of day, color]
        var categoryArray: [timeBetween] = []

        //get beginning of day + next day
        var startOfTheDayComponents = DateComponents()
        startOfTheDayComponents.day = day
        startOfTheDayComponents.month = month
        startOfTheDayComponents.year = year
        startOfTheDayComponents.hour = 0
        startOfTheDayComponents.minute = 0
        startOfTheDayComponents.second = 0
        
        let startOfTheDay = Calendar.current.date(from: startOfTheDayComponents)!
        
        //get format for x axis name
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/dd"
        
        //append string format
        nameXAxisArray.append(dateFormatter.string(from: startOfTheDay))
        var oneDay = DateComponents()
        oneDay.day = 1
        
        let nextDay = Calendar.current.date(byAdding: oneDay, to: startOfTheDay)!
        
        
        //for each category
        for category in selectedCategoryRealm{
            
            //for each stored date in the category
            for categoryDate in 0..<category.time.count/2{
                
                //if both times in between date
                if category.time[categoryDate * 2].isBetween(startOfTheDay, and: nextDay) && category.time[categoryDate * 2 + 1].isBetween(startOfTheDay, and: nextDay){
                    let timeBetweenTemp = timeBetween(timeSinceBeginning: Double(category.time[categoryDate * 2].timeIntervalSince(startOfTheDay)), color: UIColor(hue: CGFloat(category.h), saturation: CGFloat(category.s), brightness: CGFloat(category.b), alpha: CGFloat(category.a)), name: category.name, partNum: 0)
                    categoryArray.append(timeBetweenTemp)
                    
                    let timeBetweenTempTwo = timeBetween(timeSinceBeginning: Double(category.time[categoryDate * 2 + 1].timeIntervalSince(startOfTheDay)), color: UIColor(hue: CGFloat(category.h), saturation: CGFloat(category.s), brightness: CGFloat(category.b), alpha: CGFloat(category.a)), name: category.name, partNum: 1)
                    categoryArray.append(timeBetweenTempTwo)
                }
                
                //if first time before date
                else if category.time[categoryDate * 2 + 1].isBetween(startOfTheDay, and: nextDay){
                   let timeBetweenTemp = timeBetween(timeSinceBeginning: 0, color: UIColor(hue: CGFloat(category.h), saturation: CGFloat(category.s), brightness: CGFloat(category.b), alpha: CGFloat(category.a)), name: category.name, partNum: 0)
                   categoryArray.append(timeBetweenTemp)
                   
                   let timeBetweenTempTwo = timeBetween(timeSinceBeginning: Double(category.time[categoryDate * 2 + 1].timeIntervalSince(startOfTheDay)), color: UIColor(hue: CGFloat(category.h), saturation: CGFloat(category.s), brightness: CGFloat(category.b), alpha: CGFloat(category.a)), name: category.name, partNum: 1)
                   categoryArray.append(timeBetweenTempTwo)
               }
                
                //if second time after date
                else if  category.time[categoryDate * 2].isBetween(startOfTheDay, and: nextDay){
                   let timeBetweenTemp = timeBetween(timeSinceBeginning: Double(category.time[categoryDate * 2].timeIntervalSince(startOfTheDay)), color: UIColor(hue: CGFloat(category.h), saturation: CGFloat(category.s), brightness: CGFloat(category.b), alpha: CGFloat(category.a)), name: category.name, partNum: 0)
                   categoryArray.append(timeBetweenTemp)
                   
                   let timeBetweenTempTwo = timeBetween(timeSinceBeginning: 86400, color: UIColor(hue: CGFloat(category.h), saturation: CGFloat(category.s), brightness: CGFloat(category.b), alpha: CGFloat(category.a)), name: category.name, partNum: 1)
                   categoryArray.append(timeBetweenTempTwo)
               }
            }
            
            //if category has a time not ended - create another one with current date
            if category.time.count % 2 == 1{
                
                if Date().isBetween(startOfTheDay, and: nextDay) && category.time.last!.isBetween(startOfTheDay, and: nextDay){
                    let timeBetweenTemp = timeBetween(timeSinceBeginning: Double(category.time.last!.timeIntervalSince(startOfTheDay)), color: UIColor(hue: CGFloat(category.h), saturation: CGFloat(category.s), brightness: CGFloat(category.b), alpha: CGFloat(category.a)), name: category.name, partNum: 0)
                    categoryArray.append(timeBetweenTemp)
                    
                    let timeBetweenTempTwo = timeBetween(timeSinceBeginning: Double(Date().timeIntervalSince(startOfTheDay)), color: UIColor(hue: CGFloat(category.h), saturation: CGFloat(category.s), brightness: CGFloat(category.b), alpha: CGFloat(category.a)), name: category.name, partNum: 1)
                    categoryArray.append(timeBetweenTempTwo)
                }

                 //if first time before date
                 else if Date().isBetween(startOfTheDay, and: nextDay){
                    let timeBetweenTemp = timeBetween(timeSinceBeginning: 0, color: UIColor(hue: CGFloat(category.h), saturation: CGFloat(category.s), brightness: CGFloat(category.b), alpha: CGFloat(category.a)), name: category.name, partNum: 0)
                    categoryArray.append(timeBetweenTemp)
                    
                    let timeBetweenTempTwo = timeBetween(timeSinceBeginning: Double(Date().timeIntervalSince(startOfTheDay)), color: UIColor(hue: CGFloat(category.h), saturation: CGFloat(category.s), brightness: CGFloat(category.b), alpha: CGFloat(category.a)), name: category.name, partNum: 1)
                    categoryArray.append(timeBetweenTempTwo)
                }
                 
                 //if second time after date
                else if  category.time.last!.isBetween(startOfTheDay, and: nextDay){
                    let timeBetweenTemp = timeBetween(timeSinceBeginning: Double(category.time.last!.timeIntervalSince(startOfTheDay)), color: UIColor(hue: CGFloat(category.h), saturation: CGFloat(category.s), brightness: CGFloat(category.b), alpha: CGFloat(category.a)), name: category.name, partNum: 0)
                    categoryArray.append(timeBetweenTemp)
                    
                    let timeBetweenTempTwo = timeBetween(timeSinceBeginning: 86400, color: UIColor(hue: CGFloat(category.h), saturation: CGFloat(category.s), brightness: CGFloat(category.b), alpha: CGFloat(category.a)), name: category.name, partNum: 1)
                    categoryArray.append(timeBetweenTempTwo)
                }
                
            }
        }
        
        //for each routine
        for routine in selectedRoutineRealm {
            
            //for each stored date in the routine
            for routineDate in 0..<routine.time.count/2{
                
                //if both times in between date
                if routine.time[routineDate * 2].isBetween(startOfTheDay, and: nextDay) && routine.time[routineDate * 2 + 1].isBetween(startOfTheDay, and: nextDay){
                    let timeBetweenTemp = timeBetween(timeSinceBeginning: Double(routine.time[routineDate * 2].timeIntervalSince(startOfTheDay)), color: UIColor(hue: CGFloat(routine.h), saturation: CGFloat(routine.s), brightness: CGFloat(routine.b), alpha: CGFloat(routine.a)), name: routine.name, partNum: 0)
                    categoryArray.append(timeBetweenTemp)
                    
                    let timeBetweenTempTwo = timeBetween(timeSinceBeginning: Double(routine.time[routineDate * 2 + 1].timeIntervalSince(startOfTheDay)), color: UIColor(hue: CGFloat(routine.h), saturation: CGFloat(routine.s), brightness: CGFloat(routine.b), alpha: CGFloat(routine.a)), name: routine.name, partNum: 1)
                    categoryArray.append(timeBetweenTempTwo)
                }
                
                //if first time before date
                else if routine.time[routineDate * 2 + 1].isBetween(startOfTheDay, and: nextDay){
                   let timeBetweenTemp = timeBetween(timeSinceBeginning: 0, color: UIColor(hue: CGFloat(routine.h), saturation: CGFloat(routine.s), brightness: CGFloat(routine.b), alpha: CGFloat(routine.a)), name: routine.name, partNum: 0)
                   categoryArray.append(timeBetweenTemp)
                   
                   let timeBetweenTempTwo = timeBetween(timeSinceBeginning: Double(routine.time[routineDate * 2 + 1].timeIntervalSince(startOfTheDay)), color: UIColor(hue: CGFloat(routine.h), saturation: CGFloat(routine.s), brightness: CGFloat(routine.b), alpha: CGFloat(routine.a)), name: routine.name, partNum: 1)
                   categoryArray.append(timeBetweenTempTwo)
               }
                
                //if second time after date
                else if  routine.time[routineDate * 2].isBetween(startOfTheDay, and: nextDay){
                   let timeBetweenTemp = timeBetween(timeSinceBeginning: Double(routine.time[routineDate * 2].timeIntervalSince(startOfTheDay)), color: UIColor(hue: CGFloat(routine.h), saturation: CGFloat(routine.s), brightness: CGFloat(routine.b), alpha: CGFloat(routine.a)), name: routine.name, partNum: 0)
                   categoryArray.append(timeBetweenTemp)
                   
                   let timeBetweenTempTwo = timeBetween(timeSinceBeginning: 86400, color: UIColor(hue: CGFloat(routine.h), saturation: CGFloat(routine.s), brightness: CGFloat(routine.b), alpha: CGFloat(routine.a)), name: routine.name, partNum: 1)
                   categoryArray.append(timeBetweenTempTwo)
               }
            }
            
            //if routine has a time not ended - create another one with current date
            if routine.time.count % 2 == 1{
                
                if Date().isBetween(startOfTheDay, and: nextDay) && routine.time.last!.isBetween(startOfTheDay, and: nextDay){
                    let timeBetweenTemp = timeBetween(timeSinceBeginning: Double(routine.time.last!.timeIntervalSince(startOfTheDay)), color: UIColor(hue: CGFloat(routine.h), saturation: CGFloat(routine.s), brightness: CGFloat(routine.b), alpha: CGFloat(routine.a)), name: routine.name, partNum: 0)
                    categoryArray.append(timeBetweenTemp)
                    
                    let timeBetweenTempTwo = timeBetween(timeSinceBeginning: Double(Date().timeIntervalSince(startOfTheDay)), color: UIColor(hue: CGFloat(routine.h), saturation: CGFloat(routine.s), brightness: CGFloat(routine.b), alpha: CGFloat(routine.a)), name: routine.name, partNum: 1)
                    categoryArray.append(timeBetweenTempTwo)
                }

                 //if first time before date
                 else if Date().isBetween(startOfTheDay, and: nextDay){
                    let timeBetweenTemp = timeBetween(timeSinceBeginning: 0, color: UIColor(hue: CGFloat(routine.h), saturation: CGFloat(routine.s), brightness: CGFloat(routine.b), alpha: CGFloat(routine.a)), name: routine.name, partNum: 0)
                    categoryArray.append(timeBetweenTemp)
                    
                    let timeBetweenTempTwo = timeBetween(timeSinceBeginning: Double(Date().timeIntervalSince(startOfTheDay)), color: UIColor(hue: CGFloat(routine.h), saturation: CGFloat(routine.s), brightness: CGFloat(routine.b), alpha: CGFloat(routine.a)), name: routine.name, partNum: 1)
                    categoryArray.append(timeBetweenTempTwo)
                }
                 
                 //if second time after date
                else if  routine.time.last!.isBetween(startOfTheDay, and: nextDay){
                    let timeBetweenTemp = timeBetween(timeSinceBeginning: Double(routine.time.last!.timeIntervalSince(startOfTheDay)), color: UIColor(hue: CGFloat(routine.h), saturation: CGFloat(routine.s), brightness: CGFloat(routine.b), alpha: CGFloat(routine.a)), name: routine.name, partNum: 0)
                    categoryArray.append(timeBetweenTemp)
                    
                    let timeBetweenTempTwo = timeBetween(timeSinceBeginning: 86400, color: UIColor(hue: CGFloat(routine.h), saturation: CGFloat(routine.s), brightness: CGFloat(routine.b), alpha: CGFloat(routine.a)), name: routine.name, partNum: 1)
                    categoryArray.append(timeBetweenTempTwo)
                }
                
            }
        }
        
        var sortedArray = categoryArray
        
        sortedArray.sort {
            if $0.timeSinceBeginning != $1.timeSinceBeginning{
                return $0.timeSinceBeginning < $1.timeSinceBeginning
            }
            else {
                return $0.partNum > $1.partNum
            }
        }
        
        print(sortedArray, "SortedArray")
        var timelineArray: [Double] = []
        var colorArray: [UIColor] = []
        
        var previousTimeSinceBeginning: Double = 0
        for num in 0..<sortedArray.count/2{
            
            ///append no color for times between

            let inBetweenTime = (sortedArray[num * 2].timeSinceBeginning - previousTimeSinceBeginning)/60
            
            if inBetweenTime != 0{
                timelineArray.append(inBetweenTime)
                colorArray.append(UIColor.clear)
                nameArray.append("")
            }
            
            timelineArray.append((sortedArray[num * 2 + 1].timeSinceBeginning - sortedArray[num * 2].timeSinceBeginning)/60)
            colorArray.append(sortedArray[num * 2].color)
            nameArray.append(sortedArray[num * 2].name)
            
            previousTimeSinceBeginning = sortedArray[num * 2 + 1].timeSinceBeginning
        }
        
        //if time not stopped at the end of the day - add them manually
        if sortedArray.count > 0{
            if sortedArray.last!.timeSinceBeginning != 86400{
                timelineArray.append(1440 - sortedArray.last!.timeSinceBeginning/60)
                colorArray.append(UIColor.clear)
                nameArray.append("")
            }
        }
            
        //if array is empty: return nothing pretty much
        if sortedArray.count == 0{
            timelineArray = [0]
            colorArray = [.clear]
        }
        
        //update data
        let dataSet = [BarChartDataEntry(x: barChartNum, yValues: timelineArray)]
        let set = BarChartDataSet(entries: dataSet)
        set.valueFont = UIFont(name: "Futura", size: fontValue)!
        set.valueTextColor = .black
        set.colors = colorArray
        var valueFormatCustom = ValueNameFormat()
        valueFormatCustom.timelineArray = timelineArray
        valueFormatCustom.nameString = nameArray
        set.valueFormatter = valueFormatCustom
        
        barChartSetArray.append(set)
    }
    
    
    @IBAction func dayButtonPressed(_ sender: Any?) {
        chosenDateType = .day

        //prevent duplicate haptic feedback
        if alreadyHapticFeedback == true{
            alreadyHapticFeedback = false
        }
        else{
            //haptic feedback
            let selectionGenerator = UISelectionFeedbackGenerator()
            selectionGenerator.selectionChanged()
        }
        
        //reset bar chart array and x-axis name
        nameXAxisArray = []
        barChartSetArray = []
        
        //animation
        UIView.animate(withDuration: 0.3, animations: {
            self.dayButton.backgroundColor = UIColor(hex: "E98074")
            self.weekButton.backgroundColor = UIColor(hex: "EEA097")
            self.monthButton.backgroundColor = UIColor(hex: "EEA097")
        })
        
        //name arrays - for displaying name
        nameArray = []
        dayArray = []
        
        //set up timeline
        chartDay(day: dateDay, month: dateMonth + 1, year: dateYear, barChartNum: 0)
        dayArray.append(nameArray)
        print(dayArray)
        //set data of bar chart
        let data = BarChartData(dataSets: barChartSetArray)
        
        data.setDrawValues(true)
        barChart.data = data
        
        //disable x-scaling
        barChart.scaleXEnabled = false
        
        //set bar chart x axis name
        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: nameXAxisArray)
    }
    
    
    @IBAction func weekButtonPressed(_ sender: Any?) {
        chosenDateType = .week
        
        //prevent duplicate haptic feedback
        if alreadyHapticFeedback == true{
            alreadyHapticFeedback = false
        }
        else{
            //haptic feedback
            let selectionGenerator = UISelectionFeedbackGenerator()
            selectionGenerator.selectionChanged()
        }
        
        //reset bar chart array
        barChartSetArray = []
        nameXAxisArray = []
        
        //animation
        UIView.animate(withDuration: 0.3, animations: {
            self.dayButton.backgroundColor = UIColor(hex: "EEA097")
            self.weekButton.backgroundColor = UIColor(hex: "E98074")
            self.monthButton.backgroundColor = UIColor(hex: "EEA097")
        })
        
        //name arrays - for displaying name
        dayArray = []
        
        //get beginning of day + next day
        var startOfTheWeekComponents = DateComponents()
        startOfTheWeekComponents.day = dateDay
        startOfTheWeekComponents.month = dateMonth + 1
        startOfTheWeekComponents.year = dateYear
        startOfTheWeekComponents.hour = 0
        startOfTheWeekComponents.minute = 0
        startOfTheWeekComponents.second = 0
        
        let dateFromStartOfTheWeek = Calendar.current.date(from: startOfTheWeekComponents)!
        
        let startOfTheWeek = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: dateFromStartOfTheWeek))!
        
        let dateComponentsFromStartOfTheWeek = Calendar.current.dateComponents([.day,.month,.year], from: startOfTheWeek)
        
        let weekStartDay = dateComponentsFromStartOfTheWeek.day ?? 0
        let weekStartMonth = dateComponentsFromStartOfTheWeek.month ?? 0
        let weekStartYear = dateComponentsFromStartOfTheWeek.year ?? 0
        
        for num in 0...6{
            nameArray = []
            //set up timeline
            chartDay(day: weekStartDay + num, month: weekStartMonth, year: weekStartYear, barChartNum: Double(num))
            dayArray.append(nameArray)
        }
        
        //set data of bar chart
        let data = BarChartData(dataSets: barChartSetArray)
        
        data.setDrawValues(true)
        barChart.data = data
        
        //enable x-scaling
        barChart.scaleXEnabled = true
        
        //set bar chart x axis name
        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: nameXAxisArray)
    }
    
    
    @IBAction func monthButtonPressed(_ sender: Any?) {
        chosenDateType = .month
        
        //prevent duplicate haptic feedback
        if alreadyHapticFeedback == true{
            alreadyHapticFeedback = false
        }
        else{
            //haptic feedback
            let selectionGenerator = UISelectionFeedbackGenerator()
            selectionGenerator.selectionChanged()
        }
        
        //reset bar chart array
        barChartSetArray = []
        nameXAxisArray = []
        
        //animation
        UIView.animate(withDuration: 0.3, animations: {
            self.dayButton.backgroundColor = UIColor(hex: "EEA097")
            self.weekButton.backgroundColor = UIColor(hex: "EEA097")
            self.monthButton.backgroundColor = UIColor(hex: "E98074")
        })
        
        //name arrays - for displaying name
        dayArray = []
        
        //get beginning of day + next day
        var startOfTheMonthComponents = DateComponents()
        startOfTheMonthComponents.month = dateMonth + 1
        startOfTheMonthComponents.year = dateYear
        startOfTheMonthComponents.hour = 0
        startOfTheMonthComponents.minute = 0
        startOfTheMonthComponents.second = 0
        
        let dateFromStartOfTheMonth = Calendar.current.date(from: startOfTheMonthComponents)!
        
        let dayComponentMonth = Calendar.current.dateComponents([.day,.month, .year], from: dateFromStartOfTheMonth)
        
        let monthStartDay = dayComponentMonth.day ?? 0
        let monthStartMonth = dayComponentMonth.month ?? 0
        let monthStartYear = dayComponentMonth.year ?? 0
        
        let range = Calendar.current.range(of: .day, in: .month, for: dateFromStartOfTheMonth)!
        
        let numOfMonth = range.count
        
        for num in 0..<numOfMonth{
            nameArray = []
            //set up timeline
            chartDay(day: monthStartDay + num, month: monthStartMonth, year: monthStartYear, barChartNum: Double(num))
            dayArray.append(nameArray)
        }
            
        //set data of bar chart
        let data = BarChartData(dataSets: barChartSetArray)
        
        data.setDrawValues(true)
        barChart.data = data
        
        //enable x-scaling
        barChart.scaleXEnabled = true
        
        //set bar chart x axis name
        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: nameXAxisArray)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            touchLocation = touch.location(in: self.view)
            
            if tapLabel.isHidden == false{
                tapLabel.isHidden = true
            }
        }
    }
}

extension Timeline: ChartViewDelegate{
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
        chartView.highlightValue(nil)
        
        //if not empty
        if highlight.stackIndex >= 0{
            
            //if an actual category/routine
            if dayArray[highlight.dataSetIndex][highlight.stackIndex] != ""{
                //enable tapLabel
                tapLabel.isHidden = false
                
                tapLabel.text = dayArray[highlight.dataSetIndex][highlight.stackIndex]
                
                //frameSize fit with 5 pixel margins
                tapLabel.frame.size = CGSize(width: screenWidth/2, height: 21)
                tapLabel.sizeToFit()
                tapLabel.frame.size = CGSize(width: tapLabel.frame.size.width + 10, height: tapLabel.frame.size.height + 10)
                
                //reposition tapLabel
                tapLabel.frame.origin = CGPoint(x: touchLocation.x - tapLabel.frame.size.width/2, y: touchLocation.y - tapLabel.frame.size.height)
            }
        }
    }
}

//if date is between two other dates
extension Date {
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }
}

//draw values
extension Timeline: showValue{
    func showValue(yVal: CGFloat, xVal: CGFloat, width: CGFloat, prevValue: CGFloat, stringValue: String) {
        
        //break if none is displayed
        if (yVal < 0 && prevValue < 0) || (yVal > barChart.frame.size.height && prevValue > barChart.frame.size.height){
            return
        }
        var yVal = yVal
        
        var leftBounds = xVal
        var rightBounds = xVal + width
        
        //return if xAxis is obscured
        if (leftBounds < barChart.leftAxis.minWidth && rightBounds < barChart.leftAxis.minWidth) || (leftBounds > barChart.frame.size.width && rightBounds > barChart.frame.size.width){
            return
        }
        
        //change leftbounds
        if leftBounds < barChart.leftAxis.minWidth{
            leftBounds = barChart.leftAxis.minWidth
        }
        if rightBounds > barChart.frame.size.width - chartOffset{
            rightBounds = barChart.frame.size.width - chartOffset
        }
        
        //return if labelwidth < accepted labelHeight
        
        if rightBounds - leftBounds - 2 * showLabelBuffer < labelSizeBuffer{
            return
        }
        
        //set yVal to 0
        if yVal < topChart{
            yVal = topChart
        }
        
        //text view
        var textRect = CGRect(
            x: leftBounds + showLabelBuffer,
            y: yVal + showLabelBuffer,
            width: rightBounds - leftBounds - 2 * showLabelBuffer,
            height: 600
        )
        
        //height value calculation - whether to show it or not
        valueSizeHeightCalculationLbel.text = stringValue
        valueSizeHeightCalculationLbel.font = valueSizeHeightCalculationLbel.font.withSize(fontValue)
        
        valueSizeHeightCalculationLbel.frame = textRect
        
        valueSizeHeightCalculationLbel.sizeToFit()
        
        textRect = CGRect(
        x: leftBounds + showLabelBuffer,
        y: yVal + showLabelBuffer,
        width: rightBounds - leftBounds - 2 * showLabelBuffer,
        height: valueSizeHeightCalculationLbel.frame.size.height)
        
        var prevValue = prevValue
        
        if prevValue >= barChart.frame.size.height - chartOffset{
            prevValue = barChart.frame.size.height - chartOffset
        }
        
        //to show or not to show
        if prevValue - yVal < textRect.height + 2 * showLabelBuffer{
            return
        }
        
        //center text
        textRect = CGRect(
        x: leftBounds + showLabelBuffer, y: (prevValue + yVal - valueSizeHeightCalculationLbel.frame.size.height)/2, width: rightBounds - leftBounds - 2 * showLabelBuffer, height: valueSizeHeightCalculationLbel.frame.size.height)
        
        //draw text
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineBreakMode = .byWordWrapping

        let textAttributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: UIFont(name: "Futura", size: fontValue)!,
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]

        let attributedText = NSAttributedString(
            string: stringValue,
            attributes: textAttributes
        )

        attributedText.draw(in: textRect)
    }
}
