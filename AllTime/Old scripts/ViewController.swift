//
//  ViewController.swift
//  Calendar
//
//  Created by Mi Yan on 10/31/19.
//  Copyright © 2019 Darren Key. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    //00:00:00 layout
    var secondC = 0
    var minC = 0
    var hourC = 0
    
    
    //number of categories
    var categoryN = 0
    
    
    //timer
    var timer = Timer()
    
    
    //Drop down menu
    @IBOutlet weak var viewofB: UIView!
    
    @IBOutlet weak var dropDownB: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var triangle: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var radiusballCalculation: UIImageView!
    
    //Stopwatch Animation
    
    @IBOutlet weak var ballS: UIImageView!
    
    @IBOutlet weak var animateV: UIView!
    
    @IBOutlet weak var outerCircle: UIImageView!
    
    //Timer Label
    @IBOutlet weak var timerB: UILabel!

    
    
    //date variables for when user exits + enters app
    var dateWhenActive = Date()
    
    var dateWhenClosed = Date()
    
    var timeToAccountForStart = Date()
    
    var timeToAccountForPause = Date()
    
    var timeFromBackgroundEnter = Date()
    
    var secondsDiff: Int = 0
    
    @IBOutlet weak var categoryText: UILabel!
    //Pause, Reset, and Go Buttons
    
    @IBOutlet weak var startB: UIButton!
    
    @IBOutlet weak var pauseB: UIButton!
    
    @IBOutlet weak var noborder: UIImageView!
    
    //dates of category
    var datesOfCategory = [Date]()
    
    //path of category
    var pathOfCategory = 0
    
    //when user clicks on start button
    @IBAction func Start(_ sender: UIButton) {
        
        //if a category is selected
        if categoryLabel.text != ""{
            startB.isHidden = true
            pauseB.isHidden = false
            timer.invalidate()
            
            //get date at first
            timeToAccountForStart = Date()
            
            Singleton.timeData[pathOfCategory].append(timeToAccountForStart)
            
            //timer function
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeL), userInfo: nil, repeats: true)
            
        
        }
    }
    

    
    //When user clicks pause
    @IBAction func Pause(_ sender: UIButton) {
        timeToAccountForPause = Date()
        
        Singleton.displayTime[pathOfCategory] += timeToAccountForPause.timeIntervalSince(Singleton.timeData[pathOfCategory].last!)
        
        Singleton.timeData[pathOfCategory].append(timeToAccountForPause)

        
        startB.isHidden = false
        pauseB.isHidden = true
        timer.invalidate()
        
        Singleton.displayT += timeToAccountForPause.timeIntervalSince(timeToAccountForStart)
    }
    
    
    
    
    //When user clicks reset
    @IBAction func Reset(_ sender: UIButton) {
        
        // if a category is selected
        if categoryLabel.text != ""{
            timer.invalidate()
            secondC = 0
            hourC = 0
            minC = 0
            Singleton.secondC = 0
            timerB.text = String(format: "%02d:%02d:%02d", hourC, minC, secondC)
            
            Singleton.displayT = 0
            
            Singleton.displayTime[pathOfCategory] = 0
            
            Singleton.lastReset = Date()
            
            // if pause button is there - for formatting of timeData
            if pauseB.isHidden == false{
                Singleton.timeData[pathOfCategory].append(Date())
            }
            
            animateV.setNeedsDisplay()
            startB.isHidden = false
            pauseB.isHidden = true
            UIView.animate(withDuration: 0, animations: {self.ballS.transform = CGAffineTransform(rotationAngle: 0)})
        }

    }
    
    
    
    //When user taps on drop down menu and presses somewhere else
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view != viewofB && tableView.isHidden == false{
            tableView.isHidden = true

            UIView.animate(withDuration: 0.25, animations: {self.triangle.transform = CGAffineTransform(rotationAngle: 0)})
        }
        else{
            let position = touch!.location(in: view)
            if position.y <= 800 && position.y >= 200{
                //timer is going
                if startB.isHidden == true{
                    pauseB.sendActions(for: .touchUpInside)
                }
                
                //timer is not going
                else{
                    startB.sendActions(for: .touchUpInside)
                }
            }
        }
    }
    
    
    //When drop down menu is tapped on
    @IBAction func dropDownMenuPressed(_ sender: Any) {
        if Singleton.categories.count > 0{
            tableView.isHidden = false
            UIView.animate(withDuration: 0.25, animations: {self.triangle.transform = CGAffineTransform(rotationAngle: CGFloat.pi)})
        }
    }
    
    
    @IBOutlet weak var viewOfB: UIView!
    
    @IBOutlet weak var resetB: UIButton!
    @IBOutlet weak var stopwatch: UILabel!
    //when program starts
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        let screenHeight = UIScreen.main.bounds.height
        stopwatch.font = stopwatch.font.withSize(50 * screenHeight/842)
        timerB.font = timerB.font.withSize(50 * screenHeight/842)
        
        
        //iphone se
        if screenHeight == 568{
            categoryText.frame = CGRect(x: categoryText.frame.origin.x, y: categoryText.frame.origin.y + 30, width: categoryText.frame.size.width, height: categoryText.frame.size.height)
            startB.frame = CGRect(x: startB.frame.origin.x, y: startB.frame.origin.y + 50, width: startB.frame.size.width, height: startB.frame.size.height)
            pauseB.frame = CGRect(x: pauseB.frame.origin.x, y: pauseB.frame.origin.y + 50, width: pauseB.frame.size.width, height: pauseB.frame.size.height)
            resetB.frame = CGRect(x: resetB.frame.origin.x, y: resetB.frame.origin.y + 50, width: resetB.frame.size.width, height: resetB.frame.size.height)
            viewOfB.frame = CGRect(x: viewOfB.frame.origin.x, y: viewOfB.frame.origin.y + 65, width: viewOfB.frame.size.width, height: viewOfB.frame.size.height)
        }
        Singleton.sizeForAnimation = CGPoint(x: animateV.frame.size.width/2, y: animateV.frame.size.height/2)
        Singleton.radiusBall = min(animateV.frame.size.height/2,animateV.frame.size.width/2) - min(radiusballCalculation.frame.size.width, radiusballCalculation.frame.size.height)/2
        Singleton.pathWidth = min(radiusballCalculation.frame.size.width, radiusballCalculation.frame.size.height)
        
      //  noborder.frame = CGRect(x: ballS.frame.origin.x + ballS.frame.size.width/2 - noborder.frame.size.width/2, y: ballS.frame.origin.y + ballS.frame.size.height/2 - noborder.frame.size.height/2, width: noborder.frame.size.width, height: noborder.frame.size.height)
        animateV.frame = CGRect(origin: outerCircle.frame.origin, size: outerCircle.frame.size)
        
        //hide pause button
        pauseB.isHidden = true
        
        timerB.frame = CGRect(x: outerCircle.frame.origin.x + outerCircle.frame.size.width/2 - timerB.frame.size.width/2, y: outerCircle.frame.origin.y + outerCircle.frame.size.height/2 - timerB.frame.size.height/2, width: timerB.frame.size.width, height: timerB.frame.size.height)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.isHidden = true
        
        //remove view controllers
        
        var viewControllers = navigationController?.viewControllers
        viewControllers?.removeAll()
        
        tableView.rowHeight = 41
        if Singleton.categories.count < 3{
            let frameSize = tableView.frame.size
            let placementPoint = viewOfB.frame.origin
            tableView.frame = CGRect(x: placementPoint.x, y: placementPoint.y + dropDownB.frame.size.height, width: frameSize.width, height: CGFloat(Singleton.categories.count*41))
        //    viewofB.frame = CGRect(x: 93, y: 684, width: 228, height: Singleton.categories.count*40 + 41)
        }
        else{
            let frameSize = tableView.frame.size
            let placementPoint = viewOfB.frame.origin
            tableView.frame = CGRect(x: placementPoint.x, y: placementPoint.y + dropDownB.frame.size.height, width: frameSize.width, height: CGFloat(123))
         //   viewofB.frame = CGRect(x: 93, y: 684, width: 228, height: 161)
        }
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(applicationBecomeActive(notification:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        
        for i in 0..<Singleton.timeData.count{
            if Singleton.timeData[i].count % 2 == 1{

                //when app becomes active
                dateWhenActive = Date()
                
                timeToAccountForStart = Singleton.timeData[i].last!

                Singleton.displayTime[i] += dateWhenActive.timeIntervalSince(Singleton.timeData[i].last!)

                Singleton.timeData[i].append(dateWhenActive)
                
                pathOfCategory = i
                
                categoryLabel.text = Singleton.categories[i]
                
                secondsDiff = Int(Singleton.displayTime[pathOfCategory])
                    
                Singleton.secondC = secondsDiff % 3600
                
                hourC = secondsDiff/3600
                secondsDiff -= hourC * 3600
                
                minC = secondsDiff/60
                secondsDiff -= minC * 60
                
                
                secondC = secondsDiff
            
                UIView.animate(withDuration: 1, animations: {self.ballS.transform = CGAffineTransform(rotationAngle: CGFloat.pi/1800 * CGFloat(Singleton.secondC))})
                
                animateV.setNeedsDisplay()
                
                timerB.text = String(format: "%02d:%02d:%02d", hourC, minC, secondC)
                
                startB.sendActions(for: .touchUpInside)
            }
        }
        
        
        
    }
    
    @objc func applicationBecomeActive(notification: NSNotification){
        
        //stopwatch is running
        if pauseB.isHidden == false{

            //when app becomes active
            dateWhenActive = Date()
            
            Singleton.displayTime[pathOfCategory] += dateWhenActive.timeIntervalSince(Singleton.timeData[pathOfCategory].last!)
            
            Singleton.timeData[pathOfCategory].append(dateWhenActive)
            
            timeToAccountForStart = Date()
            
            Singleton.timeData[pathOfCategory].append(timeToAccountForStart)
            
            secondsDiff = Int(Singleton.displayTime[pathOfCategory])
            Singleton.secondC = secondsDiff % 3600
            
            hourC = secondsDiff/3600
            secondsDiff -= hourC * 3600
            
            minC = secondsDiff/60
            secondsDiff -= minC * 60
            
            secondC = secondsDiff
            
            timerB.text = String(format: "%02d:%02d:%02d", hourC, minC, secondC)
            
            UIView.animate(withDuration: 1, animations: {self.ballS.transform = CGAffineTransform(rotationAngle: CGFloat.pi/1800 * CGFloat(Singleton.secondC))})
            animateV.setNeedsDisplay()
        }
        
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Singleton.categories.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //if another category is selected while a previous one is being timed
        if categoryLabel.text != ""{
            timer.invalidate()
            secondC = 0
            hourC = 0
            minC = 0
            Singleton.secondC = 0
            timerB.text = String(format: "%02d:%02d:%02d", hourC, minC, secondC)
            
            //if timer is going
            if pauseB.isHidden == false{
                Singleton.displayTime[pathOfCategory] += Date().timeIntervalSince(Singleton.timeData[pathOfCategory].last!)
                Singleton.timeData[pathOfCategory].append(Date())
            }
        
            
            animateV.setNeedsDisplay()
            startB.isHidden = false
            pauseB.isHidden = true
            UIView.animate(withDuration: 0, animations: {self.ballS.transform = CGAffineTransform(rotationAngle: 0)})
            
            timer.invalidate()
        }
        
        
        categoryLabel.text = Singleton.categories[indexPath.row]
        
        pathOfCategory = indexPath.row
        tableView.isHidden = true
        UIView.animate(withDuration: 0.25, animations: {self.triangle.transform = CGAffineTransform(rotationAngle: 0)})

        //if there's already time, then the stopwatch starts where it was left off
        secondsDiff = Int(Singleton.displayTime[pathOfCategory])
        
        Singleton.secondC = secondsDiff % 3600
        
        hourC = secondsDiff/3600
        secondsDiff -= hourC * 3600
        
        minC = secondsDiff/60
        secondsDiff -= minC * 60
        
        
        secondC = secondsDiff
    
        UIView.animate(withDuration: 1, animations: {self.ballS.transform = CGAffineTransform(rotationAngle: CGFloat.pi/1800 * CGFloat(Singleton.secondC))})
        
        animateV.setNeedsDisplay()
        
        timerB.text = String(format: "%02d:%02d:%02d", hourC, minC, secondC)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
      //  cell.backgroundView = UIImageView(image: UIImage(named: "dropDownMenu")!)
        cell.backgroundColor = UIColor(red: 212/255, green: 212/255, blue: 212/255, alpha: 1)
        cell.textLabel?.text = Singleton.categories[indexPath.row]
        
        return cell
    }
    
    //if suddenly changed to another tab
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //if timer is going
        if pauseB.isHidden == false{
            timer.invalidate()
            Singleton.displayTime[pathOfCategory] += Date().timeIntervalSince(Singleton.timeData[pathOfCategory].last!)
            Singleton.timeData[pathOfCategory].append(Date())
            Singleton.timeData[pathOfCategory].append(Date())
        }
    }
    
    //change timer
    @objc func timeL()
    {
        secondC += 1
        if secondC == 60{
            minC += 1
            secondC = 0
        }
        if minC == 60{
            minC = 0
            Singleton.secondC = 0
            hourC += 1
        }
        Singleton.secondC += 1
    
        UIView.animate(withDuration: 1, animations: {self.ballS.transform = CGAffineTransform(rotationAngle: CGFloat.pi/1800 * CGFloat(Singleton.secondC))})
        
        animateV.setNeedsDisplay()
        
        timerB.text = String(format: "%02d:%02d:%02d", hourC, minC, secondC)
    
       // Singleton.timeData[categoryN][0] += 1
       
        
    }
}
    



