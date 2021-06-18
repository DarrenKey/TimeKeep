//
//  InitialVC.swift
//  Calendar
//
//  Created by Mi Yan on 12/23/19.
//  Copyright © 2019 Darren Key. All rights reserved.
//

import UIKit
import CoreData

class InitialVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var dateL: UILabel!
    
    @IBOutlet weak var blurringView: UIView!
    @IBOutlet weak var tutorialView: UIView!
    
    @IBOutlet weak var tutText: UILabel!
    
    @IBOutlet weak var arrowPointer: UIImageView!
    @IBOutlet weak var endView: UIView!
    
    @IBOutlet weak var tutCat: UIButton!
    @IBOutlet weak var tutStat: UIButton!
    @IBOutlet weak var tutTime: UIButton!
    
    var tutorialTracker = 0
    
    var hasLaunched = false
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var todayL: UILabel!
    
    var dateofVC: String = ""
    
    
    //right arrow pressed
    @IBAction func addDay(_ sender: Any) {
        
        let dateGiven = Singleton.selectedDate

        let newDate = Calendar.current.date(byAdding: .day, value: 1, to: dateGiven)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        
        //set bounds
        if dateFormatter.string(from: newDate!) != "January 1, 2040"{
            Singleton.dateTracker = dateFormatter.string(from: newDate!)
            Singleton.selectedDate = newDate!
            todayCheck()
            tableView.reloadData()
        }
        
    }
    
    
    
    // if left arrow pressed
    @IBAction func minusDay(_ sender: Any) {
        
        
        let dateGiven = Singleton.selectedDate

        let newDate = Calendar.current.date(byAdding: .day, value: -1, to: dateGiven)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        
        //set bounds
        if dateFormatter.string(from: newDate!) != "December 31, 2019"{
            Singleton.dateTracker = dateFormatter.string(from: newDate!)
            Singleton.selectedDate = newDate!
            todayCheck()
            tableView.reloadData()
        }
    }
    
    // check if today should be displayed + update text label
    func todayCheck(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        
        dateofVC = dateFormatter.string(from: Date())
        
        //singleton.datetracker is the current date of the main menu - the one the user is on
        if Singleton.dateTracker == dateofVC{
            todayL.isHidden = false
        }
        else{
            todayL.isHidden = true
        }
        dateL.text = Singleton.dateTracker
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        let screenHeight = UIScreen.main.bounds.height
        dateL.font = dateL.font.withSize(35 * screenHeight/842)
        todayL.font = todayL.font.withSize(40 * screenHeight/842)
        
        self.navigationController?.navigationBar.isHidden = true
        
        //remove view controllers
        
        var viewControllers = navigationController?.viewControllers
        viewControllers?.removeAll()
        
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.white.cgColor
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        
        dateofVC = dateFormatter.string(from: Date())
        
        //singleton.datetracker is the current date of the main menu - the one the user is on
        if Singleton.dateTracker == dateofVC{
            todayL.isHidden = false
        }
        else{
            todayL.isHidden = true
        }
        
        dateL.text = Singleton.dateTracker
        //dateL.sizeToFit()
        
        
        tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: endView.frame.origin.y - tableView.frame.origin.y - 5)
        
        tableView.rowHeight = tableView.frame.size.height/11
        
        
        //get haslaunched
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //fetch request
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "Categories")
    
        //parse and apply to Singleton
        do {
            let request = try managedContext.fetch(fetchRequest)
            if request.count == 0{
                hasLaunched = false
            }
            else{
                hasLaunched = true
            }
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        //if first launched, tutorial launched
        if hasLaunched == false{
            blurringView.isHidden = false
            arrowPointer.isHidden = false
            tutorialView.isHidden = false
            tutCat.isHidden = false
            tutText.text = "Create a category here"
            tutorialTracker += 1
            arrowPointer.frame = CGRect(x: tutCat.frame.origin.x + tutCat.frame.size.width/2 - arrowPointer.frame.size.width/2, y: tutorialView.frame.origin.y + tutorialView.frame.size.height - arrowPointer.frame.size.height/2, width: arrowPointer.frame.size.width, height: arrowPointer.frame.size.height)
        }
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if hasLaunched == false{
            
            //change from category to timer
            if tutorialTracker == 1{
                tutCat.isHidden = true
                tutTime.isHidden = false
                tutText.text = "Use categories to time your day"
                tutorialTracker += 1
                arrowPointer.frame = CGRect(x: tutTime.frame.origin.x + tutTime.frame.size.width/2 - arrowPointer.frame.size.width/2, y: tutorialView.frame.origin.y + tutorialView.frame.size.height - arrowPointer.frame.size.height/2 , width: arrowPointer.frame.size.width, height: arrowPointer.frame.size.height)
            }
            
            //change from timer to statistics
            else if tutorialTracker == 2{
                tutTime.isHidden = true
                tutStat.isHidden = false
                tutText.text = "View statistics about your day"
                tutorialTracker += 1
                arrowPointer.frame = CGRect(x: tutStat.frame.origin.x + tutStat.frame.size.width/2 - arrowPointer.frame.size.width/2, y: tutorialView.frame.origin.y + tutorialView.frame.size.height - arrowPointer.frame.size.height/2, width: arrowPointer.frame.size.width, height: arrowPointer.frame.size.height)
                
            }
                
            //get rid of everything
            else if tutorialTracker == 3{
                tutStat.isHidden = true
                tutorialView.isHidden = true
                
                arrowPointer.isHidden = true
                blurringView.isHidden = true
                tutorialView.isHidden = true
                
                Singleton.attributesN = ["Work","Rest"]
                tutorialTracker += 1
                let center = UNUserNotificationCenter.current()
               center.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {
                   (granted, error) in
                   if !granted{
                       
                       // alert which lets them know where to find settings
                       let alert = UIAlertController(title: "Enabling Notifications", message: "Notifications are needed for the alarm. You can turn on notifications in Settings -> Notifications at any time.", preferredStyle: .alert)
                       
                       alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                           alert.dismiss(animated: true, completion: nil)
                           
                       }))
                       
                       self.present(alert, animated: true, completion:  nil)
                   }
                       
               })
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.backgroundColor == .green{
            let undomarkAsCompleted = UIContextualAction(style: .normal, title: "Undo Mark As Completed", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                    let cell = tableView.cellForRow(at: indexPath)
                    cell?.backgroundColor = .white
                    Singleton.dayDict[Singleton.dateTracker]?[indexPath.row][8] = false
                          success(true)
                      })
            undomarkAsCompleted.backgroundColor = .red
            return UISwipeActionsConfiguration(actions: [undomarkAsCompleted])
        }
        else{
            let markAsCompleted = UIContextualAction(style: .normal, title: "Mark As Completed", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                let cell = tableView.cellForRow(at: indexPath)
                cell?.backgroundColor = .green
                Singleton.dayDict[Singleton.dateTracker]?[indexPath.row][8] = true
                    success(true)
                })
            markAsCompleted.backgroundColor = .green
            return UISwipeActionsConfiguration(actions: [markAsCompleted])
        }
    
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    @IBAction func touchedNewEvent(_ sender: Any) {
        performSegue(withIdentifier: "newEvent", sender: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Singleton.dayDict[Singleton.dateTracker] == nil{
            return 0
        }
        else{
            return Singleton.dayDict[Singleton.dateTracker]!.count
        }
    }
    
    //editing event
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            let template = Singleton.dayDict[Singleton.dateTracker]![indexPath.row]
            Singleton.dayDict[Singleton.dateTracker]?.remove(at: indexPath.row)
            //remove every single iteration
            
            let selectedRepeats = template[7] as! [IndexPath]
            let type = template[10] as! String
            //var isEqualArray = true

            if selectedRepeats[0] != [0,0]{
                
                
                //remove repetitions
                for (key, value) in Singleton.dayDict{
                    for x in 0..<value.count{
                        if value[x][9] as! String == template[9] as! String{
                            Singleton.dayDict[key]?.remove(at: x)
                        }
                    }
                }
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
                
            tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskC", for: indexPath) as! ColorCellinCategoryVC
        cell.backgroundColor = .white
        if tableView.numberOfRows(inSection: 0) != 0{
            if Singleton.dayDict[Singleton.dateTracker]?[indexPath.row][8] as! Bool == true{
                cell.backgroundColor = .green
            }
        }
        let labels = Singleton.dayDict[Singleton.dateTracker]![indexPath.row]
        cell.labelT.text = labels[0] as! String
        cell.insideCircle.tintColor = labels[3] as! UIColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editPathNum = indexPath.row
        //if the touch is in a cell
        if editPathNum < Singleton.dayDict[Singleton.dateTracker]?.count ?? -1{
            Singleton.pathOfCellEvent = editPathNum
            Singleton.isEditingEvent = true
            performSegue(withIdentifier: "newEvent", sender: nil)
            
            
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

}
