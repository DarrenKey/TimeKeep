//
//  NewEventTableVCTableViewController.swift
//  Calendar
//
//  Created by Mi Yan on 1/1/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//

import UIKit
import UserNotifications

class NewEventTableVCTableViewController: UITableViewController, UNUserNotificationCenterDelegate {

    var fromDP = false
    var toDP = false
    var isAlarm = false
    
    var type = "Event"
    
    var textCell = textFieldinNewEventTableViewCell()
    var categoryCell = categoryTVC()
    var fromCell = datePickerCell()
    var toCell = datePickerCell()
    var alarmCell = alarmT()
    var repeatCellT = repeatCell()
    var sliderCell = AssignmentOrEventTableViewCell()
    
    // see if alarm is on or not
    var alarmAtAll = false
    var heightA = [74,69,62,69,68,360,50,50,76,351,87]
    var heightAssignmentA = [74,69,62,69,68,360,50,50,87]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //remove view controllers
        
        var viewControllers = navigationController?.viewControllers
        viewControllers?.removeAll()
        
        tableView.separatorStyle = .none
        
        tableView.allowsSelection = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        tableView.backgroundColor = .black
        // if an event is getting edited
        tableView.reloadData()
        if Singleton.isEditingEvent == true{
            let arrayOfEverything = Singleton.dayDict[Singleton.dateTracker]?[Singleton.pathOfCellEvent] as! [Any]
            if arrayOfEverything[6] as? Date != nil{
                alarmSwitchOn()
            }
            repeatCellT.selectedRepeats = [[0,0]]
            type = arrayOfEverything[10] as? String ?? "Event"
        }
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
    }
    override func viewDidAppear(_ animated: Bool) {
        
        //tasks for each day in the form of a dictionary: String(date) -> Array(tasks)
        //Array - [Name,Category,Category Path, UIColor,startTime, endTime, alarm, repeats]
        //if no alarm, alarm returns nil
    }
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            view.endEditing(true)
            // Do your thang here!
        }
        sender.cancelsTouchesInView = false
    }
    
    
    // MARK: - Table view data source

    @IBAction func confirmBPressed(_ sender: Any) {
        //tasks for each day in the form of a dictionary: String(date) -> Array(tasks)
        //Array - [Name,Category,Category Path, UIColor,startTime, endTime, alarm, repeats]
        //if no alarm, alarm returns nil
        
        if categoryCell.selectedCategory == ""{
            categoryCell.colorCategory = .white
        }
        
        if String(textCell.textFieldCell.text ?? "") == ""{
            invalidRequest()
        }
        else if toCell.dateP <= fromCell.dateP{
            invalidRequest()
        }
        else if alarmCell.whenAlarm < Date() && alarmAtAll == true{
            invalidRequest()
        }
        //store in dictionary of tasks
        else{
            if Singleton.isEditingEvent == true{
                //delete previous
                let editPathNum = Singleton.pathOfCellEvent
                let template = Singleton.dayDict[Singleton.dateTracker]![editPathNum]
                //remove every single iteration
                let selectedRepeats = template[7] as! [IndexPath]
                //var isEqualArray = true
                let type = template[10] as! String
                 
                if selectedRepeats[0] != [0,0]{
                    
                    
                    //remove repetitions
                    for (key, value) in Singleton.dayDict{
                        for x in 0..<value.count{
                            if value[x][9] as! String == template[9] as! String{
                                Singleton.dayDict[key]?.remove(at: x)
                                }
                            }
                        }
                 
                     Singleton.dayDict[Singleton.dateTracker]!.insert(template, at: editPathNum)
                 }

                
                if type == "Assignment"{
                    //remove repetitions
                    for (key, value) in Singleton.dayDict{
                        for x in 0..<value.count{
                            if value[x][9] as! String == template[9] as! String{
                                Singleton.dayDict[key]?.remove(at: x)
                            }
                        }
                    }
                     
                     Singleton.dayDict[Singleton.dateTracker]!.insert(template, at: editPathNum)
                }
                 
                //if alarm exists
                if template[6] ?? nil != nil{
                    let center = UNUserNotificationCenter.current()
                    
                    //if repeating
                    if selectedRepeats[0] != [0,0]{
                        
                        for i in 1...selectedRepeats.count{
                            //remove notification
                            center.removePendingNotificationRequests(withIdentifiers: ["\(template[0] as! String)|\(i)"])
                        }

                        //remove notification
                        center.removePendingNotificationRequests(withIdentifiers: ["\(template[0] as! String)|0"])
                        
                    }
                    
                    //no repeat
                    else{
                        center.removePendingNotificationRequests(withIdentifiers: ["\(template[0] as! String)|0"])
                        
                    }
                }
                
                Singleton.dayDict[Singleton.dateTracker]?.remove(at: Singleton.pathOfCellEvent)
                Singleton.isEditingEvent = false
            }
            
            /*Possible Feature - to add later (possibly if people ask for it)*/
            //copy event for each day
           // let diffInDays = Calendar.current.dateComponents([.day], from:Calendar.current.startOfDay(for: fromCell.dateP) , to: Calendar.current.startOfDay(for: toCell.dateP)).day!
            
            
            
            
            //add dictionary
            if alarmAtAll == true && type == "Event"{
                addDict(whenAlarm: alarmCell.whenAlarm, selectedRepeats: repeatCellT.selectedRepeats)
            }
            else{
                addDict(whenAlarm: nil, selectedRepeats: repeatCellT.selectedRepeats)
            }
        }
        performSegue(withIdentifier: "toMain", sender: nil)
    }
    
    //add items to dictionary
    
    func addDict(whenAlarm : Date?, selectedRepeats: [IndexPath]){
        let dateString = Singleton.dateTracker
        var repeatedCounter = 0
        let dateStringArray = dateString.components(separatedBy: " ")
        let dateGiven = Calendar.current.date(from: DateComponents(year: Int(dateStringArray[2])!, month: Singleton.monthArray.firstIndex(of: dateStringArray[0])! + 1, day: Int(dateStringArray[1].prefix(dateStringArray[1].count - 1))))!
        let weekOftheYear = Calendar.current.component(.weekOfYear, from: dateGiven)
        let year = Calendar.current.component(.yearForWeekOfYear, from: dateGiven)
        var newDate = Date()
        let uniqueString = UUID().uuidString
        if repeatCellT.selectedRepeats[0] != [0,0]{
            while true{
                if Calendar.current.component(.year, from: newDate) >= 2021{
                    break
                }
                for i in repeatCellT.selectedRepeats{
                    newDate = Calendar.current.date(from: DateComponents(weekday: i.row + 1, weekOfYear: repeatedCounter + weekOftheYear, yearForWeekOfYear: year))!
                    if repeatedCounter == 0{
                        if newDate > dateGiven{
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "MMMM d, yyyy"
                            let selectedDate = dateFormatter.string(from: newDate)
                            var tempDayDict = Singleton.dayDict[selectedDate] ?? []
                            tempDayDict.append([textCell.textFieldCell.text!, categoryCell.selectedCategory, categoryCell.categoryPath, categoryCell.colorCategory, fromCell.dateP,toCell.dateP, whenAlarm ?? nil, selectedRepeats, false, uniqueString, type])
                            Singleton.dayDict[selectedDate] = tempDayDict
                        }
                    }
                    else{
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MMMM d, yyyy"
                        let selectedDate = dateFormatter.string(from: newDate)
                        var tempDayDict = Singleton.dayDict[selectedDate] ?? []
                        tempDayDict.append([textCell.textFieldCell.text!, categoryCell.selectedCategory, categoryCell.categoryPath, categoryCell.colorCategory, fromCell.dateP,toCell.dateP, whenAlarm ?? nil, selectedRepeats, false, uniqueString, type])
                        Singleton.dayDict[selectedDate] = tempDayDict
                    }
                }

                repeatedCounter += 1
                
                
            }
            
        }
        if type == "Assignment"{
            var dateTrackerT = Calendar.current.startOfDay(for: fromCell.dateP)
            
            while true{
                if dateTrackerT > toCell.dateP{
                    break
                }
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMM d, yyyy"
                let selectedDate = dateFormatter.string(from: dateTrackerT)
                
                var tempDayDict = Singleton.dayDict[selectedDate] ?? []
                tempDayDict.append([textCell.textFieldCell.text!, categoryCell.selectedCategory, categoryCell.categoryPath, categoryCell.colorCategory, fromCell.dateP,toCell.dateP, whenAlarm ?? nil, selectedRepeats, false, uniqueString, type])
                Singleton.dayDict[selectedDate] = tempDayDict
                
                dateTrackerT = Calendar.current.date(byAdding: .day, value: 1, to: dateTrackerT)!
            }
        }
        else{
            var tempDayDict = Singleton.dayDict[Singleton.dateTracker] ?? []
            tempDayDict.append([textCell.textFieldCell.text!, categoryCell.selectedCategory, categoryCell.categoryPath, categoryCell.colorCategory, fromCell.dateP,toCell.dateP, whenAlarm ?? nil, selectedRepeats, false, uniqueString, type])
            Singleton.dayDict[Singleton.dateTracker] = tempDayDict
        }
        
        
        if alarmAtAll == true{
            let content = UNMutableNotificationContent()
            content.title = "Alarm"
            content.body = textCell.textFieldCell.text!
            content.sound = UNNotificationSound.default
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            

            let weekDay = Calendar.current.component(.weekday, from: dateGiven)
            
            //see if repeating weekday is equal to the original set date
            var isIn = false
            
            if selectedRepeats[0].row != 0{
                for i in 0..<selectedRepeats.count{

                    let calendar = Calendar.gregorian

                    var dateComponents = DateComponents()
                    
                    if selectedRepeats[i].row == weekDay{
                        isIn = true
                    }
                    
                    dateComponents.hour = calendar.component(.hour, from: alarmCell.whenAlarm)
                    dateComponents.minute = calendar.component(.minute, from: alarmCell.whenAlarm)
                    dateComponents.second = 0
                    dateComponents.weekday = selectedRepeats[i].row
                    
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                    
                    let request = UNNotificationRequest(identifier: "\(textCell.textFieldCell.text!)|\(i + 1)", content: content, trigger: trigger)
                    center.add(request, withCompletionHandler: { (error) in
                        // if something goes wrong write some code here, i expect nothing wrong so theres no code
                    })
                }
                if isIn == false{
                    
                    //set alarm
                    let calendar = Calendar.gregorian

                    var dateComponents = DateComponents()
                    
                    
                    dateComponents.hour = calendar.component(.hour, from: alarmCell.whenAlarm)
                    dateComponents.minute = calendar.component(.minute, from: alarmCell.whenAlarm)
                    dateComponents.second = 0
                    dateComponents.day = calendar.component(.day, from: alarmCell.whenAlarm)
                    dateComponents.month = calendar.component(.month, from: alarmCell.whenAlarm)
                    dateComponents.year = calendar.component(.year, from: alarmCell.whenAlarm)
                    
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                    
                    let request = UNNotificationRequest(identifier: "\(textCell.textFieldCell.text!)|0", content: content, trigger: trigger)
                    
                    center.add(request, withCompletionHandler: { (error) in
                        if let error = error{
                            print("something went wrong")
                        }
                        // if something goes wrong write some code here, i expect nothing wrong so theres no code
                    })
                }
                
            }
            else{

                let calendar = Calendar.gregorian

                var dateComponents = DateComponents()
                
                
                dateComponents.hour = calendar.component(.hour, from: alarmCell.whenAlarm)
                dateComponents.minute = calendar.component(.minute, from: alarmCell.whenAlarm)
                dateComponents.second = 0
                dateComponents.day = calendar.component(.day, from: alarmCell.whenAlarm)
                dateComponents.month = calendar.component(.month, from: alarmCell.whenAlarm)
                dateComponents.year = calendar.component(.year, from: alarmCell.whenAlarm)
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                
                let request = UNNotificationRequest(identifier: "\(textCell.textFieldCell.text!)|0", content: content, trigger: trigger)
                
                
                center.add(request, withCompletionHandler: { (error) in
                    if let error = error{
                        print("something went wrong")
                    }
                    // if something goes wrong write some code here, i expect nothing wrong so theres no code
                })
        }
            
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if type == "Event"{
            return 11
        }
        else{
            return 9
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "0", for: indexPath) as! NewEventLabel
            cell.backgroundColor = .black
            cell.selectionStyle = .none
            

            let screenHeight = UIScreen.main.bounds.height
            cell.newEventLabel.font = cell.newEventLabel.font.withSize(35 * screenHeight/842)
            
            if type == "Event"{
                cell.newEventLabel.text = "New Event"
            }
            else{
                cell.newEventLabel.text = "New Assignment"
            }
            
            return cell
            
        }
        if indexPath.row == 2{
            textCell = tableView.dequeueReusableCell(withIdentifier: "2", for: indexPath) as! textFieldinNewEventTableViewCell
            textCell.backgroundColor = .black
            textCell.selectionStyle = .none
            
            return textCell
            
        }
        if indexPath.row == 3{
            sliderCell = tableView.dequeueReusableCell(withIdentifier: "AssignmentOrEvent", for: indexPath) as! AssignmentOrEventTableViewCell
            sliderCell.backgroundColor = .black
            sliderCell.selectionStyle = .none
            sliderCell.eventOrAssignment.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
            
            if type == "Event"{
                sliderCell.eventOrAssignment.selectedSegmentIndex = 0
            }
            else{
                sliderCell.eventOrAssignment.selectedSegmentIndex = 1
            }
            
            return sliderCell
        }
        if indexPath.row == 5{
            categoryCell = tableView.dequeueReusableCell(withIdentifier: "5", for: indexPath) as! categoryTVC
            categoryCell.backgroundColor = .black
            categoryCell.selectionStyle = .none
            
            return categoryCell
        }
        else if indexPath.row == 6{
            fromCell = tableView.dequeueReusableCell(withIdentifier: "6", for: indexPath) as! datePickerCell
            fromCell.backgroundColor = .black
            fromCell.selectionStyle = .none
            //if from cell

            if Singleton.isEditingEvent == true{
                let arrayOfEverything = Singleton.dayDict[Singleton.dateTracker]?[Singleton.pathOfCellEvent] as! [Any]
                let startT = arrayOfEverything[4] as! Date
                fromCell.datePicker.setDate(startT, animated: true)
                fromCell.dateP = startT
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM d, yyyy h:mm a"
                let selectedDate = dateFormatter.string(from: fromCell.datePicker.date)
                
                fromCell.labelT.text = selectedDate
            }
            if type == "Assignment"{
                fromCell.fromOrTo.text = "Start Date:"
            }
            else{
                fromCell.fromOrTo.text = "From:"
            }
            
            return fromCell
        }
        else if indexPath.row == 7{
            toCell = tableView.dequeueReusableCell(withIdentifier: "6", for: indexPath) as! datePickerCell
            
            toCell.backgroundColor = .black
            toCell.selectionStyle = .none
            
            if type == "Assignment"{
                toCell.fromOrTo.text = "Due Date:"
            }
            else{
                toCell.fromOrTo.text = "To:"
            }
            
            if Singleton.isEditingEvent == true{
                let arrayOfEverything = Singleton.dayDict[Singleton.dateTracker]?[Singleton.pathOfCellEvent] as! [Any]
                let endT = arrayOfEverything[5] as! Date
                toCell.datePicker.setDate(endT, animated: true)
                toCell.dateP = endT
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM d, yyyy h:mm a"
                let selectedDate = dateFormatter.string(from: toCell.datePicker.date)
                
                toCell.labelT.text = selectedDate
            }
            
            return toCell
        }
            
        //alarm cell 
        else if indexPath.row == 8{
            if type == "Event"{
                alarmCell = tableView.dequeueReusableCell(withIdentifier: "alarm", for: indexPath) as! alarmT
                alarmCell.switchT.addTarget(self, action: #selector(alarmSwitchOn), for: .valueChanged)
                alarmCell.backgroundColor = .black
                alarmCell.selectionStyle = .none
                UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                  if settings.authorizationStatus != .authorized {
                    // Notifications are not allowed
                    DispatchQueue.main.async {
                        self.alarmCell.switchT.isEnabled = false
                    }
                    }
                }

                return alarmCell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "9", for: indexPath)
                cell.backgroundColor = .black
                cell.selectionStyle = .none
                return cell
            }
        }
            
        //repeat cell
        else if indexPath.row == 9{
            repeatCellT = tableView.dequeueReusableCell(withIdentifier: "repeat", for: indexPath) as! repeatCell
            repeatCellT.backgroundColor = .black
            repeatCellT.selectionStyle = .none
            
            return repeatCellT
            
        }
        //category button cell
        else if indexPath.row == 10{
            let cell = tableView.dequeueReusableCell(withIdentifier: "9", for: indexPath)
            cell.backgroundColor = .black
            cell.selectionStyle = .none
            return cell
            
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: String(indexPath.row), for: indexPath)
        cell.backgroundColor = .black
        cell.selectionStyle = .none
        return cell
    }
    
    //if slider changed
    @objc func sliderChanged(){
        type = sliderCell.eventOrAssignment.titleForSegment(at: sliderCell.eventOrAssignment.selectedSegmentIndex)!
        tableView.reloadData()
    }
    
    @objc func alarmSwitchOn(){
        isAlarm = !isAlarm
        alarmAtAll = !alarmAtAll
        if isAlarm == true{
            tableView.beginUpdates()
            heightA[8] = 304
            //tableView.reloadRows(at: [indexPath], with: .none)
            tableView.endUpdates()
        }
        else{
            tableView.beginUpdates()
            heightA[8] = 76
            //tableView.reloadRows(at: [indexPath], with: .none)
            tableView.endUpdates()
        }
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 5 && Singleton.categories.count < 7{
            return CGFloat(80 + 40 * Singleton.categories.count)
        }
        if type == "Event"{
            return CGFloat(heightA[indexPath.row])
        }
        else{
            return CGFloat(heightAssignmentA[indexPath.row])
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //if from is clicked
        if indexPath.row == 6 && fromDP == false{
            tableView.beginUpdates()
            if type == "Event"{
                heightA[6] = 240
            }else{
                heightAssignmentA[6] = 240
            }
            //tableView.reloadRows(at: [indexPath], with: .none)
            tableView.endUpdates()
            fromDP = true
        }
        else if fromDP == true{
            tableView.beginUpdates()
            if type == "Event"{
                heightA[6] = 50
            }else{
                heightAssignmentA[6] = 50
            }
            tableView.endUpdates()
            fromDP = false
        }
        //if to is clicked
        if indexPath.row == 7 && toDP == false{
            tableView.beginUpdates()
            if type == "Event"{
                heightA[7] = 240
            }else{
                heightAssignmentA[7] = 240
            }
            //tableView.reloadRows(at: [indexPath], with: .none)
            tableView.endUpdates()
            toDP = true
        }
        else if toDP == true{
            tableView.beginUpdates()
            if type == "Event"{
                heightA[7] = 50
            }else{
                heightAssignmentA[7] = 50
            }
            tableView.endUpdates()
            toDP = false
        }
        
    }
    
    @IBAction func newCategoryPressed(_ sender: Any) {
        Singleton.isEditingEvent = true
    }
    //if x button pressed
    @IBAction func xPressed(_ sender: Any) {
        invalidRequest()
    }
    
    func invalidRequest(){
        if Singleton.isEditingEvent == true{
            Singleton.isEditingEvent = false
        }
        performSegue(withIdentifier: "toMain", sender: nil)
    }
    
    
    // This method will be called when app received push notifications in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.badge, .sound])
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
