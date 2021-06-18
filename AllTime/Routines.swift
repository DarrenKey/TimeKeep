//
//  Routines.swift
//  TimeKeep
//
//  Created by Mi Yan on 4/9/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//

import UIKit
import BAFluidView
import RealmSwift

class Routines: UIViewController {

    @IBOutlet weak var newRoutineButton: UIButton!
    
    @IBOutlet weak var routineLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var tempHeight: CGFloat = 0
    
    //temp array to keep track of cells previously shown
    var alphaOfCells: [Int] = []
    
    //animate turn on
    //0 = first, 1 = is animating, 2 = after
    var isAnimating = 0
    
    var timer = Timer()
    
    //number of rows
    var rowNum = 0
    
    //variables for the beginning animation
    ///timers
    var fadingInAnimationTimer = Timer()
    var fillCellTimer = Timer()
    var preloadFillCellTimer = Timer()
    
    ///workaround to stop beginning animation
    var timerArray: [Timer] = []
    
    //resize
    var screenHeight: CGFloat = 0
    var screenWidth: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //standard delegate procedure
        tableView.delegate = self
        tableView.dataSource = self
        
        //start realm
        let realm = try! Realm()
        //call routine from realms
        let routineRealm = realm.objects(Routine.self)
        
        rowNum = routineRealm.count
        
        for _ in 0..<rowNum{
            alphaOfCells.append(0)
        }
        
        let screen = UIScreen.main.bounds
        screenWidth = screen.size.width
        screenHeight = screen.size.height
        
        resizeDevice()
        
        //if tapped once - skip tableview animation
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tableViewTapped(sender:)))
        tableView.addGestureRecognizer(tapGestureRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    //get when application is in focus
    @objc func applicationForeground(){
        viewDidAppear(false)
    }
    
    @IBAction func newRoutinePressed(_ sender: Any) {
        var mediumGenerator: UIImpactFeedbackGenerator? = UIImpactFeedbackGenerator(style: .medium)
        mediumGenerator?.prepare()
        mediumGenerator?.impactOccurred()
        mediumGenerator = nil
    }
    
    //resize manually
    func resizeDevice(){
        if screenWidth == 375 && screenHeight == 812{
            routineLabel.font = routineLabel.font.withSize(35)
            routineLabel.frame = CGRect(x: 24, y: 77, width: 175, height: 46)
            
            tableView.frame = CGRect(x: 0, y: 156, width: 375, height: 500)
            
            newRoutineButton.frame = CGRect(x: 305, y: 666, width: 46, height: 46)
        }
        else if screenWidth == 414 && screenHeight == 736{
            routineLabel.frame = CGRect(x: 24, y: 50, width: 200, height: 52)
            
            tableView.frame = CGRect(x: 0, y: 132, width: 414, height: 462)
            
            newRoutineButton.frame = CGRect(x: 348, y: 609, width: 42, height: 42)
        }
        else if screenWidth == 375 && screenHeight == 667{
            routineLabel.font = routineLabel.font.withSize(35)
            routineLabel.frame = CGRect(x: 24, y: 50, width: 175, height: 46)
            
            tableView.frame = CGRect(x: 0, y: 126, width: 375, height: 400)
            
            newRoutineButton.frame = CGRect(x: 311, y: 546, width: 40, height: 40)
        }
        else if screenWidth == 320 && screenHeight == 568{
            routineLabel.font = routineLabel.font.withSize(30)
            routineLabel.frame = CGRect(x: 24, y: 40, width: 150, height: 39)
            
            tableView.frame = CGRect(x: 0, y: 99, width: 320, height: 360)
            
            newRoutineButton.frame = CGRect(x: 264, y: 467, width: 32, height: 32)
        }
        else if screenWidth == 768 && screenHeight == 1024{
            routineLabel.font = routineLabel.font.withSize(50)
            routineLabel.frame = CGRect(x: 24, y: 60, width: 250, height: 65)
            
            tableView.frame = CGRect(x: 0, y: 165, width: 768, height: 676)
            
            newRoutineButton.frame = CGRect(x: 683, y: 852, width: 61, height: 61)
        }
        else if screenWidth == 834 && screenHeight == 1194{
            routineLabel.font = routineLabel.font.withSize(65)
            routineLabel.frame = CGRect(x: 24, y: 50, width: 325, height: 85)
            
            tableView.frame = CGRect(x: 0, y: 165, width: 834, height: 750)
            
            newRoutineButton.frame = CGRect(x: 735, y: 952, width: 75, height: 75)
        }
        else if screenWidth == 834 && screenHeight == 1112{
            routineLabel.font = routineLabel.font.withSize(65)
            routineLabel.frame = CGRect(x: 24, y: 50, width: 325, height: 85)
            
            tableView.frame = CGRect(x: 0, y: 165, width: 834, height: 720)
            
            newRoutineButton.frame = CGRect(x: 735, y: 906, width: 75, height: 75)
        }
        else if screenWidth == 810 && screenHeight == 1080{
            routineLabel.font = routineLabel.font.withSize(65)
            routineLabel.frame = CGRect(x: 24, y: 50, width: 325, height: 85)
            
            tableView.frame = CGRect(x: 0, y: 165, width: 810, height: 696)
            
            newRoutineButton.frame = CGRect(x: 717, y: 881, width: 69, height: 69)
        }
        else if screenWidth == 1024 && screenHeight == 1366{
            routineLabel.font = routineLabel.font.withSize(75)
            routineLabel.frame = CGRect(x: 24, y: 60, width: 375, height: 98)
            
            tableView.frame = CGRect(x: 0, y: 198, width: 1024, height: 890)
            
            newRoutineButton.frame = CGRect(x: 902, y: 1108, width: 98, height: 98)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tableViewTapped()
    }
    
    @objc func tableViewTapped(sender: UITapGestureRecognizer? = nil){
        isAnimating = 2
        tableView.isScrollEnabled = true
        
        //stop animations
        timer.invalidate()
        fadingInAnimationTimer.invalidate()
        
        //set alphas to 0
        for i in 0..<rowNum{
            alphaOfCells[i] = 1
        }
        
        //get indexpath to reload rows
        for i in tableView.indexPathsForVisibleRows ?? []{
            let routineCell = tableView.cellForRow(at: i) as! RoutineCell
            
            preloadFillCell(routineCell: routineCell, indexRow: i.row)
            fillCell(routineCellPrevious: routineCell, indexRow: i.row)
            
            routineCell.routineView.alpha = 1
        }
    }
    
    //animation for tableview
    override func viewDidAppear(_ animated: Bool){
        //update routines
        
        //start realm
        let realm = try! Realm()
        
        //call routine from realms
        let routineRealm = realm.objects(Routine.self)
        
        //start of day and end of day
        let startOfTheDay = Calendar.current.startOfDay(for: Date())
        let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfTheDay)!
        
        //for each routine
        for indexNum in 0..<routineRealm.count{
            
            let routine = routineRealm[indexNum]
            
            //adjust only if it is based on time
            if routine.type == "Time"{
                var totalTime: Double = 0
                
                //for each stored date in the routine
                for routineDate in 0..<routine.time.count/2{
                    
                    //if both times in between date
                    if routine.time[routineDate * 2].isBetween(startOfTheDay, and: nextDay) && routine.time[routineDate * 2 + 1].isBetween(startOfTheDay, and: nextDay){
                        totalTime += routine.time[routineDate * 2 + 1].timeIntervalSince(routine.time[routineDate * 2])
                    }
                    
                    //if first time before date
                    else if routine.time[routineDate * 2 + 1].isBetween(startOfTheDay, and: nextDay){
                        totalTime += routine.time[routineDate * 2 + 1].timeIntervalSince(startOfTheDay)
                   }
                    
                    //if second time after date
                    else if routine.time[routineDate * 2].isBetween(startOfTheDay, and: nextDay){
                        totalTime += nextDay.timeIntervalSince(routine.time[routineDate * 2])
                   }
                }
                
                //if routine has a time not ended - create another one with current date
                if routine.time.count % 2 == 1{
                    if Date().isBetween(startOfTheDay, and: nextDay) && routine.time.last!.isBetween(startOfTheDay, and: nextDay){
                        totalTime += Date().timeIntervalSince(routine.time.last!)
                    }

                     //if first time before date
                     else if Date().isBetween(startOfTheDay, and: nextDay){
                        totalTime += Date().timeIntervalSince(startOfTheDay)
                    }
                     
                     //if second time after date
                    else if  routine.time.last!.isBetween(startOfTheDay, and: nextDay){
                        totalTime += nextDay.timeIntervalSince(routine.time.last!)
                    }
                    
                }
                
                //update numCompleted
                try! realm.write {
                    routine.numCompleted = Int(totalTime/60)
                }
            }
        }
        
        //set animation to true and disable user interaction if it is not currently animating
        if isAnimating != 1 && rowNum > 0{
            isAnimating = 1
            tableView.isScrollEnabled = false
            timerArray = []
            
            currentIndex = 0
            maxShown = 4
            
            //set alphas to 0
            for i in 0..<rowNum{
                alphaOfCells[i] = 0
            }
            
            tableView.reloadData()
            
            rowNum = tableView.numberOfRows(inSection: 0)
            
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        
            //start timer
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(animateScroll), userInfo: nil, repeats: true)
        }
        else if rowNum == 0{
            isAnimating = 2
        }
    }

    //animate a scroll per second
    var currentIndex: Int = 0
    var maxShown: Int = 4
    
    @objc func animateScroll(){
        
        if currentIndex == maxShown && currentIndex + 1 < rowNum{
            maxShown += 1
            self.tableView.scrollToRow(at: IndexPath(row: currentIndex + 1, section: 0), at: .bottom, animated: true)
        }
        
        let routineCell = tableView.cellForRow(at: [0,currentIndex]) as! RoutineCell
        
        if currentIndex < 5{
            fadingInAnimation(routineCellC: routineCell, rowNum: self.currentIndex)
            preloadFillCell(routineCell: routineCell, indexRow: self.currentIndex)
            
            let tempNum = self.currentIndex
            fillCellTimer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false) { (nil) in
                
                self.fillCell(routineCellPrevious: routineCell, indexRow: tempNum)
            }
            RunLoop.current.add(fillCellTimer, forMode: .common)
        }
        else{
            fadingInAnimation(routineCellC: routineCell, rowNum: self.currentIndex)
            preloadFillCell(routineCell: routineCell, indexRow: self.currentIndex)
            
            let tempNum = self.currentIndex
            fillCellTimer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false) { (nil) in
                self.fillCell(routineCellPrevious: routineCell, indexRow: tempNum)
            }
            RunLoop.current.add(fillCellTimer, forMode: .common)
        }
        
        //last one
        if currentIndex == rowNum - 1{
            isAnimating = 2
            tableView.isScrollEnabled = true
            timer.invalidate()
        }
        
        currentIndex += 1
    }
    
    //on tap - either increase or go to stopwatch
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        
        //skip animation
        if isAnimating == 1{
            tableViewTapped()
        }
        else{
        
            //indexNum is indexPath
            let indexNum = gesture.view!.tag
            
            //start realm
            let realm = try! Realm()
            
            //call category from realms
            let routineRealm = realm.objects(Routine.self)[indexNum]
            
            let routineCell = tableView.cellForRow(at: IndexPath(row: indexNum, section: 0)) as! RoutineCell
            //if amount - increase by one
            if routineRealm.type == "Amount"{
                if routineRealm.numCompleted == 0{

                    routineCell.fluidView.fillDuration = 1
                    routineCell.fluidView.fillRepeatCount = 1
                    routineCell.fluidView.fillAutoReverse = false
                }
                
                //increase amount by one
                try! realm.write {
                    routineRealm.numCompleted += 1
                }
                
                //increase numCompleted of the label
                routineCell.numCompleted.text = "\(routineRealm.numCompleted) times"
                
                routineCell.fluidView.isHidden = false
                routineCell.fluidView.fill(to: NSNumber(value: min(Double(routineRealm.numCompleted)/Double(routineRealm.goal),Double(0.999))))
            }
        }
    }

}

//tableview setup
extension Routines: UITableViewDelegate, UITableViewDataSource{
    
    //Basic TableView setup
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowNum
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoutineCell") as! RoutineCell
        
        //start realm
        let realm = try! Realm()
        
        //call category from realms
        let routineRealm = realm.objects(Routine.self)[indexPath.row]
        
        cell.routineView.alpha = CGFloat(alphaOfCells[indexPath.row])
        
        //change label text
        cell.nameLabel.text = routineRealm.name
        cell.categoryLabel.text = "Category: \(routineRealm.categoryName)"
        
        //update numCompleted based on day
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM/dd/yyyy"
        
        if dateFormat.string(from: Date()) != routineRealm.currentDay{
            //update the date and set numCompleted back to 0
            try! realm.write{
                routineRealm.currentDay = dateFormat.string(from: Date())
                
                routineRealm.numCompleted = 0
            }
        }
        
        //change number indicators on right depending on type
        if routineRealm.type == "Time"{
            //num completed
            //conversion to hrs and mins
            var tempNum = ""
            if routineRealm.numCompleted >= 60{
                tempNum += "\(Int(routineRealm.numCompleted/60)) hr "
            }
            if routineRealm.numCompleted % 60 > 0{
                tempNum += "\(routineRealm.numCompleted % 60) mins"
            }
            if routineRealm.numCompleted == 0{
                tempNum += "0 mins"
            }
            cell.numCompleted.text = tempNum
            
            //goal
            tempNum = ""
            if routineRealm.goal >= 60{
                tempNum += "\(Int(routineRealm.goal/60)) hr "
            }
            if routineRealm.goal % 60 > 0{
                tempNum += "\(routineRealm.goal % 60) mins"
            }
            if routineRealm.goal == 0{
                tempNum += "0 mins"
            }
            cell.goalNumLabel.text = tempNum
        }
        else if routineRealm.type == "Amount"{
            cell.numCompleted.text = "\(routineRealm.numCompleted) times"
            
            cell.goalNumLabel.text = "\(routineRealm.goal) times"
        }
        
        //resize label and everything else pretty much
        
        //only for XR
        if screenWidth == 414 && screenHeight == 896{
            cell.nameLabel.frame = CGRect(x: 10, y: 8, width: 250, height: 39)
            cell.categoryLabel.frame = CGRect(x: 10, y: 63, width: 250, height: 16)
        }
        else if screenWidth == 414 && screenHeight == 736{
            cell.routineView.frame = CGRect(x: 24, y: 5, width: 366, height: 67)
            
            cell.nameLabel.font = cell.nameLabel.font.withSize(25)
            cell.nameLabel.frame = CGRect(x: 5, y: 5, width: 265, height: 33)
            
            cell.categoryLabel.font = cell.categoryLabel.font.withSize(12)
            cell.categoryLabel.frame = CGRect(x: 5, y: 46, width: 265, height: 16)
            
            cell.numCompleted.font = cell.numCompleted.font.withSize(12)
            cell.numCompleted.frame = CGRect(x: 275, y: 11.5, width: 86, height: 16)
            
            cell.seperatorView.frame = CGRect(x: 303, y: 32.5, width: 30, height: 2)
            
            cell.goalNumLabel.font = cell.numCompleted.font.withSize(12)
            cell.goalNumLabel.frame = CGRect(x: 275, y: 39.5, width: 86, height: 16)
            
            cell.trashCanImage.frame.size = CGSize(width: 40, height: 45)
            
            cell.wobbleView.frame.size.width = 70
            cell.deleteButton.frame.size.width = 70
        }
        else if screenWidth == 375 && screenHeight == 812{
            cell.routineView.frame = CGRect(x: 24, y: 8, width: 327, height: 84)
            
            cell.nameLabel.font = cell.nameLabel.font.withSize(30)
            cell.nameLabel.frame = CGRect(x: 10, y: 10, width: 222, height: 39)
            
            cell.categoryLabel.font = cell.categoryLabel.font.withSize(12)
            cell.categoryLabel.frame = CGRect(x: 10, y: 58, width: 222, height: 16)
            
            cell.numCompleted.font = cell.numCompleted.font.withSize(12)
            cell.numCompleted.frame = CGRect(x: 242, y: 17, width: 75, height: 16)
            
            cell.seperatorView.frame = CGRect(x: 257, y: 41, width: 45, height: 2)
            
            cell.goalNumLabel.font = cell.numCompleted.font.withSize(12)
            cell.goalNumLabel.frame = CGRect(x: 242, y: 51, width: 75, height: 16)
            
            cell.trashCanImage.frame.size = CGSize(width: 33, height: 40)
            cell.wobbleView.frame.size.width = 60
            cell.deleteButton.frame.size.width = 60
        }
        else if screenWidth == 375 && screenHeight == 667{
            cell.routineView.frame = CGRect(x: 24, y: 5, width: 327, height: 70)
            
            cell.nameLabel.font = cell.nameLabel.font.withSize(20)
            cell.nameLabel.frame = CGRect(x: 10, y: 10, width: 250, height: 26)
            
            cell.categoryLabel.font = cell.categoryLabel.font.withSize(10)
            cell.categoryLabel.frame = CGRect(x: 10, y: 47, width: 250, height: 13)
            
            cell.numCompleted.font = cell.numCompleted.font.withSize(12)
            cell.numCompleted.frame = CGRect(x: 265, y: 10, width: 52, height: 20)
            
            cell.seperatorView.frame = CGRect(x: 276, y: 34.5, width: 30, height: 1)
            
            cell.goalNumLabel.font = cell.numCompleted.font.withSize(12)
            cell.goalNumLabel.frame = CGRect(x: 265, y: 40, width: 52, height: 20)
            
            cell.trashCanImage.frame.size = CGSize(width: 33, height: 40)
            cell.wobbleView.frame.size.width = 60
            cell.deleteButton.frame.size.width = 60
        }
        else if screenWidth == 320 && screenHeight == 568{
            cell.routineView.frame = CGRect(x: 24, y: 5, width: 272, height: 50)
            
            cell.nameLabel.font = cell.nameLabel.font.withSize(18)
            cell.nameLabel.frame = CGRect(x: 5, y: 5, width: 212, height: 24)
            
            cell.categoryLabel.font = cell.categoryLabel.font.withSize(8)
            cell.categoryLabel.frame = CGRect(x: 5, y: 34, width: 212, height: 11)
            
            cell.numCompleted.font = cell.numCompleted.font.withSize(10)
            cell.numCompleted.frame = CGRect(x: 222, y: 8, width: 45, height: 13)
            
            cell.seperatorView.frame = CGRect(x: 232, y: 24.5, width: 25, height: 1)
            
            cell.goalNumLabel.font = cell.numCompleted.font.withSize(10)
            cell.goalNumLabel.frame = CGRect(x: 222, y: 29, width: 45, height: 13)
            
            cell.trashCanImage.frame.size = CGSize(width: 34, height: 39)
            cell.wobbleView.frame.size.width = 50
            cell.deleteButton.frame.size.width = 50
        }
        else if screenWidth == 768 && screenHeight == 1024{
            cell.routineView.frame = CGRect(x: 24, y: 8, width: 720, height: 97)
            
            cell.nameLabel.font = cell.nameLabel.font.withSize(35)
            cell.nameLabel.frame = CGRect(x: 10, y: 10, width: 573, height: 46)
            
            cell.categoryLabel.font = cell.categoryLabel.font.withSize(15)
            cell.categoryLabel.frame = CGRect(x: 10, y: 67, width: 573, height: 20)
            
            cell.numCompleted.font = cell.numCompleted.font.withSize(15)
            cell.numCompleted.frame = CGRect(x: 593, y: 22, width: 117, height: 20)
            
            cell.seperatorView.frame = CGRect(x: 629, y: 47, width: 45, height: 2)
            
            cell.goalNumLabel.font = cell.numCompleted.font.withSize(15)
            cell.goalNumLabel.frame = CGRect(x: 593, y: 54, width: 119, height: 20)
        }
        else if screenWidth == 834 && screenHeight == 1194{
            cell.routineView.frame = CGRect(x: 24, y: 8, width: 786, height: 109)
            
            cell.nameLabel.font = cell.nameLabel.font.withSize(40)
            cell.nameLabel.frame = CGRect(x: 10, y: 10, width: 667, height: 52)
            
            cell.categoryLabel.font = cell.categoryLabel.font.withSize(20)
            cell.categoryLabel.frame = CGRect(x: 10, y: 73, width: 667, height: 20)
            
            cell.numCompleted.font = cell.numCompleted.font.withSize(15)
            cell.numCompleted.frame = CGRect(x: 687, y: 26, width: 89, height: 20)
            
            cell.seperatorView.frame = CGRect(x: 709, y: 54, width: 45, height: 2)
            
            cell.goalNumLabel.font = cell.numCompleted.font.withSize(15)
            cell.goalNumLabel.frame = CGRect(x: 687, y: 64, width: 89, height: 20)
        }
        else if screenWidth == 834 && screenHeight == 1112{
            cell.routineView.frame = CGRect(x: 24, y: 8, width: 786, height: 104)
            
            cell.nameLabel.font = cell.nameLabel.font.withSize(40)
            cell.nameLabel.frame = CGRect(x: 10, y: 10, width: 667, height: 52)
            
            cell.categoryLabel.font = cell.categoryLabel.font.withSize(15)
            cell.categoryLabel.frame = CGRect(x: 10, y: 74, width: 667, height: 20)
            
            cell.numCompleted.font = cell.numCompleted.font.withSize(15)
            cell.numCompleted.frame = CGRect(x: 687, y: 26, width: 89, height: 20)
            
            cell.seperatorView.frame = CGRect(x: 709, y: 54, width: 45, height: 2)
            
            cell.goalNumLabel.font = cell.numCompleted.font.withSize(15)
            cell.goalNumLabel.frame = CGRect(x: 687, y: 64, width: 89, height: 20)
        }
        else if screenWidth == 810 && screenHeight == 1080{
            cell.routineView.frame = CGRect(x: 24, y: 8, width: 762, height: 100)
            
            cell.nameLabel.font = cell.nameLabel.font.withSize(37)
            cell.nameLabel.frame = CGRect(x: 10, y: 10, width: 643, height: 49)
            
            cell.categoryLabel.font = cell.categoryLabel.font.withSize(15)
            cell.categoryLabel.frame = CGRect(x: 10, y: 70, width: 643, height: 20)
            
            cell.numCompleted.font = cell.numCompleted.font.withSize(15)
            cell.numCompleted.frame = CGRect(x: 663, y: 21, width: 89, height: 20)
            
            cell.seperatorView.frame = CGRect(x: 685, y: 49, width: 45, height: 2)
            
            cell.goalNumLabel.font = cell.numCompleted.font.withSize(15)
            cell.goalNumLabel.frame = CGRect(x: 663, y: 59, width: 89, height: 20)
        }
        else if screenWidth == 1024 && screenHeight == 1366{
            cell.routineView.frame = CGRect(x: 24, y: 15, width: 976, height: 148)
            
            cell.nameLabel.font = cell.nameLabel.font.withSize(55)
            cell.nameLabel.frame = CGRect(x: 15, y: 15, width: 770, height: 72)
            
            cell.categoryLabel.font = cell.categoryLabel.font.withSize(25)
            cell.categoryLabel.frame = CGRect(x: 15, y: 100, width: 770, height: 33)
            
            cell.numCompleted.font = cell.numCompleted.font.withSize(25)
            cell.numCompleted.frame = CGRect(x: 801, y: 30, width: 160, height: 33)
            
            cell.seperatorView.frame = CGRect(x: 846, y: 73, width: 70, height: 2)
            
            cell.goalNumLabel.font = cell.numCompleted.font.withSize(25)
            cell.goalNumLabel.frame = CGRect(x: 801, y: 85, width: 160, height: 33)
        }

        cell.nameLabel.sizeToFit()
        cell.categoryLabel.sizeToFit()
        
        //only for XR
        if screenWidth == 414 && screenHeight == 896{
            cell.categoryLabel.frame.origin.y = cell.nameLabel.frame.origin.y + cell.nameLabel.frame.size.height + 16
            
            tempHeight = cell.nameLabel.frame.size.height + cell.categoryLabel.frame.size.height + 35
        }
        else if screenWidth == 414 && screenHeight == 736{
            cell.categoryLabel.frame.origin.y = cell.nameLabel.frame.origin.y + cell.nameLabel.frame.size.height + 8
            
            tempHeight = cell.nameLabel.frame.size.height + cell.categoryLabel.frame.size.height + 18
        }
        else if screenWidth == 375 && screenHeight == 812{
            cell.categoryLabel.frame.origin.y = cell.nameLabel.frame.origin.y + cell.nameLabel.frame.size.height + 9
            
            tempHeight = cell.nameLabel.frame.size.height + cell.categoryLabel.frame.size.height + 29
        }
        else if screenWidth == 375 && screenHeight == 667{
            cell.categoryLabel.frame.origin.y = cell.nameLabel.frame.origin.y + cell.nameLabel.frame.size.height + 11
            
            tempHeight = cell.nameLabel.frame.size.height + cell.categoryLabel.frame.size.height + 31
        }
        else if screenWidth == 320 && screenHeight == 568{
            cell.categoryLabel.frame.origin.y = cell.nameLabel.frame.origin.y + cell.nameLabel.frame.size.height + 5
            
            tempHeight = cell.nameLabel.frame.size.height + cell.categoryLabel.frame.size.height + 15
        }
        else if screenWidth == 768 && screenHeight == 1024{
            cell.categoryLabel.frame.origin.y = cell.nameLabel.frame.origin.y + cell.nameLabel.frame.size.height + 5
            
            tempHeight = cell.nameLabel.frame.size.height + cell.categoryLabel.frame.size.height + 25
        }
        else if screenWidth == 834 && screenHeight == 1194{
            cell.categoryLabel.frame.origin.y = cell.nameLabel.frame.origin.y + cell.nameLabel.frame.size.height + 11
            
            tempHeight = cell.nameLabel.frame.size.height + cell.categoryLabel.frame.size.height + 31
        }
        else if screenWidth == 834 && screenHeight == 1112{
            cell.categoryLabel.frame.origin.y = cell.nameLabel.frame.origin.y + cell.nameLabel.frame.size.height + 12
            
            tempHeight = cell.nameLabel.frame.size.height + cell.categoryLabel.frame.size.height + 32
        }
        else if screenWidth == 810 && screenHeight == 1080{
            cell.categoryLabel.frame.origin.y = cell.nameLabel.frame.origin.y + cell.nameLabel.frame.size.height + 11
            
            tempHeight = cell.nameLabel.frame.size.height + cell.categoryLabel.frame.size.height + 31
        }
        else if screenWidth == 1024 && screenHeight == 1366{
            cell.categoryLabel.frame.origin.y = cell.nameLabel.frame.origin.y + cell.nameLabel.frame.size.height + 13
            
            tempHeight = cell.nameLabel.frame.size.height + cell.categoryLabel.frame.size.height + 43
        }
        
        //resize everything else
        cell.routineView.frame.size.height = tempHeight
        
        cell.seperatorView.frame.origin.y = cell.routineView.frame.size.height/2 - 1
        
        //8 only for XR
        //only for XR
        if screenWidth == 414 && screenHeight == 896{
            cell.numCompleted.frame.origin.y = cell.seperatorView.frame.origin.y - (8 + cell.numCompleted.frame.size.height)
            cell.goalNumLabel.frame.origin.y = cell.seperatorView.frame.origin.y + 8
        }
        else if screenWidth == 414 && screenHeight == 736{
            cell.numCompleted.frame.origin.y = cell.seperatorView.frame.origin.y - (8 + cell.numCompleted.frame.size.height)
            cell.goalNumLabel.frame.origin.y = cell.seperatorView.frame.origin.y + 8
        }
        else if screenWidth == 375 && screenHeight == 812{
            cell.numCompleted.frame.origin.y = cell.seperatorView.frame.origin.y - (8 + cell.numCompleted.frame.size.height)
            cell.goalNumLabel.frame.origin.y = cell.seperatorView.frame.origin.y + 8
        }
        else if screenWidth == 375 && screenHeight == 667{
            cell.numCompleted.frame.origin.y = cell.seperatorView.frame.origin.y - (3 + cell.numCompleted.frame.size.height)
            cell.goalNumLabel.frame.origin.y = cell.seperatorView.frame.origin.y + 3
        }
        else if screenWidth == 320 && screenHeight == 568{
            cell.numCompleted.frame.origin.y = cell.seperatorView.frame.origin.y - (3 + cell.numCompleted.frame.size.height)
            cell.goalNumLabel.frame.origin.y = cell.seperatorView.frame.origin.y + 3
        }
        else if screenWidth == 768 && screenHeight == 1024{
            cell.numCompleted.frame.origin.y = cell.seperatorView.frame.origin.y - (5 + cell.numCompleted.frame.size.height)
            cell.goalNumLabel.frame.origin.y = cell.seperatorView.frame.origin.y + 5
        }
        else if screenWidth == 834 && screenHeight == 1194{
            cell.numCompleted.frame.origin.y = cell.seperatorView.frame.origin.y - (8 + cell.numCompleted.frame.size.height)
            cell.goalNumLabel.frame.origin.y = cell.seperatorView.frame.origin.y + 8
        }
        else if screenWidth == 834 && screenHeight == 1112{
            cell.numCompleted.frame.origin.y = cell.seperatorView.frame.origin.y - (8 + cell.numCompleted.frame.size.height)
            cell.goalNumLabel.frame.origin.y = cell.seperatorView.frame.origin.y + 8
        }
        else if screenWidth == 810 && screenHeight == 1080{
            cell.numCompleted.frame.origin.y = cell.seperatorView.frame.origin.y - (8 + cell.numCompleted.frame.size.height)
            cell.goalNumLabel.frame.origin.y = cell.seperatorView.frame.origin.y + 8
        }
        else if screenWidth == 1024 && screenHeight == 1366{
            cell.numCompleted.frame.origin.y = cell.seperatorView.frame.origin.y - (10 + cell.numCompleted.frame.size.height)
            cell.goalNumLabel.frame.origin.y = cell.seperatorView.frame.origin.y + 10
        }
        
        //background view
        cell.baseView.frame = CGRect(x: 0, y: 0, width: cell.routineView.frame.size.width, height: cell.routineView.frame.size.height)
        
        //set wobbleview and delete button
        cell.wobbleView.frame.size.height = cell.routineView.frame.size.height
        cell.deleteButton.frame.size.height = cell.routineView.frame.size.height
        
        //center trashcanicon
        cell.trashCanImage.frame.origin.y = cell.wobbleView.frame.size.height/2 - cell.trashCanImage.frame.size.height/2
        
        cell.trashCanImage.frame.origin.x = cell.routineView.frame.size.width + cell.wobbleView.frame.size.width/2 - cell.trashCanImage.frame.size.width/2
        
        //position wobbleView
        
        cell.wobbleView.frame.origin = CGPoint(x: cell.routineView.frame.size.width, y: 0)
        
        cell.wobbleView.positionChanged()
        
        cell.wobbleView.reset()
        
        //delete delegate
        cell.delegate = self
        
        //hide fluidView
        cell.fluidView.isHidden = true
        
        cell.routineView.tag = indexPath.row
        
        //THIS WORKS AND I DONT KNOW WHY. DONT TOUCH IT
        
        //rotate fluid view
        cell.fluidView.transform = CGAffineTransform(rotationAngle: 3 * .pi/2)
        cell.fluidView.frame.origin = CGPoint(x: 0, y: 0)
        cell.fluidView.frame.size = cell.routineView.frame.size
        
        //on tap - either increase or go to stopwatch
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        cell.routineView.addGestureRecognizer(tap)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let routineCell = cell as! RoutineCell
        if isAnimating == 2{

            preloadFillCell(routineCell: routineCell, indexRow: indexPath.row)
            
            fillCellTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { (nil) in
                self.fillCell(routineCellPrevious: routineCell, indexRow: indexPath.row)
            }
            RunLoop.current.add(fillCellTimer, forMode: .common)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //come in animation
    func fadingInAnimation(routineCellC: RoutineCell, rowNum: Int){
        //only for XR
        routineCellC.routineView.frame.origin = CGPoint(x: -366, y: 8)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.25, options: .curveEaseOut, animations: {
            routineCellC.routineView.frame.origin = CGPoint(x: 24, y: 8)
        }, completion: nil)
        UIView.animate(withDuration: 0.5, animations: {
            routineCellC.routineView.alpha = 1
        },completion: {_ in
            self.alphaOfCells[rowNum] = 1
        })
    }
    
    func preloadFillCell(routineCell: RoutineCell, indexRow: Int){
        //start realm
        let realm = try! Realm()
        
        //call category from realms
        let routineRealm = realm.objects(Routine.self)
        
        let currentRoutine = routineRealm[indexRow]
        
        routineCell.fluidView.isHidden = true
        
        routineCell.fluidView.fillDuration = 0
        routineCell.fluidView.fill(to: 0)
        
        routineCell.fluidView.minAmplitude = 5
        routineCell.fluidView.maxAmplitude = 15
        routineCell.fluidView.strokeColor = UIColor(hue: CGFloat(currentRoutine.h), saturation: CGFloat(currentRoutine.s), brightness: CGFloat(currentRoutine.b), alpha: 0.4)
        routineCell.fluidView.fillColor = UIColor(hue: CGFloat(currentRoutine.h), saturation: CGFloat(currentRoutine.s), brightness: CGFloat(currentRoutine.b), alpha: 0.4)
    }
    
    //fill cell animation
    func fillCell(routineCellPrevious: RoutineCell, indexRow: Int){
        //start realm
        let realm = try! Realm()
        //call routine from realms
        let routineRealm = realm.objects(Routine.self)
        
        let currentRoutine = routineRealm[indexRow]
        
        //if nothing completed, don't animate anything!
        if currentRoutine.numCompleted == 0{
            return
        }
        
        
        //settings
        routineCellPrevious.fluidView.minAmplitude = 5
        routineCellPrevious.fluidView.maxAmplitude = 15
        
        routineCellPrevious.fluidView.fillDuration = 1
        routineCellPrevious.fluidView.fillRepeatCount = 1
        routineCellPrevious.fluidView.fillAutoReverse = false
        routineCellPrevious.fluidView.fill(to: NSNumber(value: min(Double(currentRoutine.numCompleted)/Double(currentRoutine.goal),Double(0.999))))
        routineCellPrevious.fluidView.startAnimation()
        
        
        routineCellPrevious.fluidView.isHidden = false
    }
    
    //height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //+ 16 only for XR
        if screenHeight == 667 && screenWidth == 375{
            return tempHeight + 10
        }
        else if screenHeight == 568 && screenWidth == 320{
            return tempHeight + 10
        }
        else if screenHeight == 736 && screenWidth == 414{
            return tempHeight + 10
        }
        else if screenHeight == 768 && screenWidth == 1024{
            return tempHeight + 25
        }
        else if screenHeight == 834 && screenWidth == 1194{
            return tempHeight + 16
        }
        else if screenHeight == 834 && screenWidth == 1112{
            return tempHeight + 16
        }
        else if screenHeight == 810 && screenWidth == 1080{
            return tempHeight + 16
        }
        else if screenHeight == 1024 && screenWidth == 1366{
            return tempHeight + 30
        }
        return tempHeight + 16
    }
    
    @IBAction func unwindToRoutines(_ sender: UIStoryboardSegue){
    }
    
}

extension Routines: CategoryCellDelegate{
    func deletePressed(tag: Int) {
        let cell = tableView.cellForRow(at: [0,tag]) as! RoutineCell
        
        
        //reset view locations -- only for iPhone XR
        cell.baseView.frame.origin = CGPoint(x: 0, y: 0)
        cell.wobbleView.frame.origin = CGPoint(x: cell.routineView.frame.size.width, y: 0)
        
        //start realm
        let realm = try! Realm()
        
        //call routine from realms
        let routineRealm = realm.objects(Routine.self)
        
        //delete routine
        try! realm.write{
            realm.delete(routineRealm[tag])
        }
        
        rowNum -= 1
        
        tableView.reloadData()
    }
    func startScroll() {
        tableView.isScrollEnabled = true
    }
    func stopScroll() {
        tableView.isScrollEnabled = false
    }
}
