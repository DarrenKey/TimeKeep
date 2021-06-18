//
//  ManualOverrideTableViewController.swift
//  Calendar
//
//  Created by Mi Yan on 1/15/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//

import UIKit

class ManualOverrideTableViewController: UITableViewController {

    
    var fromDP = false
    var toDP = false
    
    var categoryCell = categoryTVC()
    var fromCell = datePickerCell()
    var toCell = datePickerCell()
    
    @IBOutlet weak var overrideEventTimeText: UILabel!
    // see if alarm is on or not
    var alarmAtAll = false
    var heightA = [74, 68,360,50,50,87]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        var viewControllers = navigationController?.viewControllers
        viewControllers?.removeAll()
        
        tableView.separatorStyle = .none
        
        tableView.allowsSelection = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        tableView.backgroundColor = .black
        // if an event is getting edited
        
        //tasks for each day in the form of a dictionary: String(date) -> Array(tasks)
        //Array - [Name,Category,Category Path, UIColor,startTime, endTime, alarm, repeats]
        //if no alarm, alarm returns nil
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
       
    }

    
    // MARK: - Table view data source

    @IBAction func confirmBPressed(_ sender: Any) {
        //invalid requests
        let fromDate = fromCell.datePicker.date
        let toDate = toCell.datePicker.date
        
        if toDate <= fromDate{
            invalidRequest()
        }
        else if categoryCell.categoryPath == IndexPath(){
            invalidRequest()
        }
        else{
            
            //add time to displayTime
            if Singleton.lastReset.isBetween(fromDate, and: toDate){
                Singleton.displayTime[categoryCell.categoryPath.row] += toDate.timeIntervalSince(Singleton.lastReset)
            }
            else if fromDate >= Singleton.lastReset{
                Singleton.displayTime[categoryCell.categoryPath.row] += toDate.timeIntervalSince(fromDate)
            }
            
            //reformat other time dates to not be between the two dates
            for i in 0..<Singleton.timeData.count{
                var numRemoved = 0
                var tempArray = Singleton.timeData[i]
                for x in 0..<Singleton.timeData[i].count/2{
                    
                    let firstDate = Singleton.timeData[i][2 * x]
                    let secondDate = Singleton.timeData[i][2 * x + 1]
                    
                    //if  both dates are between the two
                    if firstDate.isBetween(fromDate, and: toDate) && secondDate.isBetween(fromDate, and: toDate){
                        
                        
                        //minus time from displayTime
                        if Singleton.lastReset.isBetween(firstDate, and: secondDate){
                            Singleton.displayTime[i] -= secondDate.timeIntervalSince(Singleton.lastReset)
                        }
                        else if firstDate >= Singleton.lastReset{
                            Singleton.displayTime[i] -= secondDate.timeIntervalSince(firstDate)
                        }
                        
                        tempArray.remove(at: 2 * (x - numRemoved))
                        tempArray.remove(at: 2 * (x - numRemoved))
                        numRemoved += 1
                    }
                    else if firstDate < fromDate && secondDate.isBetween(fromDate, and: toDate){
                        tempArray[2 * (x - numRemoved) + 1] = fromDate
                        
                        //minus time from displayTime
                        if Singleton.lastReset.isBetween(fromDate, and: secondDate){
                            Singleton.displayTime[i] -= secondDate.timeIntervalSince(Singleton.lastReset)
                        }
                        else if fromDate >= Singleton.lastReset{
                            Singleton.displayTime[i] -= secondDate.timeIntervalSince(fromDate)
                        }
                    }
                    else if firstDate.isBetween(fromDate, and: toDate) && secondDate > toDate{
                        tempArray[2 * (x - numRemoved)] = toDate
                        
                        //minus time from displayTime
                        if Singleton.lastReset.isBetween(firstDate, and: toDate){
                            Singleton.displayTime[i] -= toDate.timeIntervalSince(Singleton.lastReset)
                        }
                        else if firstDate >= Singleton.lastReset{
                            Singleton.displayTime[i] -= toDate.timeIntervalSince(firstDate)
                        }
                    }
                    else if firstDate < fromDate && secondDate > toDate{
                        tempArray.insert(fromDate, at: 2 * (x-numRemoved) + 1)
                        tempArray.insert(toDate, at: 2 * (x-numRemoved) + 2)
                        numRemoved -= 1
                        
                        
                        //minus time from displayTime
                        if Singleton.lastReset.isBetween(fromDate, and: toDate){
                            Singleton.displayTime[i] -= toDate.timeIntervalSince(Singleton.lastReset)
                        }
                        else if fromDate >= Singleton.lastReset{
                            Singleton.displayTime[i] -= toDate.timeIntervalSince(fromDate)
                        }
                    }
                }
                Singleton.timeData[i] = tempArray
            }
            Singleton.timeData[categoryCell.categoryPath.row].insert(toDate, at: 0)
            Singleton.timeData[categoryCell.categoryPath.row].insert(fromDate, at: 0)
        }
    }
    
    //add items to dictionary
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "0", for: indexPath) as! overridetextTableViewCell
            cell.backgroundColor = .black
            cell.selectionStyle = .none
            return cell
        }
        if indexPath.row == 2{
            categoryCell = tableView.dequeueReusableCell(withIdentifier: "2", for: indexPath) as! categoryTVC
            categoryCell.backgroundColor = .black
            categoryCell.selectionStyle = .none
            
            return categoryCell
        }
        else if indexPath.row == 3{
            fromCell = tableView.dequeueReusableCell(withIdentifier: "3", for: indexPath) as! datePickerCell
            fromCell.backgroundColor = .black
            fromCell.selectionStyle = .none
            //if from cell
            
            fromCell.datePicker.maximumDate = Date()
                
            return fromCell
        }
        else if indexPath.row == 4{
            toCell = tableView.dequeueReusableCell(withIdentifier: "3", for: indexPath) as! datePickerCell
            
            toCell.datePicker.maximumDate = Date()
            
            toCell.backgroundColor = .black
            toCell.selectionStyle = .none
            toCell.fromOrTo.text = "To:"
            return toCell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: String(indexPath.row), for: indexPath)
        cell.backgroundColor = .black
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 && Singleton.categories.count < 7{
            return CGFloat(80 + 40 * Singleton.categories.count)
        }
        return CGFloat(heightA[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //if from is clicked
        if indexPath.row == 3 && fromDP == false{
            tableView.beginUpdates()
            heightA[3] = 240
            //tableView.reloadRows(at: [indexPath], with: .none)
            tableView.endUpdates()
            fromDP = true
        }
        else if fromDP == true{
            tableView.beginUpdates()
            heightA[3] = 50
            tableView.endUpdates()
            fromDP = false
        }
        //if to is clicked
        if indexPath.row == 4 && toDP == false{
            tableView.beginUpdates()
            heightA[4] = 240
            //tableView.reloadRows(at: [indexPath], with: .none)
            tableView.endUpdates()
            toDP = true
        }
        else if toDP == true{
            tableView.beginUpdates()
            heightA[4] = 50
            tableView.endUpdates()
            toDP = false
        }
        
    }
    @IBAction func newCategoryPressed(_ sender: Any) {
        performSegue(withIdentifier: "toStatistics", sender: nil)
        Singleton.isInOverride = true
    }
    //if x button pressed
    @IBAction func xPressed(_ sender: Any) {
        invalidRequest()
    }
    
    func invalidRequest(){
        performSegue(withIdentifier: "toStatistics", sender: nil)
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
