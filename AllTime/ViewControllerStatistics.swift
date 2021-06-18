//
//  ViewControllerStatistics.swift
//  Calendar
//
//  Created by Mi Yan on 11/1/19.
//  Copyright © 2019 Darren Key. All rights reserved.
//
/*
import UIKit
import Charts

class ViewControllerStatistics: UIViewController {
    
    @IBOutlet weak var PieChart: PieChartView!
    
    @IBOutlet weak var labelT: UITextView!
    var pieChartEntryArray = [PieChartDataEntry]()
    
    var totalT: Double = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        PieChart.noDataText = "No data available."
        PieChart.chartDescription?.text = ""
        
        
       // setChart(dataPoints: Singleton.categories, values: Singleton.timeData)
        
        
        for i in Singleton.timeData{
            totalT += i[0]
        }
        
        labelT.text += "Out of the \(round(10.0 * totalT)/10.0) seconds so far,\nyou've spent: \n"
        if Singleton.categories.count != 0{
            for i in 0...Singleton.categories.count - 1{
                labelT.text += "\(Singleton.categories[i]) : \(round(10.0 * Singleton.timeData[i][0]/totalT * 100)/10.0)% or \(round(10.0 * Singleton.timeData[i][0])/10.0) seconds \n"
            }
        }
        
        
        var viewControllers = navigationController?.viewControllers
        
        viewControllers?.removeLast()
        /*for i in Singleton.timeData{
            pieChartEntryArray.append(PieChartDataEntry(value: i[0]))
            
        }
        
        let chartDataSet = PieChartDataSet(entries: pieChartEntryArray, label: nil)
        let chartData = PieChartData(dataSet:chartDataSet)

        PieChart.data = chartData
        */
        // Do any additional setup after loading the view.®
    }
    
    func setChart(dataPoints: [String], values: [[Double]]) {
        
        var dataEntries: [PieChartDataEntry] = []
        
        for i in values{
            if i[0] != 0{
                let dataEntry = PieChartDataEntry(value: i[0])
                dataEntries.append(dataEntry)
            }
        }
        
        let pieChartDataSet = PieChartDataSet(entries: dataEntries)
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        
        var colors: [UIColor] = []
        if dataEntries.count != 0{
            for i in 0...dataEntries.count - 1{
                if values[i][0] != 0{
                 //   dataEntries[i].label = Singleton.categories[i]
                }
            }
            for i in 1...dataPoints.count {
                let tempAmount = Double(i)/Double((dataPoints.count + 1))
                let color = UIColor(red: CGFloat(1 - tempAmount), green: CGFloat(tempAmount), blue: CGFloat(1 - tempAmount), alpha: 1)
                colors.append(color)
                }
        }
        pieChartDataSet.colors = colors
        PieChart.data = pieChartData
        
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
*/

