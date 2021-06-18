//
//  CalendarVC.swift
//  Calendar
//
//  Created by Mi Yan on 12/31/19.
//  Copyright © 2019 Darren Key. All rights reserved.
//

import UIKit

protocol MyCellDelegate {
    func cellWasPressed()
    func transitionTimeline()
}

class CalendarVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MyCellDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var houseIcon: UIButton!
    
    var yearArray = [2020, 2020, 2020, 2020, 2020, 2020, 2020, 2020, 2020, 2020, 2020,2020, 2021, 2021, 2021, 2021, 2021, 2021, 2021, 2021, 2021, 2021, 2021, 2021, 2022, 2022, 2022, 2022, 2022, 2022, 2022, 2022, 2022, 2022, 2022, 2022, 2023, 2023, 2023, 2023, 2023, 2023, 2023, 2023, 2023, 2023, 2023, 2023, 2024, 2024, 2024, 2024, 2024, 2024, 2024, 2024, 2024, 2024, 2024, 2024, 2025, 2025, 2025, 2025, 2025, 2025, 2025, 2025, 2025, 2025, 2025, 2025, 2026, 2026, 2026, 2026, 2026, 2026,2026, 2026, 2026, 2026, 2026, 2026, 2027, 2027, 2027, 2027, 2027, 2027, 2027, 2027, 2027, 2027, 2027, 2027, 2028, 2028, 2028, 2028, 2028, 2028, 2028, 2028, 2028, 2028, 2028, 2028, 2029, 2029, 2029, 2029, 2029, 2029, 2029, 2029, 2029, 2029, 2029, 2029, 2030, 2030, 2030, 2030, 2030, 2030, 2030, 2030, 2030, 2030, 2030, 2030, 2031, 2031, 2031, 2031, 2031, 2031, 2031, 2031, 2031, 2031, 2031, 2031, 2032,2032, 2032, 2032, 2032, 2032, 2032, 2032, 2032, 2032, 2032, 2032, 2033, 2033, 2033, 2033, 2033, 2033, 2033, 2033, 2033, 2033, 2033, 2033, 2034, 2034, 2034, 2034, 2034, 2034, 2034, 2034, 2034, 2034, 2034, 2034, 2035, 2035, 2035, 2035, 2035, 2035, 2035, 2035, 2035, 2035, 2035, 2035, 2036, 2036, 2036, 2036, 2036, 2036, 2036, 2036, 2036, 2036, 2036, 2036, 2037, 2037, 2037, 2037, 2037, 2037, 2037, 2037,2037, 2037, 2037, 2037, 2038, 2038, 2038, 2038, 2038, 2038, 2038, 2038, 2038, 2038, 2038, 2038, 2039, 2039, 2039, 2039, 2039, 2039, 2039, 2039, 2039, 2039, 2039, 2039]
    
    var monthArray = ["January",
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 240
    }
    
    //current day

    let componentsOfDate = [Calendar.current.component(.year, from: Date()),Calendar.current.component(.month, from: Date()),Calendar.current.component(.day, from: Date())]
    
    let selectedDate = [Calendar.current.component(.year, from: Singleton.selectedDate),Calendar.current.component(.month, from: Singleton.selectedDate),Calendar.current.component(.day, from: Singleton.selectedDate)]
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! CalendarMonthTableViewCell
        
        let dayEndedT = Singleton.dayEnded[indexPath.row]
        let daysPerMonth = Singleton.daysPerMonth[indexPath.row % 12]
        
        var counter = 1
        cell.tag = indexPath.row
        cell.collectionView.frame = CGRect(x: cell.collectionView.frame.origin.x, y: cell.collectionView.frame.origin.y, width: cell.collectionView.frame.size.width, height: cell.frame.origin.y + cell.frame.size.height - cell.collectionView.frame.origin.y)
        
        cell.monthL.text = monthArray[indexPath.row % 12]
        cell.monthL.textColor = UIColor.white
        cell.monthL.font = UIFont(name: "Segoe UI", size: 30)!
        
        cell.yearL.text = String(yearArray[indexPath.row])
        cell.yearL.textColor = UIColor.white
        cell.yearL.font = UIFont(name: "Segoe UI", size: 20)!
        
        
        for i in 1...42{
            if i < dayEndedT{
                cell.days.append("")
            }
            else if counter > daysPerMonth{
                if yearArray[indexPath.row] % 4 == 0 && cell.monthL?.text == "February" && counter == 29{
                    cell.days.append("29")
                    counter += 1
                }
                else{
                    cell.days.append("")
                }
            }
            else{
                cell.days.append(String(counter))
                counter += 1
            }
        }
        
        //select cell of today
        if componentsOfDate[0] == indexPath.row/12 + 2020 && componentsOfDate[1] - 1 == indexPath.row{
            cell.todayDay = cell.days.firstIndex(of: String(componentsOfDate[2]))!
        }
        
        if selectedDate[0] == indexPath.row/12 + 2020 && selectedDate[1] - 1 == indexPath.row % 12{
            cell.whenDayIs = cell.days.firstIndex(of: String(selectedDate[2]))!
        }
            
        cell.selectionStyle = .none
        cell.collectionView.reloadData()
        cell.delegate = self
        return cell
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //remove view controllers
        
        var viewControllers = navigationController?.viewControllers
        viewControllers?.removeAll()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 150 + self.view.frame.size.width
        
        
        
        //tableView.scrollRectToVisible(CGRect(x: 0, y: 1200, width: 1, height: 1), animated: true)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        //to scroll tableview automatically
        if Singleton.isTimeline == true{
            
            let dateGiven = Singleton.timelineDate
            let month = Calendar.current.component(.month, from: dateGiven)
            let yearC = Calendar.current.component(.year, from: dateGiven) - 2020
            
            //scroll to current date
            CATransaction.begin()

            tableView.beginUpdates()
            tableView.scrollToRow(at: [0,yearC * 12 + month - 1], at: .middle, animated: true)
            tableView.endUpdates()

            CATransaction.commit()
            
            tableView.cellForRow(at: [0,yearC * 12 + month - 2])
            tableView.cellForRow(at: [0,yearC * 12 + month - 1])
            tableView.cellForRow(at: [0,yearC * 12 + month])
        }
        else{
            //convert Singleton.dateTracker to an actual date
            let dateString = Singleton.dateTracker
            let dateStringArray = dateString.components(separatedBy: " ")
            let dateGiven = Calendar.current.date(from: DateComponents(year: Int(dateStringArray[2])!, month: Singleton.monthArray.firstIndex(of: dateStringArray[0])! + 1, day: Int(dateStringArray[1].prefix(dateStringArray[1].count - 1))))

            let month = Calendar.current.component(.month, from: dateGiven!)
            let yearC = Calendar.current.component(.year, from: dateGiven!) - 2020
            
            
            //scroll to current date
            CATransaction.begin()

            tableView.beginUpdates()
            tableView.scrollToRow(at: [0,yearC * 12 + month - 1], at: .middle, animated: true)
            tableView.endUpdates()

            CATransaction.commit()

            tableView.cellForRow(at: [0,yearC * 12 + month - 2])
            tableView.cellForRow(at: [0,yearC * 12 + month - 1])
            tableView.cellForRow(at: [0,yearC * 12 + month])
        }
        //tableView.scrollToRow(at: IndexPath(row: yearC * 12 + month - 1 ,section:0), at: .none, animated: false)
    }
    
    func cellWasPressed() {
        performSegue(withIdentifier: "toMainfromCalendar", sender: nil)
    }
    
    func transitionTimeline() {
        performSegue(withIdentifier: "toStatistics", sender: nil)
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
