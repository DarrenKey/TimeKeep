//
//  Planner.swift
//  TimeKeep
//
//  Created by Mi Yan on 4/26/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//

import UIKit
import RealmSwift

protocol toMainView{
    func calendarDown(days: Int, months: Int)
    
    func calendarUp()
}

class Planner: UIViewController {
    
    @IBOutlet weak var plannerCV: UICollectionView!
    
    @IBOutlet weak var plannerLabel: UILabel!
    @IBOutlet weak var yearText: UILabel!
    
    var editingPath: Int = 0
    
    //which date the planner is showing
    var plannerMonth = 0
    var plannerDay = 0
    var plannerYear = 0
    
    //delegate to tell mainview to bring down calendar
    var delegate: toMainView?
    
    //realms to access saves
    var realm = try! Realm()
    
    //jan 1 2020
    var firstDate = Date()
    
    //the currently displayed cell
    var displayedCell = 0
    var currentDateCell = Date()
    
    //temp height
    var tempHeight: CGFloat! = 0
    
    //array of month names
    var monthNames = ["JANUARY","FEBRUARY","MARCH","APRIL","MAY","JUNE","JULY","AUGUST","SEPTEMBER","OCTOBER","NOVEMBER","DECEMBER"]
    
    //screenheight and screenwidth
    var screenHeight: CGFloat = 0
    var screenWidth: CGFloat = 0
    
    @IBOutlet weak var addNewTaskButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        plannerMonth = (Calendar.current.dateComponents([.month], from: Date()).month ?? 0) - 1
        plannerDay = Calendar.current.dateComponents([.day], from: Date()).day ?? 0
        plannerYear = Calendar.current.dateComponents([.year], from: Date()).year ?? 0
        
        yearText.text = String(plannerYear)
        
        //standard delegate
        plannerCV.delegate = self
        plannerCV.dataSource = self
        
        //Jan 1 2020
        var dateComponents = DateComponents()
        dateComponents.year = 2020
        dateComponents.month = 1
        dateComponents.day = 1
        
        firstDate = Calendar.current.date(from: dateComponents)!
        
        let daysSince = Calendar.current.dateComponents([.day], from: firstDate, to: Date()).day ?? 0
        
        let screen = UIScreen.main.bounds
        screenWidth = screen.size.width
        screenHeight = screen.size.height
        
        resizeDevice()
        
        plannerCV.scrollToItem(at: [0,daysSince], at: .centeredHorizontally, animated: false)
        displayedCell = daysSince
        
        //calculations to find what month and day it is
        var daysAdded = DateComponents()
        daysAdded.day = displayedCell
        
        currentDateCell = Calendar.current.date(byAdding: daysAdded, to: firstDate)!
        
    }
    
    //manually resize
    func resizeDevice(){
        //decrease width
        if screenWidth == 375 && screenHeight == 812{
            //font size
            plannerLabel.font = plannerLabel.font.withSize(35)
            plannerLabel.frame = CGRect(x: 24, y: 77, width: 162, height: 46)
            yearText.font = yearText.font.withSize(20)
            yearText.frame = CGRect(x: 301, y: 72, width: 50, height: 26)
            
            plannerCV.frame = CGRect(x: 0, y: 156, width: 375, height: 474)
            
            addNewTaskButton.frame = CGRect(x: 45, y: 653, width: 285, height: 46)
            addNewTaskButton.titleLabel?.font = addNewTaskButton.titleLabel?.font.withSize(25)
        }
        else if screenWidth == 414 && screenHeight == 736{
            plannerLabel.frame = CGRect(x: 24, y: 50, width: 185, height: 52)
            yearText.frame = CGRect(x: 328, y: 44, width: 62, height: 33)
            
            plannerCV.frame = CGRect(x: 0, y: 132, width: 414, height: 454)
            
            addNewTaskButton.frame = CGRect(x: 65, y: 606, width: 284, height: 40)
            addNewTaskButton.titleLabel?.font = addNewTaskButton.titleLabel?.font.withSize(20)
        }
        else if screenWidth == 375 && screenHeight == 667{
            plannerLabel.font = plannerLabel.font.withSize(35)
            yearText.font = yearText.font.withSize(20)
            addNewTaskButton.titleLabel?.font = addNewTaskButton.titleLabel?.font.withSize(20)
            
            yearText.frame = CGRect(x: 301, y: 40, width: 50, height: 26)
            plannerLabel.frame = CGRect(x: 24, y: 50, width: 162, height: 46)
            
            plannerCV.frame = CGRect(x: 0, y: 126, width: 375, height: 408)
            
            addNewTaskButton.frame = CGRect(x: 74, y: 551, width: 227, height: 38)
        }
        else if screenWidth == 320 && screenHeight == 568{
            plannerLabel.font = plannerLabel.font.withSize(30)
            yearText.font = yearText.font.withSize(18)
            addNewTaskButton.titleLabel?.font = addNewTaskButton.titleLabel?.font.withSize(18)
            
            yearText.frame = CGRect(x: 251, y: 30, width: 45, height: 24)
            plannerLabel.frame = CGRect(x: 24, y: 40, width: 139, height: 39)
            
            plannerCV.frame = CGRect(x: 0, y: 99, width: 320, height: 355)
            
            addNewTaskButton.frame = CGRect(x: 50, y: 465, width: 220, height: 31)
        }
        else if screenWidth == 768 && screenHeight == 1024{
            plannerLabel.font = plannerLabel.font.withSize(50)
            yearText.font = yearText.font.withSize(35)
            addNewTaskButton.titleLabel?.font = addNewTaskButton.titleLabel?.font.withSize(35)
            
            yearText.frame = CGRect(x: 657, y: 30, width: 87, height: 46)
            plannerLabel.frame = CGRect(x: 24, y: 60, width: 232, height: 65)
            
            plannerCV.frame = CGRect(x: 0, y: 165, width: 768, height: 654)
            
            addNewTaskButton.frame = CGRect(x: 171, y: 837, width: 426, height: 69)
        }
        else if screenWidth == 834 && screenHeight == 1194{
            plannerLabel.font = plannerLabel.font.withSize(65)
            yearText.font = yearText.font.withSize(45)
            addNewTaskButton.titleLabel?.font = addNewTaskButton.titleLabel?.font.withSize(45)
            
            yearText.frame = CGRect(x: 698, y: 40, width: 112, height: 59)
            plannerLabel.frame = CGRect(x: 24, y: 50, width: 301, height: 85)
            
            plannerCV.frame = CGRect(x: 0, y: 165, width: 834, height: 746)
            
            addNewTaskButton.frame = CGRect(x: 162, y: 945, width: 510, height: 85)
        }
        else if screenWidth == 834 && screenHeight == 1112{
            plannerLabel.font = plannerLabel.font.withSize(65)
            yearText.font = yearText.font.withSize(45)
            addNewTaskButton.titleLabel?.font = addNewTaskButton.titleLabel?.font.withSize(45)
            
            yearText.frame = CGRect(x: 698, y: 40, width: 112, height: 59)
            plannerLabel.frame = CGRect(x: 24, y: 50, width: 301, height: 85)
            
            plannerCV.frame = CGRect(x: 0, y: 165, width: 834, height: 696)
            
            addNewTaskButton.frame = CGRect(x: 162, y: 889, width: 510, height: 85)
        }
        else if screenWidth == 810 && screenHeight == 1080{
            plannerLabel.font = plannerLabel.font.withSize(65)
            yearText.font = yearText.font.withSize(45)
            addNewTaskButton.titleLabel?.font = addNewTaskButton.titleLabel?.font.withSize(35)
            
            yearText.frame = CGRect(x: 674, y: 40, width: 112, height: 59)
            plannerLabel.frame = CGRect(x: 24, y: 50, width: 301, height: 85)
            
            plannerCV.frame = CGRect(x: 0, y: 165, width: 810, height: 696)
            
            addNewTaskButton.frame = CGRect(x: 192, y: 881, width: 426, height: 69)
        }
        else if screenWidth == 1024 && screenHeight == 1366{
            plannerLabel.font = plannerLabel.font.withSize(75)
            yearText.font = yearText.font.withSize(50)
            addNewTaskButton.titleLabel?.font = addNewTaskButton.titleLabel?.font.withSize(45)
            
            yearText.frame = CGRect(x: 876, y: 45, width: 124, height: 65)
            plannerLabel.frame = CGRect(x: 24, y: 60, width: 347, height: 98)
            
            plannerCV.frame = CGRect(x: 0, y: 198, width: 1024, height: 887)
            
            addNewTaskButton.frame = CGRect(x: 251, y: 1116, width: 522, height: 80)
        }
    }
    
    //resize plannerCV cell
    func resizeCell(cell: PlannerCell){
        
        //resize pointers and datetext and tableview
        if screenWidth == 375 && screenHeight == 812{
            cell.tableView.frame = CGRect(x: 0, y: 56, width: 375, height: 418)
            
            cell.masterView.frame = CGRect(x: 0, y: 0, width: 375, height: 56)
            
            cell.leftPointer.frame = CGRect(x: 30, y: 8, width: 50, height: 40)
            cell.rightPointer.frame = CGRect(x: 295, y: 8, width: 50, height: 40)
            
            cell.dateText.font = cell.dateText.font.withSize(20)
            cell.dateText.frame = CGRect(x: 80, y: 0, width: 215, height: 56)
            cell.dateButton.frame = cell.dateText.frame
        }
        else if screenWidth == 414 && screenHeight == 736{
            cell.tableView.frame = CGRect(x: 0, y: 57, width: 414, height: 397)
            
            cell.masterView.frame = CGRect(x: 0, y: 0, width: 414, height: 57)
            
            cell.leftPointer.frame = CGRect(x: 40, y: 8.5, width: 50, height: 40)
            cell.rightPointer.frame = CGRect(x: 324, y: 8.5, width: 50, height: 40)
            
            cell.dateText.font = cell.dateText.font.withSize(25)
            cell.dateText.frame = CGRect(x: 90, y: 0, width: 234, height: 57)
            cell.dateButton.frame = cell.dateText.frame
            
            cell.tableView.frame = CGRect(x: 0, y: 57, width: 414, height: 397)
        }
        else if screenWidth == 375 && screenHeight == 667{
            cell.tableView.frame.size.height = 358
            cell.tableView.frame.origin.y = 50
            
            cell.masterView.frame.size.width = screenWidth
            cell.masterView.frame.size.height = 50
            
            cell.leftPointer.frame.origin.x = 28
            cell.leftPointer.frame.origin.y = 5
            cell.rightPointer.frame.origin.x = 297
            cell.rightPointer.frame.origin.y = 5
            
            cell.dateText.font = cell.dateText.font.withSize(20)
            cell.dateText.frame = CGRect(x: 78, y: 0, width: 219, height: 50)
            
            cell.dateButton.frame = CGRect(x: 78, y: 0, width: 219, height: 50)
        }
        else if screenWidth == 320 && screenHeight == 568{
            cell.tableView.frame.size.height = 304
            cell.tableView.frame.origin.y = 51
            
            cell.masterView.frame.size.width = screenWidth
            cell.masterView.frame.size.height = 51
            
            cell.leftPointer.frame.origin.x = 15
            cell.leftPointer.frame.origin.y = 5.5
            cell.rightPointer.frame.origin.x = 255
            cell.rightPointer.frame.origin.y = 5.5
            
            cell.dateText.font = cell.dateText.font.withSize(20)
            cell.dateText.frame = CGRect(x: 65, y: 0, width: 190, height: 51)
            
            cell.dateButton.frame = CGRect(x: 65, y: 0, width: 190, height: 51)
        }
        else if screenWidth == 768 && screenHeight == 1024{
            cell.tableView.frame = CGRect(x: 0, y: 92, width: 768, height: 562)
            
            cell.masterView.frame = CGRect(x: 0, y: 0, width: 768, height: 92)
            
            cell.rightPointer.frame = CGRect(x: 628, y: 26, width: 50, height: 40)
            cell.leftPointer.frame = CGRect(x: 90, y: 26, width: 50, height: 40)
            
            cell.rightPointer.contentHorizontalAlignment = .fill
            cell.rightPointer.contentVerticalAlignment = .fill
            
            cell.leftPointer.contentHorizontalAlignment = .fill
            cell.leftPointer.contentVerticalAlignment = .fill
            
            cell.dateText.font = cell.dateText.font.withSize(40)
            cell.dateText.frame = CGRect(x: 140, y: 20, width: 488, height: 52)
            
            cell.dateButton.frame = CGRect(x: 140, y: 0, width: 488, height: 92)
        }
        else if screenWidth == 834 && screenHeight == 1194{
            cell.tableView.frame = CGRect(x: 0, y: 92, width: 834, height: 654)
            
            cell.masterView.frame = CGRect(x: 0, y: 0, width: 834, height: 92)
            
            cell.rightPointer.frame = CGRect(x: 684, y: 26, width: 50, height: 40)
            cell.leftPointer.frame = CGRect(x: 100, y: 26, width: 50, height: 40)
            
            cell.rightPointer.contentHorizontalAlignment = .fill
            cell.rightPointer.contentVerticalAlignment = .fill
            
            cell.leftPointer.contentHorizontalAlignment = .fill
            cell.leftPointer.contentVerticalAlignment = .fill
            
            cell.dateText.font = cell.dateText.font.withSize(50)
            cell.dateText.frame = CGRect(x: 150, y: 0, width: 534, height: 92)
            
            cell.dateButton.frame = CGRect(x: 150, y: 0, width: 534, height: 92)
        }
        else if screenWidth == 834 && screenHeight == 1112{
            cell.tableView.frame = CGRect(x: 0, y: 96, width: 834, height: 600)
            
            cell.masterView.frame = CGRect(x: 0, y: 0, width: 834, height: 96)
            
            cell.rightPointer.frame = CGRect(x: 684, y: 28, width: 50, height: 40)
            cell.leftPointer.frame = CGRect(x: 100, y: 28, width: 50, height: 40)
            
            cell.rightPointer.contentHorizontalAlignment = .fill
            cell.rightPointer.contentVerticalAlignment = .fill
            
            cell.leftPointer.contentHorizontalAlignment = .fill
            cell.leftPointer.contentVerticalAlignment = .fill
            
            cell.dateText.font = cell.dateText.font.withSize(45)
            cell.dateText.frame = CGRect(x: 150, y: 0, width: 534, height: 96)
            
            cell.dateButton.frame = CGRect(x: 150, y: 0, width: 534, height: 96)
        }
        else if screenWidth == 810 && screenHeight == 1080{
            cell.tableView.frame = CGRect(x: 0, y: 96, width: 810, height: 600)
            
            cell.masterView.frame = CGRect(x: 0, y: 0, width: 810, height: 96)
            
            cell.rightPointer.frame = CGRect(x: 660, y: 28, width: 50, height: 40)
            cell.leftPointer.frame = CGRect(x: 100, y: 28, width: 50, height: 40)
            
            cell.rightPointer.contentHorizontalAlignment = .fill
            cell.rightPointer.contentVerticalAlignment = .fill
            
            cell.leftPointer.contentHorizontalAlignment = .fill
            cell.leftPointer.contentVerticalAlignment = .fill
            
            cell.dateText.font = cell.dateText.font.withSize(40)
            cell.dateText.frame = CGRect(x: 150, y: 0, width: 534, height: 96)
            
            cell.dateButton.frame = CGRect(x: 150, y: 0, width: 534, height: 96)
        }
        else if screenWidth == 1024 && screenHeight == 1366{
            cell.tableView.frame = CGRect(x: 0, y: 121, width: 1024, height: 766)
            
            cell.masterView.frame = CGRect(x: 0, y: 0, width: 1024, height: 121)
            
            cell.rightPointer.frame = CGRect(x: 802, y: 32, width: 72, height: 57)
            cell.leftPointer.frame = CGRect(x: 150, y: 32, width: 72, height: 57)
            
            cell.rightPointer.contentHorizontalAlignment = .fill
            cell.rightPointer.contentVerticalAlignment = .fill
            
            cell.leftPointer.contentHorizontalAlignment = .fill
            cell.leftPointer.contentVerticalAlignment = .fill
            
            cell.dateText.font = cell.dateText.font.withSize(60)
            cell.dateText.frame = CGRect(x: 222, y: 0, width: 580, height: 121)
            
            cell.dateButton.frame = CGRect(x: 222, y: 0, width: 580, height: 121)
        }
    }
    
    @IBAction func newTaskPress(_ sender: Any) {
        var mediumGenerator: UIImpactFeedbackGenerator? = UIImpactFeedbackGenerator(style: .medium)
        mediumGenerator?.prepare()
        mediumGenerator?.impactOccurred()
        mediumGenerator = nil
    }
    
    
    //unwind from newTask
    @IBAction func unwindToPlanner(_ sender: UIStoryboardSegue){
    }
    
    //update the year
    func updateYear(){
        let currentYear = Calendar.current.dateComponents([.year], from: currentDateCell).year ?? 0
        
        yearText.text = String(currentYear)
    }
    
    //if editing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newTask"{
            let newTaskVC = segue.destination as! NewTask
            
            newTaskVC.isEditingNewTask = true
            newTaskVC.editingPath = editingPath
            newTaskVC.editingDaysSince = displayedCell
            
        }
    }
}

extension Planner: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7304
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let plannerCell = cell as! PlannerCell
        
        plannerCell.tableView.delegate = self
        plannerCell.tableView.dataSource = self
        plannerCell.tableView.reloadData()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        displayedCell = Int(plannerCV.contentOffset.x/plannerCV.frame.size.width)
        
        //calculations to find what month and day it is
        var daysAdded = DateComponents()
        daysAdded.day = displayedCell
        
        currentDateCell = Calendar.current.date(byAdding: daysAdded, to: firstDate)!
        
        //update year
        updateYear()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let plannerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "plannerCell", for: indexPath) as! PlannerCell
        
        //set tag = day
        plannerCell.tableView.tag = indexPath.item
        
        //set plannerCell delegate
        plannerCell.delegate = self
        
        //calculations to find what month and day it is
        var daysAdded = DateComponents()
        daysAdded.day = indexPath.item
        
        let newDate = Calendar.current.date(byAdding: daysAdded, to: firstDate)
        
        let monthSince = (Calendar.current.dateComponents([.month], from: newDate!).month ?? 0) - 1
        
        let daySince = Calendar.current.dateComponents([.day], from: newDate!).day ?? 0
        
        plannerCell.dateText.text = "\(monthNames[monthSince % 12]) \(daySince)"
        
        resizeCell(cell: plannerCell)
        
        return plannerCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if screenWidth == 375 && screenHeight == 812{
            return CGSize(width: 375, height: 474)
        }
        else if screenWidth == 414 && screenHeight == 736{
            return CGSize(width: 414, height: 454)
        }
        else if screenWidth == 375 && screenHeight == 667{
            return CGSize(width: 375, height: 408)
        }
        else if screenWidth == 320 && screenHeight == 568{
            return CGSize(width: 320, height: 355)
        }
        else if screenWidth == 768 && screenHeight == 1024{
            return CGSize(width: 768, height: 654)
        }
        else if screenWidth == 834 && screenHeight == 1194{
            return CGSize(width: 834, height: 746)
        }
        else if screenWidth == 834 && screenHeight == 1112{
            return CGSize(width: 834, height: 696)
        }
        else if screenWidth == 810 && screenHeight == 1080{
            return CGSize(width: 810, height: 696)
        }
        else if screenWidth == 1024 && screenHeight == 1366{
            return CGSize(width: 1024, height: 887)
        }
        return CGSize(width: 414, height: 551)
    }
}

extension Planner: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //calculations to find what month and day it is
        var daysAdded = DateComponents()
        daysAdded.day = tableView.tag
        
        let newDate = Calendar.current.date(byAdding: daysAdded, to: firstDate)!
        
        let monthSince = Calendar.current.dateComponents([.month], from: firstDate, to: newDate).month ?? 0
        
        let daySince = Calendar.current.dateComponents([.day], from: newDate).day ?? 0
        
        //filter out saved tasks for the displayed day
        let taskSaved = realm.objects(TaskSaved.self).filter("startMonth <= %@ AND startDay <= %@ AND endMonth >= %@ AND endDay >= %@", monthSince,daySince,monthSince,daySince)
        
        if indexPath.row == taskSaved.count - 1{
            if screenWidth == 320 && screenHeight == 568{
                return tempHeight - 1
            }
            else{
                return tempHeight - 2
            }
        }
        return tempHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Task") as! Task
        
        //calculations to find what month and day it is
        var daysAdded = DateComponents()
        daysAdded.day = tableView.tag
        
        let newDate = Calendar.current.date(byAdding: daysAdded, to: firstDate)!
        
        let monthSince = Calendar.current.dateComponents([.month], from: firstDate, to: newDate).month ?? 0
        
        let daySince = Calendar.current.dateComponents([.day], from: newDate).day ?? 0
        
        //filter out saved tasks for the displayed day
        let taskSaved = realm.objects(TaskSaved.self).filter("startMonth <= %@ AND startDay <= %@ AND endMonth >= %@ AND endDay >= %@", monthSince,daySince,monthSince,daySince)[indexPath.row]
        
        //enable cell checkbox if enabled before
        if taskSaved.doneTasks.firstIndex(of: newDate) ?? -1 != -1{
            cell.taskDone.setOn(true, animated: false)
        }
        else{
            cell.taskDone.setOn(false, animated: false)
        }
        
        cell.categoryName.text = "Category: \(taskSaved.categoryName)"
        
        //cell name
        cell.taskName.text = taskSaved.name
        
        //cell color
        cell.colorView.backgroundColor = UIColor(hue: CGFloat(taskSaved.h), saturation: CGFloat(taskSaved.s), brightness: CGFloat(taskSaved.b), alpha: CGFloat(taskSaved.a))
        
        //tag for position
        cell.tag = indexPath.row
        
        //resize masterview
        cell.masterView.frame.size.width = screenWidth
        
        //only for XR - reposition cell label and cell
        if screenWidth == 414 && screenHeight == 896{
            cell.taskName.frame = CGRect(x: 60, y: 10, width: 308, height: 26)
        }
        else if screenWidth == 414 && screenHeight == 736{
            cell.taskName.font = cell.taskName.font.withSize(18)
            cell.taskName.frame = CGRect(x: 46, y: 6, width: 323, height: 26)
        }
        else if screenWidth == 375 && screenHeight == 812{
            cell.taskName.frame = CGRect(x: 49, y: 9, width: 281, height: 26)
        }
        else if screenWidth == 375 && screenHeight == 667{
            cell.taskName.font = cell.taskName.font.withSize(18)
            
            cell.taskName.frame = CGRect(x: 48, y: 8, width: 282, height: 24)
        }
        else if screenWidth == 320 && screenHeight == 568{
            cell.taskName.font = cell.taskName.font.withSize(16)
            
            cell.taskName.frame = CGRect(x: 35, y: 5, width: 245, height: 21)
        }
        else if screenWidth == 768 && screenHeight == 1024{
            cell.taskName.font = cell.taskName.font.withSize(35)
            
            cell.taskName.frame = CGRect(x: 80, y: 10, width: 618, height: 46)
        }
        else if screenWidth == 834 && screenHeight == 1194{
            cell.taskName.font = cell.taskName.font.withSize(35)
            
            cell.taskName.frame = CGRect(x: 80, y: 10, width: 684, height: 46)
        }
        else if screenWidth == 834 && screenHeight == 1112{
            cell.taskName.font = cell.taskName.font.withSize(35)
            
            cell.taskName.frame = CGRect(x: 80, y: 10, width: 684, height: 46)
        }
        else if screenWidth == 810 && screenHeight == 1080{
            cell.taskName.font = cell.taskName.font.withSize(35)
            
            cell.taskName.frame = CGRect(x: 80, y: 10, width: 660, height: 46)
        }
        else if screenWidth == 1024 && screenHeight == 1366{
            cell.taskName.font = cell.taskName.font.withSize(50)
            
            cell.taskName.frame = CGRect(x: 100, y: 10, width: 824, height: 65)
        }
        cell.taskName.sizeToFit()
        
        
        //only for XR - repositiion categoryname
        if screenWidth == 414 && screenHeight == 896{
            cell.categoryName.frame = CGRect(x: 60, y: 19 + cell.taskName.frame.size.height, width: 308, height: 13)
        }
        else if screenWidth == 414 && screenHeight == 736{
            cell.categoryName.font = cell.categoryName.font.withSize(8)
            
            cell.categoryName.frame = CGRect(x: 46, y: 14 + cell.taskName.frame.size.height, width: 323, height: 13)
        }
        else if screenWidth == 375 && screenHeight == 812{
            cell.categoryName.frame = CGRect(x: 49, y: 20 + cell.taskName.frame.size.height, width: 281, height: 13)
        }
        else if screenWidth == 375 && screenHeight == 667{
            cell.categoryName.font = cell.categoryName.font.withSize(10)
            
            cell.categoryName.frame = CGRect(x: 48, y: 15 + cell.taskName.frame.size.height, width: 282, height: 13)
        }
        else if screenWidth == 320 && screenHeight == 568{
            cell.categoryName.font = cell.categoryName.font.withSize(8)
            
            cell.categoryName.frame = CGRect(x: 35, y: 13 + cell.taskName.frame.size.height, width: 245, height: 11)
        }
        else if screenWidth == 768 && screenHeight == 1024{
            cell.categoryName.font = cell.categoryName.font.withSize(15)
            
            cell.categoryName.frame = CGRect(x: 80, y: 16 + cell.taskName.frame.size.height, width: 618, height: 20)
        }
        else if screenWidth == 834 && screenHeight == 1194{
            cell.categoryName.font = cell.categoryName.font.withSize(15)
            
            cell.categoryName.frame = CGRect(x: 80, y: 16 + cell.taskName.frame.size.height, width: 684, height: 20)
        }
        else if screenWidth == 834 && screenHeight == 1112{
            cell.categoryName.font = cell.categoryName.font.withSize(15)
            
            cell.categoryName.frame = CGRect(x: 80, y: 22 + cell.taskName.frame.size.height, width: 684, height: 20)
        }
        else if screenWidth == 810 && screenHeight == 1080{
            cell.categoryName.font = cell.categoryName.font.withSize(15)
            
            cell.categoryName.frame = CGRect(x: 80, y: 22 + cell.taskName.frame.size.height, width: 660, height: 20)
        }
        else if screenWidth == 1024 && screenHeight == 1366{
            cell.categoryName.font = cell.categoryName.font.withSize(20)
            
            cell.categoryName.frame = CGRect(x: 100, y: 27 + cell.taskName.frame.size.height, width: 824, height: 26)
        }
        
        cell.categoryName.sizeToFit()
        
        if screenWidth == 414 && screenHeight == 896{
            //resize cell to new height -- only for XR
            tempHeight = 29 + cell.categoryName.frame.size.height + cell.taskName.frame.size.height
        }
        else if screenWidth == 414 && screenHeight == 736{
            tempHeight = 22 + cell.categoryName.frame.size.height + cell.taskName.frame.size.height
        }
        else if screenWidth == 375 && screenHeight == 812{
            tempHeight = 29 + cell.categoryName.frame.size.height + cell.taskName.frame.size.height
        }
        else if screenWidth == 375 && screenHeight == 667{
            tempHeight = 23 + cell.categoryName.frame.size.height + cell.taskName.frame.size.height
        }
        else if screenWidth == 320 && screenHeight == 568{
            tempHeight = 19 + cell.categoryName.frame.size.height + cell.taskName.frame.size.height
        }
        else if screenWidth == 768 && screenHeight == 1024{
            tempHeight = 26 + cell.categoryName.frame.size.height + cell.taskName.frame.size.height
        }
        else if screenWidth == 834 && screenHeight == 1194{
            tempHeight = 26 + cell.categoryName.frame.size.height + cell.taskName.frame.size.height
        }
        else if screenWidth == 834 && screenHeight == 1112{
            tempHeight = 34 + cell.categoryName.frame.size.height + cell.taskName.frame.size.height
        }
        else if screenWidth == 810 && screenHeight == 1080{
            tempHeight = 34 + cell.categoryName.frame.size.height + cell.taskName.frame.size.height
        }
        else if screenWidth == 1024 && screenHeight == 1366{
            tempHeight = 37 + cell.categoryName.frame.size.height + cell.taskName.frame.size.height
        }
        
        //resize colorview
        if screenWidth == 375 && screenHeight == 667{
            cell.colorView.frame = CGRect(x: 0, y: 0, width: 40, height: 54)
            
            cell.seperatorView.frame = CGRect(x: 0, y: 54, width: 375, height: 2)
            
            cell.trashCanImage.frame.size = CGSize(width: 33, height: 40)
            
            cell.wobbleView.frame.size.width = 60
            cell.wobbleViewButton.frame.size.width = 60
        }
        else if screenWidth == 375 && screenHeight == 812{
            cell.colorView.frame = CGRect(x: 0, y: 0, width: 40, height: 70)
            
            cell.seperatorView.frame = CGRect(x: 0, y: 68, width: 375, height: 2)
            
            cell.trashCanImage.frame.size = CGSize(width: 33, height: 40)
            
            cell.wobbleView.frame.size.width = 60
            cell.wobbleViewButton.frame.size.width = 60
        }
        else if screenWidth == 414 && screenHeight == 736{
            cell.colorView.frame = CGRect(x: 0, y: 0, width: 40, height: 57)
            
            cell.seperatorView.frame = CGRect(x: 0, y: 55, width: 414, height: 2)
            
            cell.wobbleView.frame = CGRect(x: 414, y: 0, width: 70, height: 55)
            cell.wobbleViewButton.frame = CGRect(x: 0, y: 0, width: 70, height: 55)
            
            cell.trashCanImage.frame.size = CGSize(width: 40, height: 45)
        }
        else if screenWidth == 320 && screenHeight == 568{
            cell.colorView.frame = CGRect(x: 0, y: 0, width: 30, height: 50)
            
            cell.trashCanImage.frame.size = CGSize(width: 34, height: 39)
            
            cell.wobbleView.frame.size.width = 50
            cell.wobbleViewButton.frame.size.width = 50
        }
        else if screenWidth == 768 && screenHeight == 1024{
            cell.colorView.frame = CGRect(x: 0, y: 0, width: 70, height: 92)
            
            cell.seperatorView.frame = CGRect(x: 0, y: 90, width: 768, height: 2)
        }
        else if screenWidth == 834 && screenHeight == 1194{
            cell.colorView.frame = CGRect(x: 0, y: 0, width: 70, height: 92)
            
            cell.seperatorView.frame = CGRect(x: 0, y: 90, width: 834, height: 2)
        }
        else if screenWidth == 834 && screenHeight == 1112{
            cell.colorView.frame = CGRect(x: 0, y: 0, width: 70, height: 87)
            
            cell.seperatorView.frame = CGRect(x: 0, y: 85, width: 834, height: 2)
            
            cell.trashCanImage.frame.size = CGSize(width: 56, height: 66)
        }
        else if screenWidth == 810 && screenHeight == 1080{
            cell.colorView.frame = CGRect(x: 0, y: 0, width: 70, height: 87)
            
            cell.seperatorView.frame = CGRect(x: 0, y: 85, width: 810, height: 2)
            
            cell.trashCanImage.frame.size = CGSize(width: 56, height: 66)
        }
        else if screenWidth == 1024 && screenHeight == 1366{
            cell.colorView.frame = CGRect(x: 0, y: 0, width: 90, height: 128)
            
            cell.seperatorView.frame = CGRect(x: 0, y: 126, width: 1024, height: 2)
            
            cell.trashCanImage.frame.size = CGSize(width: 70, height: 80)
        }
        
        //checkboxes format
        cell.taskDone.onFillColor = UIColor(hex: "5CCF47")
        cell.taskDone.onTintColor = UIColor(hex: "5CCF47")
        cell.taskDone.onCheckColor = .white
        cell.taskDone.boxType = .circle
        cell.taskDone.onAnimationType = .fill
        cell.taskDone.offAnimationType = .fill
        
        //resize taskDone
        if screenWidth == 414 && screenHeight == 896{
            cell.taskDone.frame = CGRect(x: 376, y: 20, width: 28, height: 28)
        }
        else if screenWidth == 414 && screenHeight == 736{
            cell.taskDone.frame = CGRect(x: 379, y: 20, width: 25, height: 25)
        }
        else if screenWidth == 375 && screenHeight == 812{
            cell.taskDone.frame = CGRect(x: 340, y: 20, width: 25, height: 25)
        }
        else if screenWidth == 375 && screenHeight == 667{
            cell.taskDone.frame = CGRect(x: 340, y: 20, width: 25, height: 25)
        }
        else if screenWidth == 320 && screenHeight == 568{
            cell.taskDone.frame = CGRect(x: 290, y: 20, width: 20, height: 20)
        }
        else if screenWidth == 768 && screenHeight == 1024{
            cell.taskDone.frame = CGRect(x: 713, y: 20, width: 40, height: 40)
        }
        else if screenWidth == 834 && screenHeight == 1194{
            cell.taskDone.frame = CGRect(x: 779, y: 20, width: 40, height: 40)
        }
        else if screenWidth == 834 && screenHeight == 1112{
            cell.taskDone.frame = CGRect(x: 779, y: 20, width: 40, height: 40)
        }
        else if screenWidth == 810 && screenHeight == 1080{
            cell.taskDone.frame = CGRect(x: 755, y: 20, width: 40, height: 40)
        }
        else if screenWidth == 1024 && screenHeight == 1366{
            cell.taskDone.frame = CGRect(x: 944, y: 20, width: 60, height: 60)
        }
        
        print(tempHeight, "tempHeight", screenWidth, "screenWidth")
        
        //reposition seperator
        cell.seperatorView.frame.origin.y = tempHeight - 2
        
        //reheight everything
        cell.colorView.frame.size.height = tempHeight
        cell.wobbleView.frame.size.height = tempHeight - 2
        cell.wobbleViewButton.frame.size.height = tempHeight - 2
        cell.masterView.frame.size.height = tempHeight
        cell.taskDone.center.y = (tempHeight - 2)/2
        
        //position trashcanimage
        cell.trashCanImage.frame.origin.x = screenWidth + cell.wobbleView.frame.size.width/2 - cell.trashCanImage.frame.size.width/2
        
        //changing masterView && seperator
        if screenWidth == 320 && screenHeight == 568{
            cell.seperatorView.frame.origin.y = tempHeight - 1
            cell.masterView.frame.size.height = tempHeight
            cell.wobbleView.frame.size.height = tempHeight - 1
            cell.wobbleViewButton.frame.size.height = tempHeight - 1
            cell.taskDone.center.y = (tempHeight - 1)/2
        }
        else if screenWidth == 375 && screenHeight == 667{
            cell.seperatorView.frame.origin.y = tempHeight - 1
            cell.masterView.frame.size.height = tempHeight
            cell.wobbleView.frame.size.height = tempHeight - 1
            cell.wobbleViewButton.frame.size.height = tempHeight - 1
            cell.taskDone.center.y = (tempHeight - 1)/2
        }
        
        //center trashcanicon
        cell.trashCanImage.frame.origin.y = cell.wobbleView.frame.size.height/2 - cell.trashCanImage.frame.size.height/2
        
        //reset view locations -- only for iPhone XR
        cell.masterView.frame.origin = CGPoint(x: 0, y: 0)
        cell.wobbleView.frame.origin = CGPoint(x: screenWidth, y: 0)
        
        //reset wobbleview
        cell.wobbleView.positionChanged()
        cell.wobbleView.reset()
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //calculations to find what month and day it is
        var daysAdded = DateComponents()
        daysAdded.day = tableView.tag
        
        let newDate = Calendar.current.date(byAdding: daysAdded, to: firstDate)!
        
        let monthSince = Calendar.current.dateComponents([.month], from: firstDate, to: newDate).month ?? 0
        
        let daySince = Calendar.current.dateComponents([.day], from: newDate).day ?? 0
        
        //filter out saved tasks for the displayed day
        let taskSaved = realm.objects(TaskSaved.self).filter("startMonth <= %@ AND startDay <= %@ AND endMonth >= %@ AND endDay >= %@", monthSince,daySince,monthSince,daySince)
        return taskSaved.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        editingPath = indexPath.row
        
        //haptic feedback
        var mediumGenerator: UIImpactFeedbackGenerator? = UIImpactFeedbackGenerator(style: .medium)
        mediumGenerator?.prepare()
        mediumGenerator?.impactOccurred()
        mediumGenerator = nil
        
        performSegue(withIdentifier: "newTask", sender: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension Planner: toPlannerFromTask{
    func deleteCell(location: Int) {
        let monthSince = Calendar.current.dateComponents([.month], from: firstDate, to: currentDateCell).month ?? 0
        
        let daySince = Calendar.current.dateComponents([.day], from: currentDateCell).day ?? 0
        
        //filter out saved tasks for the displayed day
        let taskSaved = realm.objects(TaskSaved.self).filter("startMonth <= %@ AND startDay <= %@ AND endMonth >= %@ AND endDay >= %@", monthSince,daySince,monthSince,daySince)[location]
        
        let alarmID = taskSaved.alarmID
        
        let center = UNUserNotificationCenter.current()
        
        //remove notification
        center.removePendingNotificationRequests(withIdentifiers: [alarmID])
        
        //delete task
        try! realm.write{
            realm.delete(taskSaved)
        }
        
        //reload data
        plannerCV.reloadData()
    }
    
    func taskDone(location: Int) {
        let monthSince = Calendar.current.dateComponents([.month], from: firstDate, to: currentDateCell).month ?? 0
        
        let daySince = Calendar.current.dateComponents([.day], from: currentDateCell).day ?? 0
        
        //filter out saved tasks for the displayed day
        let taskSaved = realm.objects(TaskSaved.self).filter("startMonth <= %@ AND startDay <= %@ AND endMonth >= %@ AND endDay >= %@", monthSince,daySince,monthSince,daySince)[location]
        
        //delete task
        try! realm.write{
            taskSaved.doneTasks.append(currentDateCell)
        }
    }
    
    func taskUndone(location: Int) {
        let monthSince = Calendar.current.dateComponents([.month], from: firstDate, to: currentDateCell).month ?? 0
        
        let daySince = Calendar.current.dateComponents([.day], from: currentDateCell).day ?? 0
        
        //filter out saved tasks for the displayed day
        let taskSaved = realm.objects(TaskSaved.self).filter("startMonth <= %@ AND startDay <= %@ AND endMonth >= %@ AND endDay >= %@", monthSince,daySince,monthSince,daySince)[location]
        
        //delete task
        try! realm.write{
            taskSaved.doneTasks.remove(at: taskSaved.doneTasks.firstIndex(of: currentDateCell)!)
        }
    }
    
    func disablePaging() {
        plannerCV.isScrollEnabled = false
    }
    
    func enablePaging() {
        plannerCV.isScrollEnabled = true
    }
}

extension Planner: changeDay{
    func goRight() {
        //if currently displayed cell isnt at the end
        if displayedCell + 1 <= 7304{
            plannerCV.scrollToItem(at: [0,displayedCell + 1], at: .centeredHorizontally, animated: true)
            displayedCell += 1
            
            //calculations to find what month and day it is
            var daysAdded = DateComponents()
            daysAdded.day = displayedCell
            
            currentDateCell = Calendar.current.date(byAdding: daysAdded, to: firstDate)!
        }
        
        let selectionGenerator = UISelectionFeedbackGenerator()
        selectionGenerator.selectionChanged()
        
        //update year
        updateYear()
    }
    func goLeft() {
        
        //if currently displayed cell isnt at the beginning
        if displayedCell - 1 >= 0{
            plannerCV.scrollToItem(at: [0,displayedCell - 1], at: .centeredHorizontally, animated: true)
            displayedCell -= 1
            
            //calculations to find what month and day it is
            var daysAdded = DateComponents()
            daysAdded.day = displayedCell
            
            currentDateCell = Calendar.current.date(byAdding: daysAdded, to: firstDate)!
        }
        
        let selectionGenerator = UISelectionFeedbackGenerator()
        selectionGenerator.selectionChanged()
        
        //update year
        updateYear()
    }
    
    //bring down calendar
    func bringDownCalendar() {
        let monthsSince = Calendar.current.dateComponents([.month], from: firstDate, to: currentDateCell).month ?? 0
        let daysSince = Calendar.current.dateComponents([.day], from: currentDateCell).day ?? 0
        
        delegate?.calendarDown(days: daysSince, months: monthsSince)
    }
    
    //register press of calendar
    func registerPress(day: Int, monthsSince: Int) {
        delegate?.calendarUp()
        var dateComponents = DateComponents()
        dateComponents.month = monthsSince
        dateComponents.day = day - 1
        
        //go to newdate
        let newDate = Calendar.current.date(byAdding: dateComponents, to: firstDate)!
        let daysSince = Calendar.current.dateComponents([.day], from: firstDate, to: newDate).day ?? 0
        
        displayedCell = daysSince
        plannerCV.scrollToItem(at: [0,daysSince], at: [.centeredHorizontally], animated: false)
        
        //calculations to find what month and day it is
        var daysAdded = DateComponents()
        daysAdded.day = displayedCell
        
        currentDateCell = Calendar.current.date(byAdding: daysAdded, to: firstDate)!
        
        //update year
        updateYear()
    }
}
