//
//  UpdatedStatisticsVC.swift
//  Calendar
//
//  Created by Mi Yan on 12/30/19.
//  Copyright © 2019 Darren Key. All rights reserved.
//
/*
 
 This application, and specifically this script, uses the library Charts (https://github.com/danielgindi/Charts). This library is available under the Apache 2.0 license, which can be obtained from http://www.apache.org/licenses/LICENSE-2.0.
 */

import UIKit
import Charts

class UpdatedStatisticsVC: UIViewController {
    @IBOutlet weak var endView: UIView!
    
    @IBOutlet weak var PM: UILabel!
    //pieChart
    @IBOutlet weak var pieChartT: PieChartView!
    
    @IBOutlet weak var amTimeline: UIView!
    
    @IBOutlet weak var pmTimeline: UIView!
    
    var frameHeight = Double(0)
    
    //var chartView: BarsChart!
    @IBOutlet weak var horizontalBC: HorizontalBarChartView!
    
    //date for the timeline
    @IBOutlet weak var currentDate: UIButton!
    var dateC = Date()
    
    @IBOutlet weak var addNewEvent: UIButton!
    
    //overview and attributes
    @IBOutlet weak var overviewButton: UIButton!
    @IBOutlet weak var descriptionButton: UIButton!
    
    @IBOutlet var constraintsHeight: [NSLayoutConstraint]!
    @IBOutlet var constraintsWidth: [NSLayoutConstraint]!
    
    @IBOutlet weak var houseB: UIButton!
    @IBOutlet weak var dayB: UIButton!
    @IBOutlet weak var weekB: UIButton!
    @IBOutlet weak var monthB: UIButton!
    @IBOutlet weak var allTimeB: UIButton!
    
    //what mode to put it on
    
    var mode = "Day"
    
    //attributes
    var filterMode = "Overview"
    
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var timeline: UILabel!
    @IBOutlet weak var AM: UILabel!
    var colorScheme = [NSUIColor]()
    var dataEntries: [BarChartDataEntry] = []
    
    var pieChartEntries: [PieChartDataEntry] = []
    
    @IBOutlet weak var pieChartB: UIButton!
    @IBOutlet weak var barChartB: UIButton!
    
    var pieChartSelected = false
    var barChartSelected = true
    
    var descriptionTimeData = [[Date]]()
    
    //need to reformat everything for the horizontal bar chart
    var categoriesFormat = [String]()
    var colorsFormat = [UIColor]()
    var totalTimeFormat = [Double]()
    
    //pie chart format
    var pieChartCategoriesFormat = [String]()
    var pieChartColorsFormat = [UIColor]()
    var pieChartTTF = [Double]()
    
    @IBAction func pieChartSelectedAction(_ sender: Any) {
        if barChartSelected == true && pieChartSelected == false{
            pieChartSelected = true
            barChartSelected = false
            
            barChartB.tintColor = UIColor(red: 134/255, green: 134/255, blue: 134/255, alpha: 1)
            pieChartB.tintColor = .white
            
            horizontalBC.isHidden = true
            pieChartT.isHidden = false
        }
    }
    
    @IBAction func barChartSelectedAction(_ sender: Any) {
        if barChartSelected == false && pieChartSelected == true{
            pieChartSelected = false
            barChartSelected = true
            
            barChartB.tintColor = .white
            pieChartB.tintColor = UIColor(red: 134/255, green: 134/255, blue: 134/255, alpha: 1)
            
            horizontalBC.isHidden = false
            pieChartT.isHidden = true
            
        }
    }
    
    func updatePieChart(){
        if filterMode == "Overview"{
            pieChartTTF = modeInfo(mode: mode, pieCorNot: true, timeData: Singleton.timeData)
            
            
            var placeHolderChart = [Double]()
            var placeHolderColorsFormat = [UIColor] ()
            var placeHolderCategoriesFormat = [String]()
            
            
            pieChartCategoriesFormat = Singleton.categories
            pieChartColorsFormat = Singleton.colorsC
            
            for i in 0..<Singleton.categories.count{
                if pieChartTTF[i] != 0{
                    placeHolderChart.append(pieChartTTF[i])
                    placeHolderColorsFormat.append(pieChartColorsFormat[i])
                    placeHolderCategoriesFormat.append(pieChartCategoriesFormat[i])
                    
                }
            }
            pieChartTTF = placeHolderChart
            pieChartColorsFormat = placeHolderColorsFormat
            pieChartCategoriesFormat = placeHolderCategoriesFormat
            pieChartEntries = []
        }
        else if filterMode == "Description"{
            
            
            if Singleton.attributesN.count != 0{
                pieChartTTF = modeInfo(mode: mode, pieCorNot: true, timeData: descriptionTimeData)
                
                var colorsDescriptions = [UIColor]()
                
                for i in 1...Singleton.attributesN.count{
                    colorsDescriptions.append(UIColor(hue: CGFloat(i) * 1/(CGFloat(Singleton.attributesN.count)), saturation: 1, brightness: 1, alpha: 1))
                }
                pieChartColorsFormat = colorsDescriptions
                pieChartCategoriesFormat = Singleton.attributesN
                
                var placeHolderChart = [Double]()
                var placeHolderColorsFormat = [UIColor] ()
                var placeHolderCategoriesFormat = [String]()

                for i in 0..<Singleton.attributesN.count{
                   if pieChartTTF[i] != 0{
                       placeHolderChart.append(pieChartTTF[i])
                       placeHolderColorsFormat.append(pieChartColorsFormat[i])
                       placeHolderCategoriesFormat.append(pieChartCategoriesFormat[i])
                       
                   }
                }
                pieChartTTF = placeHolderChart
                pieChartColorsFormat = placeHolderColorsFormat
                pieChartCategoriesFormat = placeHolderCategoriesFormat
                pieChartEntries = []
            }
        }
        
        
        for i in 0..<pieChartCategoriesFormat.count{
            pieChartEntries.append(PieChartDataEntry(value: pieChartTTF[i], label: pieChartCategoriesFormat[i]))
            
        }
        let dataSet = PieChartDataSet(entries: pieChartEntries, label: nil)
        let chartData = PieChartData(dataSet: dataSet)
        dataSet.colors = pieChartColorsFormat
        dataSet.valueTextColor = .white
        dataSet.valueFont = UIFont(name: "Segoe UI", size: 14)!
        
        pieChartT.data = chartData
        
        if filterMode == "Description" && Singleton.attributesN.count == 0{
            pieChartT.clear()
        }
    }
    
    //if button pressed on top
    
    @IBAction func dayPressed(_ sender: Any) {
        dayB.setTitleColor(.white, for: .normal)
        weekB.setTitleColor(UIColor(red: 134/255, green: 134/255, blue: 134/255, alpha: 1), for: .normal)
        monthB.setTitleColor(UIColor(red: 134/255, green: 134/255, blue: 134/255, alpha: 1), for: .normal)
        allTimeB.setTitleColor(UIColor(red: 134/255, green: 134/255, blue: 134/255, alpha: 1), for: .normal)
        
        mode = "Day"
        updateAllCharts()
    }
    @IBAction func weekPressed(_ sender: Any) {
        dayB.setTitleColor(UIColor(red: 134/255, green: 134/255, blue: 134/255, alpha: 1), for: .normal)
        weekB.setTitleColor(.white, for: .normal)
        monthB.setTitleColor(UIColor(red: 134/255, green: 134/255, blue: 134/255, alpha: 1), for: .normal)
        allTimeB.setTitleColor(UIColor(red: 134/255, green: 134/255, blue: 134/255, alpha: 1), for: .normal)
        
        mode = "Week"
        updateAllCharts()
        
        
    }
    @IBAction func monthPressed(_ sender: Any) {
        dayB.setTitleColor(UIColor(red: 134/255, green: 134/255, blue: 134/255, alpha: 1), for: .normal)
        weekB.setTitleColor(UIColor(red: 134/255, green: 134/255, blue: 134/255, alpha: 1), for: .normal)
        monthB.setTitleColor(.white, for: .normal)
        allTimeB.setTitleColor(UIColor(red: 134/255, green: 134/255, blue: 134/255, alpha: 1), for: .normal)
        
        mode = "Month"
        updateAllCharts()
    }
    
    @IBAction func allTimePressed(_ sender: Any) {
        dayB.setTitleColor(UIColor(red: 134/255, green: 134/255, blue: 134/255, alpha: 1), for: .normal)
        weekB.setTitleColor(UIColor(red: 134/255, green: 134/255, blue: 134/255, alpha: 1), for: .normal)
        monthB.setTitleColor(UIColor(red: 134/255, green: 134/255, blue: 134/255, alpha: 1), for: .normal)
        allTimeB.setTitleColor(.white, for: .normal)
        
        mode = "All Time"
        updateAllCharts()
    }
    
    //update all charts
    
    func updateAllCharts(){
        if Singleton.categories.count != 0{
            updateBC()
            updatePieChart()
        }
    }
    
    @IBAction func addNewEventPressed(_ sender: Any) {
        Singleton.isTimeline = true
        Singleton.timelineDate = dateC
    }
    
    @IBOutlet weak var statisticsText: UILabel!
    override func viewDidLayoutSubviews() {
        //config timeline
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        let screenHeight = screenRect.size.height
        
        //iphone se
        if screenHeight == 568{
            statisticsText.font = statisticsText.font.withSize(30)
            houseB.isHidden = true
            overviewLabel.font = overviewLabel.font.withSize(15)
            descriptionLabel.font = descriptionLabel.font.withSize(15)
            descriptionButton.frame = CGRect(x: descriptionButton.frame.origin.x - 12, y: descriptionButton.frame.origin.y, width: descriptionButton.frame.size.width, height: descriptionButton.frame.size.height)
            horizontalBC.frame = CGRect(x: horizontalBC.frame.origin.x, y: horizontalBC.frame.origin.y, width: horizontalBC.frame.size.width, height: horizontalBC.frame.size.height - 20)
            pieChartT.frame = CGRect(x: pieChartT.frame.origin.x, y: pieChartT.frame.origin.y, width: pieChartT.frame.size.width, height: pieChartT.frame.size.height - 20)
            pieChartB.frame = CGRect(x: pieChartB.frame.origin.x - 8, y: pieChartB.frame.origin.y - 20, width: pieChartB.frame.size.width, height: pieChartB.frame.size.height)
            barChartB.frame = CGRect(x: barChartB.frame.origin.x - 8, y: barChartB.frame.origin.y - 20, width: barChartB.frame.size.width, height: barChartB.frame.size.height)
            addNewEvent.frame = CGRect(x: addNewEvent.frame.origin.x + 15, y: addNewEvent.frame.origin.y - 20, width: addNewEvent.frame.size.width - 15, height: addNewEvent.frame.size.height - 5)
            addNewEvent.titleLabel?.font = addNewEvent.titleLabel?.font.withSize(15)
            timeline.frame = CGRect(x: timeline.frame.origin.x, y: timeline.frame.origin.y - 20, width: timeline.frame.size.width, height: timeline.frame.size.height)
            currentDate.frame = CGRect(x: currentDate.frame.origin.x, y: currentDate.frame.origin.y - 20, width: currentDate.frame.size.width, height: currentDate.frame.size.height)
        }
        let coordHalfSize = (timeline.frame.origin.y + timeline.frame.size.height + endView.frame.origin.y)/2
        let halfSize = (endView.frame.origin.y - (timeline.frame.origin.y + timeline.frame.size.height))/2
        PM.frame = CGRect(x: PM.frame.origin.x, y: endView.frame.origin.y - PM.frame.size.height * screenHeight/842 - 2, width: PM.frame.size.width, height: PM.frame.size.height * screenHeight/842)
        AM.frame = CGRect(x: AM.frame.origin.x, y: coordHalfSize - AM.frame.size.height * screenHeight/842 - 2, width: AM.frame.size.width, height: AM.frame.size.height * screenHeight/842)
        
        let fontHeight = 28 * screenHeight/842
        
        let frameSize = halfSize - AM.frame.size.height - fontHeight - 3
        frameHeight = Double(frameSize)
        
        amTimeline.frame = CGRect(x: 0, y: AM.frame.origin.y - frameSize/2 - 2, width: screenWidth, height: 1)
        pmTimeline.frame = CGRect(x: 0, y: PM.frame.origin.y - frameSize/2 - 2, width: screenWidth, height: 1)
        //make top timeline
        for i in 0...12{
            let newView = UIView()
            
            newView.frame = CGRect(x: screenWidth/26 + CGFloat(i) * screenWidth/13, y: amTimeline.frame.origin.y - frameSize/2, width: 1, height: frameSize)
            
            newView.backgroundColor = UIColor(red: 134/255, green: 134/255, blue: 134/255, alpha: 1)
            
            let label:UILabel = self.view.viewWithTag(i + 2) as! UILabel
            
            label.center = CGPoint(x: screenWidth/26 + CGFloat(i) * screenWidth/13, y: amTimeline.frame.origin.y - frameSize/2  - fontHeight/2 - 3)
            
            self.view.addSubview(label)
            
            self.view.addSubview(newView)
        }
        
        for i in 0...12{
            let newView = UIView()
            newView.frame = CGRect(x: screenWidth/26 + CGFloat(i) * screenWidth/13, y: pmTimeline.frame.origin.y - frameSize/2, width: 1, height: frameSize)
            
            newView.backgroundColor = UIColor(red: 134/255, green: 134/255, blue: 134/255, alpha: 1)
            
            let label:UILabel = self.view.viewWithTag(i + 2) as! UILabel
            
            label.center = CGPoint(x: screenWidth/26 + CGFloat(i) * screenWidth/13, y: pmTimeline.frame.origin.y - frameSize/2  - fontHeight/2 - 3)
            
            self.view.addSubview(label)
            
            self.view.addSubview(newView)
        }
        //run timeline
        timelineInit()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //set up constraints
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        for i in constraintsHeight{
            i.constant = i.constant * screenHeight/842
        }
        
        for i in constraintsWidth{
            i.constant = i.constant * screenWidth/414
        }
        
        currentDate.layer.borderWidth = 1
        currentDate.layer.borderColor = UIColor.white.cgColor
        
        addNewEvent.layer.borderWidth = 1
        addNewEvent.layer.borderColor = UIColor.white.cgColor
        
        currentDate.setTitleColor(UIColor(red: 134/255, green: 134/255, blue: 134/255, alpha: 1), for: .normal)
        
        //remove last view controller
        var viewControllers = navigationController?.viewControllers
        viewControllers?.removeAll()
        
        // set Date for timeline
        if Singleton.isTimeline == false{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM d, yyyy"
            let selectedDate = dateFormatter.string(from: Date())
            currentDate.setTitle(selectedDate, for: .normal)
            dateC = Date()
        }
        else{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM d, yyyy"
            let selectedDate = dateFormatter.string(from: Singleton.timelineDate)
            currentDate.setTitle(selectedDate, for: .normal)
            dateC = Singleton.timelineDate
            Singleton.isTimeline = false
        }
        
        
        
        //set up attributes timedata
        let attributesName = Singleton.attributesN
        let attributesData = Singleton.attributes
        
        if attributesName.count != 0 {
            for _ in 1...attributesName.count{
                descriptionTimeData.append([])
            }
        }
        
        //dont even try to think about this
        if attributesName.count != 0{
            for i in 0..<attributesData.count{
                for x in attributesData[i]{
                    let b = attributesName.firstIndex(of: x)!
                    for z in Singleton.timeData[i]{
                        descriptionTimeData[b].append(z)
                    }
                }
            }
        }
        
        
        
        pieChartT.noDataText = "No data avaliable."
        pieChartT.noDataTextColor = UIColor(red: 134/255, green: 134/255, blue: 134/255, alpha: 1)
        pieChartT.legend.textColor = UIColor(red: 134/255, green: 134/255, blue: 134/255, alpha: 1)
        pieChartT.legend.font = UIFont(name: "Segoe UI", size: 14)!
        pieChartT.holeColor = .black
        
        
        horizontalBC.noDataText = "No data avaliable."
        horizontalBC.noDataTextColor = UIColor(red: 134/255, green: 134/255, blue: 134/255, alpha: 1)
        
        
        categoriesFormat = Singleton.categories
        colorsFormat = Singleton.colorsC
        pieChartCategoriesFormat = Singleton.categories
        pieChartColorsFormat = Singleton.colorsC
        
        if Singleton.categories.count < 8{
            for _ in 1...8 - Singleton.categories.count{
                categoriesFormat.append("")
                colorsFormat.append(.clear)
            }
        }
        
        //format for input into horizontal BC
        categoriesFormat.reverse()
        colorsFormat.reverse()
        
        
        horizontalBC.xAxis.drawGridLinesEnabled = false
        
        if Singleton.categories.count != 0{
            updateBC()
            updatePieChart()
        }
    }
    

    var chartDataSet = BarChartDataSet()
    var chartData = BarChartData()
    
    func updateBC(){
        if filterMode == "Overview"{
            totalTimeFormat = modeInfo(mode: mode, pieCorNot: false, timeData: Singleton.timeData)
            
            dataEntries = []
            
            for i in 0..<categoriesFormat.count{
                let dataEntry = BarChartDataEntry(x: Double(i), y: Double(totalTimeFormat[i]))
                dataEntries.append(dataEntry)
            }
            chartDataSet = BarChartDataSet(entries: dataEntries, label: "")
            chartData = BarChartData(dataSet: chartDataSet)
            chartDataSet.colors = colorsFormat
            horizontalBC.xAxis.valueFormatter = IndexAxisValueFormatter(values: categoriesFormat)
        
        }
            
        else if filterMode == "Description"{
            
            if Singleton.attributesN.count != 0 {
                
                totalTimeFormat = modeInfo(mode: mode, pieCorNot: false, timeData: descriptionTimeData)
                
                dataEntries = []
                
                
                var colorsDescriptions = [UIColor]()
                for i in 1...Singleton.attributesN.count{
                    colorsDescriptions.append(UIColor(hue: CGFloat(i) * 1/(CGFloat(Singleton.attributesN.count)), saturation: 1, brightness: 1, alpha: 1))
                }
                
                var attributesNFormat = Singleton.attributesN
                
                if Singleton.attributesN.count < 8{
                    for _ in 1...8 - Singleton.attributesN.count{
                        attributesNFormat.append("")
                        colorsDescriptions.append(.clear)
                    }
                }
                colorsDescriptions.reverse()
                attributesNFormat.reverse()
                
                
                for i in 0..<attributesNFormat.count{
                    let dataEntry = BarChartDataEntry(x: Double(i), y: Double(totalTimeFormat[i]))
                    dataEntries.append(dataEntry)
                }
                
                chartDataSet = BarChartDataSet(entries: dataEntries, label: "")
                chartData = BarChartData(dataSet: chartDataSet)
                
                chartDataSet.colors = colorsDescriptions
                horizontalBC.xAxis.valueFormatter = IndexAxisValueFormatter(values: attributesNFormat)
            }
            else{
                chartDataSet = BarChartDataSet()
                chartData = BarChartData()
            }
        }
        
        let noZeroFormatter = NumberFormatter()
        noZeroFormatter.zeroSymbol = ""
        noZeroFormatter.minimumFractionDigits = 2
        noZeroFormatter.maximumFractionDigits = 2
        chartDataSet.valueFormatter = DefaultValueFormatter(formatter: noZeroFormatter)
        
        chartDataSet.valueTextColor = .white
        chartDataSet.valueFont = UIFont(name: "Segoe UI", size: 16)!
        
    
        horizontalBC.legend.enabled = false
        horizontalBC.xAxis.granularityEnabled = true
        horizontalBC.rightAxis.enabled = false
        horizontalBC.xAxis.labelPosition = .top
        horizontalBC.leftAxis.axisMinimum = 0
        horizontalBC.leftAxis.labelFont = UIFont(name: "Segoe UI", size: 16)!
        horizontalBC.leftAxis.labelTextColor = UIColor(red: 134/255, green: 134/255, blue: 134/255, alpha: 1)
        horizontalBC.xAxis.labelFont = UIFont(name: "Segoe UI", size: 14)!
        horizontalBC.xAxis.labelTextColor = UIColor(red: 134/255, green: 134/255, blue: 134/255, alpha: 1)
        horizontalBC.data?.setValueFont(UIFont(name: "Segoe UI", size: 16)!)
        horizontalBC.drawValueAboveBarEnabled = false
        horizontalBC.xAxis.axisMaximum = 8
        horizontalBC.extraLeftOffset = 40
        horizontalBC.extraRightOffset = 40
        pieChartT.extraRightOffset = 40
        pieChartT.extraLeftOffset = 40
        
        horizontalBC.xAxis.granularity = 1
        
        
        horizontalBC.data = chartData
        
        
        if filterMode == "Description" && Singleton.attributesN.count == 0{
            horizontalBC.clear()
        }
    }
    //transition to calendar
    
    @IBAction func timelinePressed(_ sender: Any) {
        Singleton.isTimeline = true
    }
    
    func timelineInit(){
        let timeArray = Singleton.timeData
        let colorArray = Singleton.colorsC
        
        let screenRect = UIScreen.main.bounds
        let screenHeight = screenRect.size.height
        let screenWidth = screenRect.size.width
        
        let maxWidth = Double(screenWidth * 12/13)
        let xStart = Double(screenWidth/26)
        let yAM = Double(amTimeline.frame.origin.y).rounded()
        let yPM = Double(pmTimeline.frame.origin.y).rounded()
        let multiplierFrame = Double((screenWidth * 12/13)/43200)
        
        let height = frameHeight/2.rounded()
        
        let calendar = Calendar(identifier: .gregorian)
        
        let year = calendar.component(.year, from: dateC)
        let month = calendar.component(.month, from: dateC)
        let day = calendar.component(.day, from: dateC)
        
        let datebeginning = calendar.date(from: DateComponents(year: year, month: month, day: day, hour: 0, minute: 0, second: 0))!
        
        let datenoon = calendar.date(from: DateComponents(year: year, month: month, day: day, hour: 12, minute: 0, second: 0))!
        
        
        
        let dateend = calendar.date(byAdding: .day, value: 1, to: datebeginning)!
        
        for i in 0..<timeArray.count{
            
            //for each category, timeArray is even
            for x in 0..<timeArray[i].count/2{
                let dateO = timeArray[i][x * 2]
                let dateT = timeArray[i][x * 2 + 1]
                
                let timeB = dateT.timeIntervalSince(dateO) * multiplierFrame
                //if one date is < 0 and the other date is betwen 0 and 12pm
                if  dateO < datebeginning && dateT.isBetween(datebeginning, and: datenoon){
                    let dateSince = dateT.timeIntervalSince(datebeginning) * multiplierFrame
                    
                    let viewStatistics = UIView(frame: CGRect(x: xStart,y: yAM, width: dateSince, height: height))
                    
                    //change color
                    viewStatistics.backgroundColor = Singleton.colorsC[i]
                    
                    self.view.addSubview(viewStatistics)
                }
                //if one date is < 0 and the other date is between 12 pm and 12 am
                else if  dateO < datebeginning && dateT.isBetween(datenoon, and: dateend){
                    let viewStatistics = UIView(frame: CGRect(x: xStart,y: yAM, width: maxWidth, height: height))
                    //change color
                    viewStatistics.backgroundColor = Singleton.colorsC[i]
                    self.view.addSubview(viewStatistics)
                    
                    let dateSince = dateT.timeIntervalSince(datenoon) * multiplierFrame
                    let viewStatistics2 = UIView(frame: CGRect(x: xStart,y: yPM, width: dateSince, height: height))
                    //change color
                    viewStatistics2.backgroundColor = Singleton.colorsC[i]
                    self.view.addSubview(viewStatistics2)
                }
                //if one date is < 0 and the other date is  > 24
                else if  dateO < datebeginning && dateT > dateend{
                    let viewStatistics = UIView(frame: CGRect(x: xStart,y: yAM, width: maxWidth, height: height))
                    //change color
                    viewStatistics.backgroundColor = Singleton.colorsC[i]
                    self.view.addSubview(viewStatistics)
                    let viewStatistics2 = UIView(frame: CGRect(x: xStart,y: yPM, width: maxWidth, height: height))
                    //change color
                    viewStatistics2.backgroundColor = Singleton.colorsC[i]
                    self.view.addSubview(viewStatistics2)
                }
                //if both dates between 0 and 12 pm
                else if dateO.isBetween(datebeginning, and: datenoon) && dateT.isBetween(datebeginning, and: datenoon){
                    let dateSince = dateO.timeIntervalSince(datebeginning) * multiplierFrame
                    let viewStatistics = UIView(frame: CGRect(x: xStart + dateSince,y: yAM, width: timeB, height: height))
                    //change color
                    viewStatistics.backgroundColor = Singleton.colorsC[i]
                    self.view.addSubview(viewStatistics)
                }
                //if one date is between 0 and 12pm and the other date is between 12 pm and 12 am
                else if  dateO.isBetween(datebeginning, and: datenoon) && dateT.isBetween(datenoon, and: dateend){
                    let dateSinceO = dateO.timeIntervalSince(datebeginning) * multiplierFrame
                    let viewStatistics = UIView(frame: CGRect(x: xStart + dateSinceO,y: yAM, width: datenoon.timeIntervalSince(dateO) * multiplierFrame, height: height))
                    //change color
                    viewStatistics.backgroundColor = Singleton.colorsC[i]
                    self.view.addSubview(viewStatistics)
                    let dateSinceT = dateT.timeIntervalSince(datenoon) * multiplierFrame
                    let viewStatistics2 = UIView(frame: CGRect(x: xStart,y: yPM, width: dateSinceT, height: height))
                    //change color
                    viewStatistics2.backgroundColor = Singleton.colorsC[i]
                    self.view.addSubview(viewStatistics2)
                }
                //if one date is between 0 and 12pm and the other date is >24
                else if  dateO.isBetween(datebeginning, and: datenoon) && dateT > dateend{
                    let dateSinceO = dateO.timeIntervalSince(datebeginning) * multiplierFrame
                    let viewStatistics = UIView(frame: CGRect(x: xStart + dateSinceO,y: yAM, width: datenoon.timeIntervalSince(dateO) * multiplierFrame, height: height))
                    //change color
                    viewStatistics.backgroundColor = Singleton.colorsC[i]
                    self.view.addSubview(viewStatistics)
                    let viewStatistics2 = UIView(frame: CGRect(x: xStart,y: yPM, width: maxWidth, height: height))
                    //change color
                    viewStatistics2.backgroundColor = Singleton.colorsC[i]
                    self.view.addSubview(viewStatistics2)
                }
                //if both dates are between 12pm and 12am
                else if  dateO.isBetween(datenoon, and: dateend) && dateT.isBetween(datenoon, and: dateend){
                    let dateSince = dateO.timeIntervalSince(datenoon) * multiplierFrame
                    let viewStatistics = UIView(frame: CGRect(x: xStart + dateSince,y: yPM, width: timeB, height: height))
                    //change color
                    viewStatistics.backgroundColor = Singleton.colorsC[i]
                    self.view.addSubview(viewStatistics)
                }
                
                //if one data is between 12pm and 12 am and the other date is > 24
                else if  dateO.isBetween(datenoon, and: dateend) && dateT > dateend{
                    let dateSince = dateO.timeIntervalSince(datenoon) * multiplierFrame
                    let viewStatistics = UIView(frame: CGRect(x: xStart + dateSince,y: yPM, width: dateend.timeIntervalSince(dateO) * multiplierFrame, height: height))
                    //change color
                    viewStatistics.backgroundColor = Singleton.colorsC[i]
                    self.view.addSubview(viewStatistics)
                }
                
                
            }
            
        }
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    //update chart based on day/week/month/alltime
    func modeInfo(mode: String, pieCorNot: Bool, timeData: [[Date]]) -> [Double]{
        var newArray = [Double]()
        if mode == "Day"{
            
            //basic calendar setup
            let calendar = Calendar(identifier: .gregorian)
            
            let year = calendar.component(.year, from: dateC)
            let month = calendar.component(.month, from: dateC)
            let day = calendar.component(.day, from: dateC)
            let dateBeginning = calendar.date(from: DateComponents(year: year, month: month, day: day, hour: 0, minute: 0, second: 0))!
            
            let dateEnd = calendar.date(byAdding: .day, value: 1, to: dateBeginning)!
            for i in timeData{
                
                //for each category, timeArray is even
                
                var counter = 0.0
                for x in 0..<i.count/2{
                    let dateO = i[x * 2]
                    let dateT = i[x * 2 + 1]
                    
                    //dateO and dateT both in the same day
                    if dateO.isBetween(dateBeginning, and: dateEnd) && dateT.isBetween(dateBeginning, and: dateEnd){
                        counter += dateT.timeIntervalSince(dateO)
                    }
                    //if dateT on the date but dateO before
                    else if dateO < dateBeginning && dateT.isBetween(dateBeginning, and: dateEnd){
                        counter += dateT.timeIntervalSince(dateBeginning)
                    }
                    //if dateO on the date but dateT after
                    else if dateO.isBetween(dateBeginning, and: dateEnd) && dateT > dateEnd{
                        counter += dateEnd.timeIntervalSince(dateO)
                    }
                    else if dateO < dateBeginning && dateT > dateEnd{
                        counter += dateEnd.timeIntervalSince(dateBeginning)
                    }
                }
                newArray.append(counter/3600)
            }
        }
        else if mode == "Week"{
            let calendar = Calendar(identifier: .gregorian)
            
            let year = calendar.component(.year, from: dateC)
            let week = calendar.component(.weekOfYear, from: dateC)
            let dateBeginning = calendar.date(from: DateComponents(weekOfYear: week, yearForWeekOfYear: year))!
            
            let dateEnd = calendar.date(byAdding: .day, value: 7, to: dateBeginning)!
            for i in timeData{
                    
                    //for each category, timeArray is even
                    
                    var counter = 0.0
                    for x in 0..<i.count/2{
                        let dateO = i[x * 2]
                        let dateT = i[x * 2 + 1]
                        
                        //dateO and dateT both in the same week
                        if dateO.isBetween(dateBeginning, and: dateEnd) && dateT.isBetween(dateBeginning, and: dateEnd){
                            counter += dateT.timeIntervalSince(dateO)
                        }
                        //if dateT on the date but dateO before
                        else if dateO < dateBeginning && dateT.isBetween(dateBeginning, and: dateEnd){
                            counter += dateT.timeIntervalSince(dateBeginning)
                        }
                        //if dateO on the date but dateT after
                        else if dateO.isBetween(dateBeginning, and: dateEnd) && dateT > dateEnd{
                            counter += dateEnd.timeIntervalSince(dateO)
                        }
                        else if dateO < dateBeginning && dateT > dateEnd{
                            counter += dateEnd.timeIntervalSince(dateBeginning)
                        }
                    }
                    newArray.append(counter/3600)
                }
        }
        else if mode == "Month"{
            let calendar = Calendar(identifier: .gregorian)
            
            let year = calendar.component(.year, from: dateC)
            let month = calendar.component(.month, from: dateC)
            let dateBeginning = calendar.date(from: DateComponents(year: year, month:month))!
            let dateEnd = calendar.date(byAdding: .month, value: 1, to: dateBeginning)!
            for i in timeData{
                
                //for each category, timeArray is even
                
                var counter = 0.0
                for x in 0..<i.count/2{
                    let dateO = i[x * 2]
                    let dateT = i[x * 2 + 1]
                    
                    //dateO and dateT both in the same day
                    if dateO.isBetween(dateBeginning, and: dateEnd) && dateT.isBetween(dateBeginning, and: dateEnd){
                        counter += dateT.timeIntervalSince(dateO)
                    }
                    //if dateT on the date but dateO before
                    else if dateO < dateBeginning && dateT.isBetween(dateBeginning, and: dateEnd){
                        counter += dateT.timeIntervalSince(dateBeginning)
                    }
                    //if dateO on the date but dateT after
                    else if dateO.isBetween(dateBeginning, and: dateEnd) && dateT > dateEnd{
                        counter += dateEnd.timeIntervalSince(dateO)
                    }
                    else if dateO < dateBeginning && dateT > dateEnd{
                        counter += dateEnd.timeIntervalSince(dateBeginning)
                    }
                }
                newArray.append(counter/3600)
            }
            
        }
        else if mode == "All Time"{
            for i in timeData{
                
                //for each category, timeArray is even
                
                var counter = 0.0
                for x in 0..<i.count/2{
                    let dateO = i[x * 2]
                    let dateT = i[x * 2 + 1]
                    counter += dateT.timeIntervalSince(dateO)
                }
                newArray.append(counter/3600)
            }
        }
        if pieCorNot == false{
            if filterMode == "Overview"{
                if Singleton.categories.count < 8{
                    for _ in 1...8 - Singleton.categories.count{
                        newArray.append(0)
                    }
                }
                newArray.reverse()
                return newArray
            }
            else{
                if Singleton.attributesN.count < 8{
                    for _ in 1...8 - Singleton.attributesN.count{
                        newArray.append(0)
                    }
                }
                newArray.reverse()
                return newArray
            }
        }
        else{
            return newArray
        }
    }
    

    //attributes

    @IBAction func overviewPressed(_ sender: Any) {
        overviewButton.setTitleColor(.white, for: .normal)
        descriptionButton.setTitleColor(UIColor(red: 134/255, green: 134/255, blue: 134/255, alpha: 1), for: .normal)
        
        overviewLabel.isHidden = false
        descriptionLabel.isHidden = true
        
        filterMode = "Overview"
        updateAllCharts()
    }
    @IBAction func descriptionPressed(_ sender: Any) {
        overviewButton.setTitleColor(UIColor(red: 134/255, green: 134/255, blue: 134/255, alpha: 1), for: .normal)
        descriptionButton.setTitleColor(.white, for: .normal)
        
        overviewLabel.isHidden = true
        descriptionLabel.isHidden = false
        
        filterMode = "Description"
        updateAllCharts()
    }
    
    
    
    
}

extension Date {
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        if self >= date1 && self <= date2{
            return true
        }
        else{
            return false
        }
    }
}
extension Calendar {
    static let gregorian = Calendar(identifier: .gregorian)
}

