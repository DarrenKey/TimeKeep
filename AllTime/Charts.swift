//
//  Charts.swift
//  TimeKeep
//
//  Created by Mi Yan on 5/13/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//
import UIKit
import RealmSwift
import Charts

struct barChartData{
    var name: String
    var color: UIColor
    var timeSpent: Double
}

class Charts: UIViewController {
    
    @IBOutlet weak var dateLabel: UIButton!
    
    // which date type
    enum dateType{
        case day
        case week
        case month
    }
    
    var dateTypeChosen = dateType.day
    
    @IBOutlet weak var chartLabel: UILabel!
    
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var dayButton: UIButton!
    @IBOutlet weak var weekPressed: UIButton!
    @IBOutlet weak var monthPressed: UIButton!
    
    @IBOutlet weak var barChart: BarChartView!
    @IBOutlet weak var pieChart: PieChartView!
    
    @IBOutlet weak var barChartButton: UIButton!
    @IBOutlet weak var pieChartButton: UIButton!
    
    //delegate to tell mainview to bring down calendar
    var delegate: toMainView?
    
    //date chart displays
    var dateDay: Int = 0
    var dateWeek: Int = 0
    var dateMonth: Int = 0
    var dateYear: Int = 0
    
    //which chart type
    enum chartType{
        case pie
        case bar
    }
    
    var chartTypeSelected = chartType.bar
    
    //array to entery data for bar chart
    var dataEntries: [BarChartDataEntry] = []
    
    // pie chart data entries
    var pieChartEntries: [PieChartDataEntry] = []
    
    //bar chart data array
    var barChartDataArray: [barChartData] = []
    
    //category name array
    var categoryNames: [String] = []
    
    //color array
    var colorArray: [UIColor] = []
    
    //pie chart color array
    var pieChartColorArray: [UIColor] = []
    
    //beginning of chosen date && end of chosen date
    var beginningDate: Date = Date()
    var endDate: Date = Date()
    
    //get name of month array
    var monthArray: [String] = ["January","February","March","April","May","June","July",
    "August","September","October","November","December"]
    
    //screen height and width
    var screenHeight: CGFloat = 0
    var screenWidth: CGFloat = 0
    
    //stop duplicate haptic press
    var alreadyHapticFeedback = false
    
    //button to add custom event
    @IBOutlet weak var addCustomEventButton: UIButton!
    
    //font size
    var fontSize: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screen = UIScreen.main.bounds
        screenWidth = screen.size.width
        screenHeight = screen.size.height
        
        resizeDevice()
        
        //day is selected
        dayButton.backgroundColor = UIColor(hex: "E98074")
        
        //bar chart is selected
        barChartButton.tintColor = UIColor(hex: "E85A4F")
    
        //bar chart setup
        barChart.rightAxis.enabled = false
        barChart.xAxis.labelPosition = .bottom
        barChart.leftAxis.axisMinimum = 0
        barChart.xAxis.drawGridLinesEnabled = false
        barChart.leftAxis.gridColor = .black
        barChart.leftAxis.axisLineColor = .black
        barChart.xAxis.axisLineColor = .black
        barChart.backgroundColor = .white
        barChart.gridBackgroundColor = .white
        barChart.xAxis.labelFont = UIFont(name: "Futura", size: fontSize)!
        barChart.xAxis.labelTextColor = UIColor(hex: "E85A4F")
        barChart.leftAxis.labelFont = UIFont(name: "Futura", size: fontSize)!
        barChart.leftAxis.labelTextColor = UIColor(hex: "E85A4F")
        barChart.legend.enabled = false
        
        
        //disable pie chart on startup
        barChart.isHidden = false
        pieChart.isHidden = true
        
        barChartSetup()
        
    }
    
    //reszie
    func resizeDevice(){
        if screenWidth == 375 && screenHeight == 812{
            chartLabel.font = chartLabel.font.withSize(35)
            chartLabel.frame = CGRect(x: 24, y: 77, width: 135, height: 46)
            
            dateLabel.titleLabel?.font = dateLabel.titleLabel?.font.withSize(15)
            dateLabel.frame = CGRect(x: 0, y: 156, width: 375, height: 35)
            
            typeView.frame = CGRect(x: 0, y: 191, width: 375, height: 38)
            dayButton.frame = CGRect(x: 24, y: 8, width: 107, height: 22)
            weekPressed.frame = CGRect(x: 134, y: 8, width: 107, height: 22)
            monthPressed.frame = CGRect(x: 244, y: 8, width: 107, height: 22)
            
            pieChart.frame = CGRect(x: 0, y: 229, width: 375, height: 434)
            barChart.frame = pieChart.frame
            
            barChartButton.frame = CGRect(x: 24, y: 672, width: 40, height: 40)
            pieChartButton.frame = CGRect(x: 74, y: 672, width: 40, height: 40)
        }
        else if screenWidth == 414 && screenHeight == 736{
            chartLabel.frame = CGRect(x: 24, y: 50, width: 155, height: 52)
            
            dateLabel.frame = CGRect(x: 0, y: 132, width: 414, height: 42)
            typeView.frame = CGRect(x: 0, y: 174, width: 414, height: 42)
            
            barChart.frame = CGRect(x: 0, y: 216, width: 414, height: 385)
            pieChart.frame = CGRect(x: 0, y: 216, width: 414, height: 385)
            
            barChartButton.frame = CGRect(x: 24, y: 611, width: 45, height: 45)
            
            pieChartButton.frame = CGRect(x: 79, y: 611, width: 45, height: 45)
        }
        else if screenWidth == 375 && screenHeight == 667{
            chartLabel.font = chartLabel.font.withSize(35)
            chartLabel.frame = CGRect(x: 24, y: 50, width: 135, height: 46)
            
            dateLabel.titleLabel?.font = dateLabel.titleLabel?.font.withSize(15)
            dateLabel.frame = CGRect(x: 0, y: 126, width: 375, height: 35)
            
            typeView.frame = CGRect(x: 0, y: 161, width: 375, height: 38)
            dayButton.frame = CGRect(x: 24, y: 8, width: 107, height: 22)
            weekPressed.frame = CGRect(x: 134, y: 8, width: 107, height: 22)
            monthPressed.frame = CGRect(x: 244, y: 8, width: 107, height: 22)
            
            pieChart.frame = CGRect(x: 0, y: 199, width: 375, height: 357)
            barChart.frame = pieChart.frame
            
            barChartButton.frame = CGRect(x: 24, y: 561, width: 40, height: 40)
            pieChartButton.frame = CGRect(x: 74, y: 561, width: 40, height: 40)
            
            fontSize = 15
        }
        else if screenWidth == 320 && screenHeight == 568{
            chartLabel.font = chartLabel.font.withSize(30)
            chartLabel.frame = CGRect(x: 24, y: 40, width: 116, height: 39)
            
            dateLabel.titleLabel?.font = dateLabel.titleLabel?.font.withSize(15)
            dateLabel.frame = CGRect(x: 0, y: 99, width: 320, height: 30)
            
            typeView.frame = CGRect(x: 0, y: 129, width: 320, height: 30)
            dayButton.frame = CGRect(x: 24, y: 4, width: 88, height: 22)
            weekPressed.frame = CGRect(x: 116, y: 4, width: 88, height: 22)
            monthPressed.frame = CGRect(x: 208, y: 4, width: 88, height: 22)
            
            pieChart.frame = CGRect(x: 0, y: 159, width: 320, height: 303)
            barChart.frame = pieChart.frame
            
            barChartButton.frame = CGRect(x: 24, y: 467, width: 35, height: 35)
            pieChartButton.frame = CGRect(x: 69, y: 467, width: 35, height: 35)
            
            fontSize = 12
        }
        else if screenWidth == 768 && screenHeight == 1024{
            chartLabel.font = chartLabel.font.withSize(50)
            chartLabel.frame = CGRect(x: 24, y: 60, width: 193, height: 65)
            
            dateLabel.titleLabel?.font = dateLabel.titleLabel?.font.withSize(30)
            dateLabel.frame = CGRect(x: 0, y: 165, width: 768, height: 55)
            
            typeView.frame = CGRect(x: 0, y: 220, width: 768, height: 65)
            
            dayButton.titleLabel?.font = dayButton.titleLabel?.font.withSize(25)
            weekPressed.titleLabel?.font = weekPressed.titleLabel?.font.withSize(25)
            monthPressed.titleLabel?.font = monthPressed.titleLabel?.font.withSize(25)
            
            dayButton.frame = CGRect(x: 24, y: 10, width: 230, height: 45)
            weekPressed.frame = CGRect(x: 269, y: 10, width: 230, height: 45)
            monthPressed.frame = CGRect(x: 514, y: 10, width: 230, height: 45)
            
            pieChart.frame = CGRect(x: 0, y: 285, width: 768, height: 549)
            barChart.frame = pieChart.frame
            
            barChartButton.contentVerticalAlignment = .fill
            barChartButton.contentHorizontalAlignment = .fill
            
            pieChartButton.contentVerticalAlignment = .fill
            pieChartButton.contentHorizontalAlignment = .fill
            
            barChartButton.frame = CGRect(x: 24, y: 845, width: 70, height: 70)
            pieChartButton.frame = CGRect(x: 114, y: 845, width: 70, height: 70)
            
            fontSize = 25
        }
        else if screenWidth == 834 && screenHeight == 1194{
            chartLabel.font = chartLabel.font.withSize(65)
            chartLabel.frame = CGRect(x: 24, y: 50, width: 251, height: 85)
            
            dateLabel.titleLabel?.font = dateLabel.titleLabel?.font.withSize(35)
            dateLabel.frame = CGRect(x: 0, y: 165, width: 834, height: 70)
            
            typeView.frame = CGRect(x: 0, y: 235, width: 834, height: 70)
            
            dayButton.titleLabel?.font = dayButton.titleLabel?.font.withSize(30)
            weekPressed.titleLabel?.font = weekPressed.titleLabel?.font.withSize(30)
            monthPressed.titleLabel?.font = monthPressed.titleLabel?.font.withSize(30)
            
            dayButton.frame = CGRect(x: 24, y: 10, width: 254, height: 50)
            weekPressed.frame = CGRect(x: 290, y: 10, width: 254, height: 50)
            monthPressed.frame = CGRect(x: 556, y: 10, width: 254, height: 50)
            
            pieChart.frame = CGRect(x: 0, y: 305, width: 834, height: 654)
            barChart.frame = pieChart.frame
            
            barChartButton.contentVerticalAlignment = .fill
            barChartButton.contentHorizontalAlignment = .fill
            
            pieChartButton.contentVerticalAlignment = .fill
            pieChartButton.contentHorizontalAlignment = .fill
            
            barChartButton.frame = CGRect(x: 24, y: 974, width: 75, height: 75)
            pieChartButton.frame = CGRect(x: 119, y: 974, width: 75, height: 75)
            
            fontSize = 25
        }
        else if screenWidth == 834 && screenHeight == 1112{
            chartLabel.font = chartLabel.font.withSize(65)
            chartLabel.frame = CGRect(x: 24, y: 50, width: 251, height: 85)
            
            dateLabel.titleLabel?.font = dateLabel.titleLabel?.font.withSize(30)
            dateLabel.frame = CGRect(x: 0, y: 165, width: 834, height: 60)
            
            typeView.frame = CGRect(x: 0, y: 225, width: 834, height: 60)
            
            dayButton.titleLabel?.font = dayButton.titleLabel?.font.withSize(25)
            weekPressed.titleLabel?.font = weekPressed.titleLabel?.font.withSize(25)
            monthPressed.titleLabel?.font = monthPressed.titleLabel?.font.withSize(25)
            
            dayButton.frame = CGRect(x: 24, y: 10, width: 254, height: 40)
            weekPressed.frame = CGRect(x: 290, y: 10, width: 254, height: 40)
            monthPressed.frame = CGRect(x: 556, y: 10, width: 254, height: 40)
            
            pieChart.frame = CGRect(x: 0, y: 285, width: 834, height: 617)
            barChart.frame = pieChart.frame
            
            barChartButton.contentVerticalAlignment = .fill
            barChartButton.contentHorizontalAlignment = .fill
            
            pieChartButton.contentVerticalAlignment = .fill
            pieChartButton.contentHorizontalAlignment = .fill
            
            barChartButton.frame = CGRect(x: 24, y: 917, width: 70, height: 70)
            pieChartButton.frame = CGRect(x: 114, y: 917, width: 70, height: 70)

            fontSize = 25
        }
        else if screenWidth == 810 && screenHeight == 1080{
            chartLabel.font = chartLabel.font.withSize(65)
            chartLabel.frame = CGRect(x: 24, y: 50, width: 251, height: 85)
            
            dateLabel.titleLabel?.font = dateLabel.titleLabel?.font.withSize(30)
            dateLabel.frame = CGRect(x: 0, y: 165, width: 810, height: 60)
            
            typeView.frame = CGRect(x: 0, y: 225, width: 810, height: 60)
            
            dayButton.titleLabel?.font = dayButton.titleLabel?.font.withSize(25)
            weekPressed.titleLabel?.font = weekPressed.titleLabel?.font.withSize(25)
            monthPressed.titleLabel?.font = monthPressed.titleLabel?.font.withSize(25)
            
            dayButton.frame = CGRect(x: 24, y: 10, width: 246, height: 40)
            weekPressed.frame = CGRect(x: 282, y: 10, width: 246, height: 40)
            monthPressed.frame = CGRect(x: 540, y: 10, width: 246, height: 40)
            
            pieChart.frame = CGRect(x: 0, y: 285, width: 810, height: 585)
            barChart.frame = pieChart.frame
            
            barChartButton.contentVerticalAlignment = .fill
            barChartButton.contentHorizontalAlignment = .fill
            
            pieChartButton.contentVerticalAlignment = .fill
            pieChartButton.contentHorizontalAlignment = .fill
            
            barChartButton.frame = CGRect(x: 24, y: 885, width: 70, height: 70)
            pieChartButton.frame = CGRect(x: 114, y: 885, width: 70, height: 70)
            
            fontSize = 25
        }
        else if screenWidth == 1024 && screenHeight == 1366{
            chartLabel.font = chartLabel.font.withSize(75)
            chartLabel.frame = CGRect(x: 24, y: 60, width: 290, height: 98)
            
            dateLabel.titleLabel?.font = dateLabel.titleLabel?.font.withSize(50)
            dateLabel.frame = CGRect(x: 0, y: 210, width: 1024, height: 90)
            
            typeView.frame = CGRect(x: 0, y: 298, width: 1024, height: 86)
            
            dayButton.titleLabel?.font = dayButton.titleLabel?.font.withSize(40)
            weekPressed.titleLabel?.font = weekPressed.titleLabel?.font.withSize(40)
            monthPressed.titleLabel?.font = monthPressed.titleLabel?.font.withSize(40)
            
            dayButton.frame = CGRect(x: 24, y: 11, width: 316, height: 64)
            weekPressed.frame = CGRect(x: 356, y: 11, width: 316, height: 64)
            monthPressed.frame = CGRect(x: 684, y: 11, width: 316, height: 64)
            
            pieChart.frame = CGRect(x: 0, y: 386, width: 1024, height: 710)
            barChart.frame = pieChart.frame
            
            barChartButton.contentVerticalAlignment = .fill
            barChartButton.contentHorizontalAlignment = .fill
            
            pieChartButton.contentVerticalAlignment = .fill
            pieChartButton.contentHorizontalAlignment = .fill
            
            barChartButton.frame = CGRect(x: 24, y: 1111, width: 100, height: 100)
            pieChartButton.frame = CGRect(x: 154, y: 1111, width: 100, height: 100)
            
            fontSize = 25
        }
        
        ///add custom event button resize
        addCustomEventButton.frame = CGRect(x: screenWidth - 24 - chartLabel.frame.size.height, y: chartLabel.frame.origin.y, width: chartLabel.frame.size.height, height: chartLabel.frame.size.height)
    }
    
    //restart barChart
    override func viewWillAppear(_ animated: Bool) {
        //change date label to current date
        let components = Calendar.current.dateComponents([.day,.weekOfMonth, .month,.year], from: Date())
        
        dateYear = components.year!
        dateWeek = components.weekOfMonth!
        dateMonth = components.month! - 1
        dateDay = components.day!
        
        dateLabel.setTitle("\(monthArray[dateMonth]) \(dateDay), \(dateYear)", for: .normal)
        
        switch chartTypeSelected{
        case .bar:
            barChartSetup()
            
        case .pie:
            pieChartSetup()
        }
    }
    
    ///unwind segue
    @IBAction func unwindFromCustomEvent(segue: UIStoryboardSegue) {
    }
    
    ///send data to custom event
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromCharts"{
            let customEvent = segue.destination as! CustomEvent
            
            customEvent.actualVCFrom = .charts
        }
    }
    
    //selected pie chart
    func pieChartSetup(){
        
        //standard realm setup
        let realm = try! Realm()
        let selectedCategoryRealm = realm.objects(Category.self)
        let selectedRoutineRealm = realm.objects(Routine.self)

        //reset arrays
        pieChartEntries = []
        pieChartColorArray = []
        
        //which date tpye
        switch dateTypeChosen{
        case .day:

            //get beginning of day + next day
            var startOfTheDayComponents = DateComponents()
            startOfTheDayComponents.month = dateMonth + 1
            startOfTheDayComponents.day = dateDay
            startOfTheDayComponents.year = dateYear
            startOfTheDayComponents.hour = 0
            startOfTheDayComponents.minute = 0
            startOfTheDayComponents.second = 0
            
            beginningDate = Calendar.current.date(from: startOfTheDayComponents)!
            
            var oneDay = DateComponents()
            oneDay.day = 1
            
            endDate = Calendar.current.date(byAdding: oneDay, to: beginningDate)!
        case .week:

            //get beginning of day + next day
            var startOfTheDayComponents = DateComponents()
            startOfTheDayComponents.month = dateMonth + 1
            startOfTheDayComponents.weekday = 1
            startOfTheDayComponents.weekOfMonth = dateWeek
            startOfTheDayComponents.year = dateYear
            startOfTheDayComponents.hour = 0
            startOfTheDayComponents.minute = 0
            startOfTheDayComponents.second = 0
            
            beginningDate = Calendar.current.date(from: startOfTheDayComponents)!
            var oneWeek = DateComponents()
            oneWeek.weekOfMonth = 1
            
            endDate = Calendar.current.date(byAdding: oneWeek, to: beginningDate)!
        
        case .month:
            
            //get beginning of day + next day
            var startOfTheDayComponents = DateComponents()
            startOfTheDayComponents.day = 1
            startOfTheDayComponents.month = dateMonth + 1
            startOfTheDayComponents.year = dateYear
            startOfTheDayComponents.hour = 0
            startOfTheDayComponents.minute = 0
            startOfTheDayComponents.second = 0
            
            beginningDate = Calendar.current.date(from: startOfTheDayComponents)!
            
            var oneMonth = DateComponents()
            oneMonth.month = 1
            
            endDate = Calendar.current.date(byAdding: oneMonth, to: beginningDate)!
        }
        
        //for each category
        for num in 0..<selectedCategoryRealm.count{
            
            var totalTime: Double = 0
            
            let category = selectedCategoryRealm[num]
            
            //for each stored date in the category
            for categoryDate in 0..<(category.time.count/2){
                
                //if both times in between date
                if category.time[categoryDate * 2].isBetween(beginningDate, and: endDate) && category.time[categoryDate * 2 + 1].isBetween(beginningDate, and: endDate){
                    totalTime += category.time[categoryDate * 2 + 1].timeIntervalSince(category.time[categoryDate * 2])
                }
                
                //if first time before date
                else if category.time[categoryDate * 2 + 1].isBetween(beginningDate, and: endDate){
                    totalTime += category.time[categoryDate * 2 + 1].timeIntervalSince(beginningDate)
               }
                
                //if second time after date
                else if  category.time[categoryDate * 2].isBetween(beginningDate, and: endDate){
                    totalTime += endDate.timeIntervalSince(category.time[categoryDate * 2])
               }
            }
            
            //if category has a time not ended - create another one with current date
            if category.time.count % 2 == 1{
                 //if both times in between date
                if category.time.last!.isBetween(beginningDate, and: endDate) && Date().isBetween(beginningDate, and: endDate){
                    totalTime += Date().timeIntervalSince(category.time.last!)
                 }
                 
                 //if first time before date
                 else if Date().isBetween(beginningDate, and: endDate){
                     totalTime += Date().timeIntervalSince(beginningDate)
                }
                 
                 //if second time after date
                else if  category.time.last!.isBetween(beginningDate, and: endDate){
                    totalTime += endDate.timeIntervalSince(category.time.last!)
                }
            }
            
            //add data to sort
            let pieChartEntry = PieChartDataEntry(value: totalTime/3600, label: category.name)
            pieChartEntries.append(pieChartEntry)
            
            //add color to array
            pieChartColorArray.append(UIColor(hue: CGFloat(category.h), saturation: CGFloat(category.s), brightness: CGFloat(category.b), alpha: CGFloat(category.a)))
        }
        
        //for each routine
        for num in 0..<selectedRoutineRealm.count{
            
            var totalTime: Double = 0
            
            let routine = selectedRoutineRealm[num]
            
            //for each stored date in the routine
            for routineDate in 0..<(routine.time.count/2){
                
                //if both times in between date
                if routine.time[routineDate * 2].isBetween(beginningDate, and: endDate) && routine.time[routineDate * 2 + 1].isBetween(beginningDate, and: endDate){
                    totalTime += routine.time[routineDate * 2 + 1].timeIntervalSince(routine.time[routineDate * 2])
                }
                
                //if first time before date
                else if routine.time[routineDate * 2 + 1].isBetween(beginningDate, and: endDate){
                    totalTime += routine.time[routineDate * 2 + 1].timeIntervalSince(beginningDate)
               }
                
                //if second time after date
                else if  routine.time[routineDate * 2].isBetween(beginningDate, and: endDate){
                    totalTime += endDate.timeIntervalSince(routine.time[routineDate * 2])
               }
            }
            
            //if routine has a time not ended - create another one with current date
            if routine.time.count % 2 == 1{
                 //if both times in between date
                if routine.time.last!.isBetween(beginningDate, and: endDate) && Date().isBetween(beginningDate, and: endDate){
                    totalTime += Date().timeIntervalSince(routine.time.last!)
                 }
                 
                 //if first time before date
                 else if Date().isBetween(beginningDate, and: endDate){
                     totalTime += Date().timeIntervalSince(beginningDate)
                }
                 
                 //if second time after date
                else if  routine.time.last!.isBetween(beginningDate, and: endDate){
                    totalTime += endDate.timeIntervalSince(routine.time.last!)
                }
            }
            
            //add data to sort
            let pieChartEntry = PieChartDataEntry(value: totalTime/3600, label: routine.name)
            pieChartEntries.append(pieChartEntry)
            
            //add color to array
            pieChartColorArray.append(UIColor(hue: CGFloat(routine.h), saturation: CGFloat(routine.s), brightness: CGFloat(routine.b), alpha: CGFloat(routine.a)))
        }
        
        let pieChartDataSet = PieChartDataSet(entries: pieChartEntries, label: nil)
        pieChartDataSet.colors = pieChartColorArray
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChart.data = pieChartData
        
        //animate pieChart
        pieChart.animate(xAxisDuration: 0.5, yAxisDuration: 0.5, easingOption: .easeInOutCubic)
    }
    
    
    //selected bar chart
    func barChartSetup(){
        
        //standard realm setup
        let realm = try! Realm()
        let selectedCategoryRealm = realm.objects(Category.self)
        let selectedRoutineRealm = realm.objects(Routine.self)

        //reset arrays
        dataEntries = []
        barChartDataArray = []
        categoryNames = []
        colorArray = []
        
        if selectedCategoryRealm.count == 0 && selectedRoutineRealm.count == 0{
            return
        }
        
        //which date tpye
        switch dateTypeChosen{
        case .day:

            //get beginning of day + next day
            var startOfTheDayComponents = DateComponents()
            startOfTheDayComponents.month = dateMonth + 1
            startOfTheDayComponents.day = dateDay
            startOfTheDayComponents.year = dateYear
            startOfTheDayComponents.hour = 0
            startOfTheDayComponents.minute = 0
            startOfTheDayComponents.second = 0
            
            beginningDate = Calendar.current.date(from: startOfTheDayComponents)!
            
            print(beginningDate)
            
            var oneDay = DateComponents()
            oneDay.day = 1
            
            endDate = Calendar.current.date(byAdding: oneDay, to: beginningDate)!
        case .week:
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
            
            beginningDate = startOfTheWeek
            
            var oneWeek = DateComponents()
            oneWeek.weekOfMonth = 1
            
            endDate = Calendar.current.date(byAdding: oneWeek, to: beginningDate)!
        
        case .month:
            
            //get beginning of day + next day
            var startOfTheDayComponents = DateComponents()
            startOfTheDayComponents.day = 1
            startOfTheDayComponents.month = dateMonth + 1
            startOfTheDayComponents.year = dateYear
            startOfTheDayComponents.hour = 0
            startOfTheDayComponents.minute = 0
            startOfTheDayComponents.second = 0
            
            beginningDate = Calendar.current.date(from: startOfTheDayComponents)!
            
            var oneMonth = DateComponents()
            oneMonth.month = 1
            
            endDate = Calendar.current.date(byAdding: oneMonth, to: beginningDate)!
        }
        
        print(beginningDate, endDate)
        
        //for each category
        for num in 0..<selectedCategoryRealm.count{
            
            var totalTime: Double = 0
            
            let category = selectedCategoryRealm[num]
        
            print("category", category)
            
            //for each stored date in the category
            for categoryDate in 0..<category.time.count/2{
                
                //if both times in between date
                if category.time[categoryDate * 2].isBetween(beginningDate, and: endDate) && category.time[categoryDate * 2 + 1].isBetween(beginningDate, and: endDate){
                    totalTime += category.time[categoryDate * 2 + 1].timeIntervalSince(category.time[categoryDate * 2])
                }
                
                //if first time before date
                else if category.time[categoryDate * 2 + 1].isBetween(beginningDate, and: endDate){
                    totalTime += category.time[categoryDate * 2 + 1].timeIntervalSince(beginningDate)
               }
                
                //if second time after date
                else if  category.time[categoryDate * 2].isBetween(beginningDate, and: endDate){
                    totalTime += endDate.timeIntervalSince(category.time[categoryDate * 2])
               }
            }
            
            //if category has a time not ended - create another one with current date
            if category.time.count % 2 == 1{
                 //if both times in between date
                if category.time.last!.isBetween(beginningDate, and: endDate) && Date().isBetween(beginningDate, and: endDate){
                    totalTime += Date().timeIntervalSince(category.time.last!)
                 }
                 
                 //if first time before date
                 else if Date().isBetween(beginningDate, and: endDate){
                     totalTime += Date().timeIntervalSince(beginningDate)
                }
                 
                 //if second time after date
                else if  category.time.last!.isBetween(beginningDate, and: endDate){
                    totalTime += endDate.timeIntervalSince(category.time.last!)
                }
            }
            
            //add data to sort
            
            //color - changing it to opaque
            let barChartDataTemp = barChartData(name: category.name, color: UIColor(hue: CGFloat(category.h), saturation: CGFloat(category.s), brightness: CGFloat(category.b), alpha: CGFloat(category.a)), timeSpent: totalTime/3600)
            
            barChartDataArray.append(barChartDataTemp)
        }
        
        //for each routine
        for num in 0..<selectedRoutineRealm.count{
            
            var totalTime: Double = 0
            
            let routine = selectedRoutineRealm[num]
        
            //for each stored date in the routine
            for routineDate in 0..<routine.time.count/2{
                
                //if both times in between date
                if routine.time[routineDate * 2].isBetween(beginningDate, and: endDate) && routine.time[routineDate * 2 + 1].isBetween(beginningDate, and: endDate){
                    totalTime += routine.time[routineDate * 2 + 1].timeIntervalSince(routine.time[routineDate * 2])
                }
                
                //if first time before date
                else if routine.time[routineDate * 2 + 1].isBetween(beginningDate, and: endDate){
                    totalTime += routine.time[routineDate * 2 + 1].timeIntervalSince(beginningDate)
               }
                
                //if second time after date
                else if  routine.time[routineDate * 2].isBetween(beginningDate, and: endDate){
                    totalTime += endDate.timeIntervalSince(routine.time[routineDate * 2])
               }
            }
            
            //if routine has a time not ended - create another one with current date
            if routine.time.count % 2 == 1{
                 //if both times in between date
                if routine.time.last!.isBetween(beginningDate, and: endDate) && Date().isBetween(beginningDate, and: endDate){
                    totalTime += Date().timeIntervalSince(routine.time.last!)
                 }
                 
                 //if first time before date
                 else if Date().isBetween(beginningDate, and: endDate){
                     totalTime += Date().timeIntervalSince(beginningDate)
                }
                 
                 //if second time after date
                else if  routine.time.last!.isBetween(beginningDate, and: endDate){
                    totalTime += endDate.timeIntervalSince(routine.time.last!)
                }
            }
            
            //add data to sort
            
            //color - changing it to opaque
            let barChartDataTemp = barChartData(name: routine.name, color: UIColor(hue: CGFloat(routine.h), saturation: CGFloat(routine.s), brightness: CGFloat(routine.b), alpha: CGFloat(routine.a)), timeSpent: totalTime/3600)
            
            barChartDataArray.append(barChartDataTemp)
        }
        
        //sort by most time
        barChartDataArray = barChartDataArray.sorted(by: {$0.timeSpent > $1.timeSpent})
        
        for num in 0..<barChartDataArray.count{
            
            let data = barChartDataArray[num]
            
            //append name and color to array
            categoryNames.append(data.name)
            colorArray.append(data.color)
            
            //add data to data entry array
            let dataEntry = BarChartDataEntry(x: Double(num), y: data.timeSpent)
            dataEntries.append(dataEntry)
        }
        
        
        //setup data chart
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Time Spent")
        chartDataSet.colors = colorArray
        chartDataSet.valueFont = UIFont(name: "Futura", size: 15)!
        chartDataSet.valueTextColor = UIColor(hex: "E85A4F")
        
        
        let chartData = BarChartData(dataSet: chartDataSet)
        barChart.data = chartData
        
        //set x axis
        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: categoryNames)
        barChart.xAxis.granularity = 1
        barChart.setVisibleXRangeMaximum(5)
        
        //animate barChart
        barChart.animate(xAxisDuration: 0.5, yAxisDuration: 0.5, easingOption: .easeInOutCubic)
        
    }
    
    @IBAction func dayPressed(_ sender: Any?) {
        dateTypeChosen = .day

        
        if alreadyHapticFeedback == true{
            alreadyHapticFeedback = false
        }
        else{
            //haptic feedback
            let selectionGenerator = UISelectionFeedbackGenerator()
            selectionGenerator.selectionChanged()
        }
        
        //update whether bar or pie chart
        switch chartTypeSelected{
        case .bar:
            barChartSetup()
        case .pie:
            pieChartSetup()
        }
        
        //animation
        UIView.animate(withDuration: 0.3, animations: {

            self.dayButton.backgroundColor = UIColor(hex: "E98074")
            self.weekPressed.backgroundColor = UIColor(hex: "EEA097")
            self.monthPressed.backgroundColor = UIColor(hex: "EEA097")
            
        })
    }
    
    @IBAction func weekPressed(_ sender: Any?) {
        dateTypeChosen = .week

        if alreadyHapticFeedback == true{
            alreadyHapticFeedback = false
        }
        else{
            //haptic feedback
            let selectionGenerator = UISelectionFeedbackGenerator()
            selectionGenerator.selectionChanged()
        }
        
        //update whether bar or pie chart
        switch chartTypeSelected{
        case .bar:
            barChartSetup()
        case .pie:
            pieChartSetup()
        }
        
        //animation
        UIView.animate(withDuration: 0.3, animations: {

            self.dayButton.backgroundColor = UIColor(hex: "EEA097")
            self.weekPressed.backgroundColor = UIColor(hex: "E98074")
            self.monthPressed.backgroundColor = UIColor(hex: "EEA097")
            
        })
    }
    
    @IBAction func monthPressed(_ sender: Any?) {
        dateTypeChosen = .month
        
        if alreadyHapticFeedback == true{
            alreadyHapticFeedback = false
        }
        else{
            //haptic feedback
            let selectionGenerator = UISelectionFeedbackGenerator()
            selectionGenerator.selectionChanged()
        }
        
        //update whether bar or pie chart
        switch chartTypeSelected{
        case .bar:
            barChartSetup()
        case .pie:
            pieChartSetup()
        }
        
        //animation
        UIView.animate(withDuration: 0.3, animations: {

            self.dayButton.backgroundColor = UIColor(hex: "EEA097")
            self.weekPressed.backgroundColor = UIColor(hex: "EEA097")
            self.monthPressed.backgroundColor = UIColor(hex: "E98074")
            
        })
    }
    
    @IBAction func barChartPressed(_ sender: Any) {
        chartTypeSelected = .bar

        //haptic feedback
        let selectionGenerator = UISelectionFeedbackGenerator()
        selectionGenerator.selectionChanged()
        
        //enable bar chart and disable piechart
        barChart.isHidden = false
        pieChart.isHidden = true
        barChartSetup()
        
        //animation
        UIView.animate(withDuration: 0.3, animations: {
            
            self.barChartButton.tintColor = UIColor(hex: "E85A4F")
            self.pieChartButton.tintColor = UIColor.black
            
        })
    }
    
    
    @IBAction func pieChartPressed(_ sender: Any) {
        chartTypeSelected = .pie

        //haptic feedback
        let selectionGenerator = UISelectionFeedbackGenerator()
        selectionGenerator.selectionChanged()
        
        //enable bar chart and disable piechart
        barChart.isHidden = true
        pieChart.isHidden = false
        pieChartSetup()
        
        //animation
        UIView.animate(withDuration: 0.3, animations: {
            
            self.barChartButton.tintColor = UIColor.black
            self.pieChartButton.tintColor = UIColor(hex: "E85A4F")
            
        })
    }
    
    //change date button pressed
    @IBAction func bringCalendarButton(_ sender: Any) {
        delegate?.calendarDown(days: dateDay, months: 12 * (dateYear - 2020) + dateMonth)
    }
    
    //change date function
    func changeDate(day: Int, monthsSince: Int){
        dateDay = day
        dateMonth = monthsSince % 12
        dateYear = Int(monthsSince/12) + 2020
        
        //change label
        dateLabel.setTitle("\(monthArray[dateMonth]) \(dateDay), \(dateYear)", for: .normal)
        delegate?.calendarUp()
        
        //prevent duplicate vibrations
        alreadyHapticFeedback = true
        
        //change chart
        switch dateTypeChosen{
        case .day:
            dayPressed(nil)
            
        case .week:
            weekPressed(nil)
            
        case .month:
            monthPressed(nil)
        }
        
    }
}

