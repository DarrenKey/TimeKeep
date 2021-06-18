//
//  MainController.swift
//  TimeKeep
//
//  Created by Mi Yan on 4/26/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//

import UIKit
import RealmSwift
import CircleColorPicker

class MainController: UIViewController, SwitchTabs {
    
    var mainContainerController: TabBarController!
    
    var categories: Categories!
    
    var routines: Routines!

    var planner: Planner!
    
    var stopwatch: Stopwatch!
    
    var charts: Charts!
    
    var timeline: Timeline!
    
    var cPopup: CalendarPopup!
    
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var blurButton: UIButton!
    
    //haptic feedback
    var rigidGenerator: UIImpactFeedbackGenerator? = nil
    var mediumGenerator: UIImpactFeedbackGenerator? = nil
    
    var selectedIndex: Int = 2
    
    @IBOutlet weak var calendarView: UIView!
    
    @IBOutlet weak var newCategory: UIView!
    
    var categoryPopup: CategoryPopup!
    
    //containerviews
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var calendarContainerView: UIView!
    
    //resize
    var screenWidth: CGFloat = 0
    var screenHeight: CGFloat = 0
    
    //which one is down
    var calendarDown = false
    var popupDown = false
    
    //onboarding
    @IBOutlet weak var tutorialCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    //change for sizing
    var tutorialSpacingWidth: CGFloat = 24
    var tutorialSpacingHeight: CGFloat = 20
    var calendarTutorialSpacingHeight: CGFloat = 20
    
    //should show tutorial
    var shouldBeginningMain: Bool = false
    
    var shouldCategoryTutorial: Bool = false
    var shouldPlannerTutorial: Bool = false
    var shouldRoutineTutorial: Bool = false
    var shouldChartsTutorial: Bool = false
    var shouldStopwatchTutorial: Bool = false
    var shouldTimelineTutorial: Bool = false
    
    var shouldCustomColorTutorial: Bool = false
    var shouldCalendarTutorial: Bool = false
    
    //function view tutorial
    @IBOutlet weak var functionViewTutorial: UIView!
    @IBOutlet weak var functionLabel: UILabel!
    @IBOutlet weak var explanationLabel: UILabel!
    
    @IBOutlet weak var flippedTriangle: UIImageView!
    @IBOutlet weak var triangle: UIImageView!
    @IBOutlet weak var tutorialView: UIView!
    @IBOutlet weak var tutorialLabel: UILabel!
    
    //category
    var categoryState: Int = 0
    
    //planner
    var plannerState: Int = 0
    
    //routine
    var routineState: Int = 0
    
    //chart
    var chartState: Int = 0
    
    //stopwatch
    var stopwatchState: Int = 0
    
    //timeline
    var timelineState: Int = 0
    
    //custom color tutorial
    var customColorState: Int = 0
    
    //tutorial blur view
    @IBOutlet weak var tutorialBlurView: UIView!
    
    //calendarView
    var calendarState: Int = 0
    
    @IBOutlet weak var tutorialMoveOnButton: UIButton!
    
    @IBOutlet weak var splashScreenView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        blurView.isHidden = true
        
        let screen = UIScreen.main.bounds
        screenWidth = screen.size.width
        screenHeight = screen.size.height
        
        resizeDevice()
        
        //setting delegate of tutorial
        tutorialCollectionView.delegate = self
        tutorialCollectionView.dataSource = self

        pageControl.isHidden = true
        tutorialCollectionView.isHidden = true
        
        //see if should tutorial
        let realm = try! Realm()
        
        //if new to app
        if realm.objects(ShouldTutorial.self).count == 0{
            //create shouldtutorial instance
            let shouldTutorial = ShouldTutorial()

            try! realm.write {
                realm.add(shouldTutorial)
            }
            shouldBeginningMain = true
            shouldCategoryTutorial = true
            shouldPlannerTutorial = true
            shouldRoutineTutorial = true
            shouldStopwatchTutorial = true
            shouldChartsTutorial = true
            shouldTimelineTutorial = true
            shouldCustomColorTutorial = true
            shouldCalendarTutorial = true
            
            pageControl.isHidden = false
            tutorialCollectionView.isHidden = false
            
            //creation of premade categories
            //work
            var workCategory = Category()
            
            workCategory.name = "Work"
            workCategory.h = 0.583
            workCategory.s = 1
            workCategory.b = 1
            workCategory.a = 1
            
            workCategory.colorNum = 21
            
            //exercise
            var exerciseCategory = Category()
            
            exerciseCategory.name = "Exercise"
            exerciseCategory.h = 0
            exerciseCategory.s = 1
            exerciseCategory.b = 1
            exerciseCategory.a = 1
            
            exerciseCategory.colorNum = 0
            
            //rest
            var restCategory = Category()
            
            restCategory.name = "Rest"
            restCategory.h = 0.083
            restCategory.s = 1
            restCategory.b = 1
            restCategory.a = 1
            
            restCategory.colorNum = 3
            
            //routines
            //running routine
            var runningRoutine = Routine()
            
            //name
            runningRoutine.name = "Running"
            
            //category
            runningRoutine.categoryNum = 1
            runningRoutine.categoryName = "Exercise"
            
            //colors
            runningRoutine.h = 0
            runningRoutine.s = 1
            runningRoutine.b = 1
            runningRoutine.a = 1

            //type
            runningRoutine.type = "Time"
            
            runningRoutine.numCompleted = 0
            runningRoutine.goal = 30
            runningRoutine.displayTime = 0
            
            //meditation routine
            var meditationRoutine = Routine()
            
            //name
            meditationRoutine.name = "Meditation"
            
            //category
            meditationRoutine.categoryNum = 2
            meditationRoutine.categoryName = "Rest"
            
            //colors
            meditationRoutine.h = 0.5
            meditationRoutine.s = 1
            meditationRoutine.b = 1
            meditationRoutine.a = 1

            //type
            meditationRoutine.type = "Time"
            
            meditationRoutine.numCompleted = 0
            meditationRoutine.goal = 15
            meditationRoutine.displayTime = 0
            
            //reading routine
            var readingRoutine = Routine()
            
            //name
            readingRoutine.name = "Reading"
            
            //category
            readingRoutine.categoryNum = 2
            readingRoutine.categoryName = "Rest"
            
            //colors
            readingRoutine.h = 0.917
            readingRoutine.s = 1
            readingRoutine.b = 1
            readingRoutine.a = 1

            //type
            readingRoutine.type = "Time"
            
            readingRoutine.numCompleted = 0
            readingRoutine.goal = 60
            readingRoutine.displayTime = 0
            
            try! realm.write {
                realm.add(workCategory)
                realm.add(exerciseCategory)
                realm.add(restCategory)
                realm.add(runningRoutine)
                realm.add(meditationRoutine)
                realm.add(readingRoutine)
            }
            
            //test task
            var taskRealm = TaskSaved()
            
            //name
            taskRealm.name = "Tutorial Task"
        
            taskRealm.categoryName = "Tutorial Category"
            
            //colors
            taskRealm.h = 0.833
            taskRealm.s = 1
            taskRealm.b = 1
            taskRealm.a = 1
            
            //start dates
            taskRealm.startMonth = 0
            taskRealm.startDay = 1
            
            //end dates
            taskRealm.endMonth = 479
            taskRealm.endDay = 31

            taskRealm.alarmEnabled = false
            try! realm.write {
                realm.add(taskRealm)
            }
        }
        
        let firstRealmTutorial = realm.objects(ShouldTutorial.self)[0]
        
        if firstRealmTutorial.shouldBeginningMain{
            shouldBeginningMain = true
            
            pageControl.isHidden = false
            tutorialCollectionView.isHidden = false
        }
        if firstRealmTutorial.shouldCategoryTutorial{
            shouldCategoryTutorial = true
        }
        if firstRealmTutorial.shouldPlannerTutorial{
            shouldPlannerTutorial = true
        }
        if firstRealmTutorial.shouldRoutineTutorial{
            shouldRoutineTutorial = true
        }
        if firstRealmTutorial.shouldStopwatchTutorial{
            shouldStopwatchTutorial = true
        }
        if firstRealmTutorial.shouldChartsTutorial{
            shouldChartsTutorial = true
        }
        if firstRealmTutorial.shouldTimelineTutorial{
            shouldTimelineTutorial = true
        }
        if firstRealmTutorial.shouldCustomColorTutorial{
            shouldCustomColorTutorial = true
        }
        if firstRealmTutorial.shouldCalendarTutorial{
            shouldCalendarTutorial = true
        }
        
        //make sure no duplicate shouldRoutineTutorial
        if shouldBeginningMain == false && shouldRoutineTutorial == true{
            checkShouldTutorial()
        }
        
        //page control setup
        pageControl.currentPageIndicatorTintColor = UIColor(hex: "E85A4F")
        pageControl.pageIndicatorTintColor = UIColor(hex: "E85A4F", alpha: 0.25)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
    }
    
    @IBAction func moveOnPressed(_ sender: Any) {
        checkShouldTutorial()
        
        //haptic feedback generator
        let selectionGenerator = UISelectionFeedbackGenerator()
        selectionGenerator.selectionChanged()
    }
    
    //manually resize
    func resizeDevice(){
        //tab bar view width same as phone
        tabBarView.frame.size.width = screenWidth
        
        //blurview and main view both size of phone
        blurView.frame.size = CGSize(width: screenWidth, height: screenHeight)
        blurButton.frame.size = CGSize(width: screenWidth, height: screenHeight)
        tutorialBlurView.frame.size = CGSize(width: screenWidth, height: screenHeight)
        mainView.frame.size = CGSize(width: screenWidth, height: screenHeight)
        mainView.frame.origin = CGPoint(x: 0, y: 0)
        tutorialMoveOnButton.frame.size = CGSize(width: screenWidth, height: screenHeight)
        tutorialCollectionView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        splashScreenView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        
        if screenWidth == 375 && screenHeight == 812{
            newCategory.frame = CGRect(x: 0, y: -600, width: 375, height: 600)
            
            calendarContainerView.frame = CGRect(x: 0, y: -495, width: 332, height: 495)
            calendarContainerView.center.x = 375/2
            
            //tutorial settings
            functionLabel.font = functionLabel.font.withSize(50)
            functionLabel.frame = CGRect(x: 0, y: 20, width: 375, height: 65)
            
            explanationLabel.font = explanationLabel.font.withSize(30)
            explanationLabel.frame = CGRect(x: 24, y: 105, width: 327, height: 208)
            
            tutorialLabel.font = tutorialLabel.font.withSize(30)
            calendarTutorialSpacingHeight = 20
            
            pageControl.frame = CGRect(x: 168, y: 731, width: 39, height: 37)
        }
        else if screenWidth == 414 && screenHeight == 736{
            tabBarView.frame = CGRect(x: 0, y: 666, width: 414, height: 70)
            
            pageControl.frame = CGRect(x: 187, y: 689, width: 39, height: 37)
            
            //tutorial settings
            explanationLabel.font = explanationLabel.font.withSize(35)
            explanationLabel.frame = CGRect(x: 24, y: 118, width: 366, height: 226)
            
            tutorialLabel.font = tutorialLabel.font.withSize(35)
            calendarTutorialSpacingHeight = 20
        }
        else if screenWidth == 375 && screenHeight == 667{
            newCategory.frame = CGRect(x: 0, y: -600, width: 375, height: 600)
            
            calendarContainerView.frame = CGRect(x: 0, y: -495, width: 332, height: 495)
            calendarContainerView.center.x = 375/2
            
            tabBarView.frame = CGRect(x: 0, y: 606, width: 375, height: 61)
            
            //tutorial settings
            functionLabel.font = functionLabel.font.withSize(50)
            functionLabel.frame = CGRect(x: 0, y: 20, width: 375, height: 65)
            
            explanationLabel.font = explanationLabel.font.withSize(30)
            explanationLabel.frame = CGRect(x: 24, y: 105, width: 327, height: 208)
            
            tutorialLabel.font = tutorialLabel.font.withSize(30)
            calendarTutorialSpacingHeight = 20
            
            pageControl.frame = CGRect(x: 168, y: 620, width: 39, height: 37)
        }
        else if screenWidth == 320 && screenHeight == 568{
            newCategory.frame = CGRect(x: 0, y: -550, width: 320, height: 550)
            
            calendarContainerView.frame = CGRect(x: 0, y: -450, width: 280, height: 450)
            calendarContainerView.center.x = 160
            
            tabBarView.frame = CGRect(x: 0, y: 507, width: 320, height: 61)
            
            //tutorial settings
            functionLabel.font = functionLabel.font.withSize(40)
            functionLabel.frame = CGRect(x: 0, y: 20, width: 320, height: 52)
            
            explanationLabel.font = explanationLabel.font.withSize(25)
            explanationLabel.frame = CGRect(x: 24, y: 92, width: 262, height: 172)
            
            tutorialLabel.font = tutorialLabel.font.withSize(25)
            calendarTutorialSpacingHeight = 10
            
            pageControl.frame = CGRect(x: 140, y: 521, width: 39, height: 37)
        }
        else if screenWidth == 768 && screenHeight == 1024{
            newCategory.frame = CGRect(x: 0, y: -1024, width: 768, height: 1024)
            
            calendarContainerView.frame = CGRect(x: 0, y: -700, width: 600, height: 700)
            calendarContainerView.center.x = 384
            
            tabBarView.frame = CGRect(x: 0, y: 924, width: 768, height: 100)
            
            //tutorial settings
            functionLabel.font = functionLabel.font.withSize(80)
            functionLabel.frame = CGRect(x: 0, y: 20, width: 768, height: 104)
            
            explanationLabel.font = explanationLabel.font.withSize(55)
            explanationLabel.frame = CGRect(x: 24, y: 144, width: 720, height: 344)
            
            tutorialLabel.font = tutorialLabel.font.withSize(55)
            
            pageControl.frame = CGRect(x: 364, y: 952, width: 40, height: 37)
        }
        else if screenWidth == 834 && screenHeight == 1194{
            newCategory.frame = CGRect(x: 0, y: -1194, width: 834, height: 1194)
            
            calendarContainerView.frame = CGRect(x: 0, y: -700, width: 600, height: 700)
            calendarContainerView.center.x = 417
            
            tabBarView.frame = CGRect(x: 0, y: 1064, width: 834, height: 130)
            
            //tutorial settings
            functionLabel.font = functionLabel.font.withSize(105)
            functionLabel.frame = CGRect(x: 0, y: 20, width: 834, height: 137)
            
            explanationLabel.font = explanationLabel.font.withSize(60)
            explanationLabel.frame = CGRect(x: 24, y: 177, width: 786, height: 396)
            
            tutorialLabel.font = tutorialLabel.font.withSize(60)
            
            pageControl.frame = CGRect(x: 397, y: 1107, width: 40, height: 37)
        }
        else if screenWidth == 834 && screenHeight == 1112{
            newCategory.frame = CGRect(x: 0, y: -1112, width: 834, height: 1112)
            
            calendarContainerView.frame = CGRect(x: 0, y: -700, width: 600, height: 700)
            calendarContainerView.center.x = 417
            
            tabBarView.frame = CGRect(x: 0, y: 1002, width: 834, height: 110)
            
            //tutorial settings
            functionLabel.font = functionLabel.font.withSize(100)
            functionLabel.frame = CGRect(x: 0, y: 20, width: 834, height: 117)
            
            explanationLabel.font = explanationLabel.font.withSize(60)
            explanationLabel.frame = CGRect(x: 24, y: 157, width: 786, height: 375)
            
            tutorialLabel.font = tutorialLabel.font.withSize(60)
            
            pageControl.frame = CGRect(x: 397, y: 1045, width: 40, height: 37)
        }
        else if screenWidth == 1024 && screenHeight == 1366{
            newCategory.frame = CGRect(x: 0, y: -1366, width: 1024, height: 1366)
            
            calendarContainerView.frame = CGRect(x: 0, y: -1000, width: 800, height: 1000)
            calendarContainerView.center.x = 512
            
            tabBarView.frame = CGRect(x: 0, y: 1226, width: 1024, height: 140)
            
            //tutorial settings
            functionLabel.font = functionLabel.font.withSize(120)
            functionLabel.frame = CGRect(x: 0, y: 20, width: 1024, height: 156)
            
            explanationLabel.font = explanationLabel.font.withSize(60)
            explanationLabel.frame = CGRect(x: 24, y: 196, width: 976, height: 437)
            
            tutorialLabel.font = tutorialLabel.font.withSize(60)
            
            pageControl.frame = CGRect(x: 492, y: 1279, width: 40, height: 37)
        }
        else if screenWidth == 810 && screenHeight == 1080{
            newCategory.frame = CGRect(x: 0, y: -1080, width: 810, height: 1080)
            
            calendarContainerView.frame = CGRect(x: 0, y: -700, width: 600, height: 700)
            calendarContainerView.center.x = 405
            
            tabBarView.frame = CGRect(x: 0, y: 970, width: 810, height: 110)
            
            //tutorial settings
            functionLabel.font = functionLabel.font.withSize(90)
            functionLabel.frame = CGRect(x: 0, y: 20, width: 810, height: 117)
            
            explanationLabel.font = explanationLabel.font.withSize(60)
            explanationLabel.frame = CGRect(x: 24, y: 157, width: 762, height: 359)
            
            tutorialLabel.font = tutorialLabel.font.withSize(60)
            
            pageControl.frame = CGRect(x: 385, y: 1027, width: 40, height: 37)
        }
    }
    
    func startFunctionalView(){
        tutorialBlurView.isHidden = false
        tutorialMoveOnButton.isHidden = false
        functionViewTutorial.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: 0)
        functionViewTutorial.isHidden = false
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.25, options: .curveEaseOut, animations:{
        
            self.functionViewTutorial.frame = CGRect(x: 0, y: self.screenHeight/2, width: self.screenWidth, height: self.screenHeight/2)
        }, completion: nil)
    }
    
    func checkShouldTutorial(){
        //categories
        if selectedIndex == 0{
            if shouldCategoryTutorial == true{
                if categoryState == 0{
                    startFunctionalView()
                    explanationText("Create and view categories here.")
                }
                else if categoryState == 1{
                    explanationText("Time your day, sorted into your categories, in the Stopwatch tab.")
                }
                else if categoryState == 2{
                    explanationText("Sort your tasks (Planner tab) and routines (Routine tab) into your categories.")
                }
                else if categoryState == 3{
                    explanationText("Here are some preset categories. Feel free to delete or modify them.")
                }
                else if categoryState == 4{
                    let firstCategory = categories.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! CategoryCell
                    
                    holeBlurView(CGRect(x: 0, y: categories.tableView.frame.origin.y, width: screenWidth, height: firstCategory.frame.size.height))
                    
                    UIView.animateKeyframes(withDuration: 1.25, delay: 0, options: .repeat, animations: {
                        UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/1.25, animations: {
                            firstCategory.mainView.frame.origin = CGPoint(x: -100, y: 0)
                            firstCategory.wobbleView.frame.origin = CGPoint(x: firstCategory.screenWidth - 100, y: 0)
                            firstCategory.trashCanIcon.frame.origin = CGPoint(x: firstCategory.screenWidth - 100 + firstCategory.wobbleView.frame.size.width/2 - firstCategory.trashCanIcon.frame.size.width/2, y: firstCategory.trashCanIcon.frame.origin.y)
                        })
                    }, completion: nil)
                    
                    explanationText("To modify a category, tap on it. To delete a category, swipe left on it, then press the trash can icon.")
                }
                else if categoryState == 5{
                    categoryState = 0
                    shouldCategoryTutorial = false

                    //turn off tutorial
                    let realm = try! Realm()
                    
                    let shouldTutorial = realm.objects(ShouldTutorial.self)[0]
                    
                    try! realm.write{
                        shouldTutorial.shouldCategoryTutorial = false
                    }
                    
                    let firstCategory = categories.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! CategoryCell
                    
                    UIView.animateKeyframes(withDuration: 0, delay: 0, animations: {
                        firstCategory.mainView.frame.origin = CGPoint(x: 0, y: 0)
                        firstCategory.wobbleView.frame.origin = CGPoint(x: firstCategory.screenWidth, y: 0)
                        firstCategory.trashCanIcon.frame.origin = CGPoint(x: firstCategory.screenWidth + firstCategory.wobbleView.frame.size.width/2 - firstCategory.trashCanIcon.frame.size.width/2, y: firstCategory.trashCanIcon.frame.origin.y)
                    }, completion: nil)
                    
                    self.tutorialBlurView.isHidden = true
                    tutorialMoveOnButton.isHidden = true
                    resetTutorialBlurView()
                    
                    UIView.animate(withDuration: 0.25, animations:{
                        self.functionViewTutorial.frame = CGRect(x: 0, y: self.screenHeight, width: self.screenWidth, height: 0)
                    }, completion: {_ in
                        self.functionViewTutorial.isHidden = true
                    })
                    
                }
                
                categoryState += 1
            }
        }
            
        //planner
        else if selectedIndex == 1{
            if shouldPlannerTutorial == true{
                //first state
                if plannerState == 0{
                    startFunctionalView()
                    explanationText("Keep track and view your daily tasks here.")
                }
                else if plannerState == 1{
                    let currentDay = planner.plannerCV.cellForItem(at: IndexPath(item: planner.displayedCell, section: 0)) as! PlannerCell
                    
                    let tutorialTask = currentDay.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! Task
                    
                    holeBlurView(CGRect(x: 0, y: currentDay.tableView.frame.origin.y + planner.plannerCV.frame.origin.y, width: screenWidth, height: tutorialTask.frame.size.height))
                    
                    UIView.animateKeyframes(withDuration: 0.75, delay: 0, options: .repeat, animations: {
                        UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5/0.75, animations: {
                            
                            tutorialTask.masterView.frame.origin = CGPoint(x:  -100, y: 0)
                            tutorialTask.wobbleView.frame.origin = CGPoint(x: self.screenWidth - 100, y: 0)
                            tutorialTask.trashCanImage.frame.origin = CGPoint(x: self.screenWidth - 100 + tutorialTask.wobbleView.frame.size.width/2 - tutorialTask.trashCanImage.frame.size.width/2, y: tutorialTask.trashCanImage.frame.origin.y)
                        })
                        
                    }, completion: nil)
                    
                    explanationText("To delete a task, swipe left FAST and press the trash can icon.")
                }
                else if plannerState == 2{
                    explanationText("To swipe to another date without wanting to delete the task, swipe left SLOWLY.")
                    
                    let currentDay = planner.plannerCV.cellForItem(at: IndexPath(item: planner.displayedCell, section: 0)) as! PlannerCell
                    
                    let tutorialTask = currentDay.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! Task
                    
                    UIView.animate(withDuration: 0, animations: {
                        //reset locations
                        tutorialTask.masterView.frame.origin = CGPoint(x:0, y: 0)
                        tutorialTask.wobbleView.frame.origin = CGPoint(x: self.screenWidth, y: 0)
                        tutorialTask.trashCanImage.frame.origin = CGPoint(x: self.screenWidth + tutorialTask.wobbleView.frame.size.width/2 - tutorialTask.trashCanImage.frame.size.width/2, y: tutorialTask.trashCanImage.frame.origin.y)
                    })
                    
                    UIView.animateKeyframes(withDuration: 4, delay: 0, options: .repeat, animations: {
                        UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 5.75/6, animations: {
                            self.planner.plannerCV.contentOffset.x = self.planner.plannerCV.contentOffset.x + self.screenWidth
                        })
                        
                    }, completion: nil)
                }
                else if plannerState == 3{
                    //turn off animation
                    let currentDay = planner.plannerCV.cellForItem(at: IndexPath(item: planner.displayedCell, section: 0)) as! PlannerCell
                    
                    UIView.animate(withDuration: 0, animations: {
                        //reset locations
                        self.planner.plannerCV.contentOffset.x = self.planner.plannerCV.contentOffset.x - self.screenWidth
                    })
                    
                    functionViewTutorial.isHidden = true
                    
                    resetTutorialBlurView()
                    
                    holeBlurView(CGRect(x: currentDay.dateButton.frame.origin.x, y: planner.plannerCV.frame.origin.y, width: currentDay.dateButton.frame.size.width, height: currentDay.dateButton.frame.size.height))
                    
                    triangleTutorialView(screenWidth/2, planner.plannerCV.frame.origin.y + currentDay.masterView.frame.size.height + 5, "Tap on the date to view the calendar.")
                }
                else if plannerState == 4{
                    plannerState = 0
                    shouldPlannerTutorial = false

                    //turn off tutorial
                    let realm = try! Realm()
                    
                    let shouldTutorial = realm.objects(ShouldTutorial.self)[0]
                    
                    try! realm.write{
                        shouldTutorial.shouldPlannerTutorial = false
                    }
                    
                    //delete tutorial task
                    let taskSaved = realm.objects(TaskSaved.self)[0]
                    try! realm.write{
                        realm.delete(taskSaved)
                    }
                    
                    planner.plannerCV.reloadData()

                    turnOffTutorialView(0)
                }
                
                plannerState += 1
            }
        }
            
        //routine
        else if selectedIndex == 2{
            if shouldRoutineTutorial == true{
                //first state
                if routineState == 0{
                    startFunctionalView()
                    explanationText("Keep track and view your daily routines here.")
                }
                else if routineState == 1{
                    explanationText("Tap on the screen anywhere to skip the routine entrance animations.")
                }
                else if routineState == 2{
                    explanationText("Here are some preset routines. Feel free to delete them.")
                }
                else if routineState == 3{
                    
                    let routineOne = routines.tableView.cellForRow(at: [0,0]) as! RoutineCell
                    
                    holeBlurView(CGRect(x: routineOne.routineView.frame.origin.x, y: routineOne.routineView.frame.origin.y + routines.tableView.frame.origin.y, width: routineOne.routineView.frame.size.width, height: routineOne.routineView.frame.size.height))
                    
                    explanationText("To delete them, swipe left on the routine, then press the trash can icon.")
                    
                    UIView.animateKeyframes(withDuration: 1.25, delay: 0, options: .repeat, animations: {
                        UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/1.25, animations: {
                            
                            routineOne.baseView.frame.origin = CGPoint(x:  -100, y: 0)
                            routineOne.wobbleView.frame.origin = CGPoint(x: routineOne.routineView.frame.size.width - 100, y: 0)
                            routineOne.trashCanImage.frame.origin = CGPoint(x: routineOne.routineView.frame.size.width - 100 + routineOne.wobbleView.frame.size.width/2 - routineOne.trashCanImage.frame.size.width/2, y: routineOne.trashCanImage.frame.origin.y)
                        })
                        
                    }, completion: nil)
                    
                }
                else if routineState == 4{
                    functionViewTutorial.isHidden = true
                    
                    let routineOne = routines.tableView.cellForRow(at: [0,0]) as! RoutineCell
                    
                    resetTutorialBlurView()
                    holeBlurView(routines.newRoutineButton.frame)
                    
                    flippedTriangleTutorialView(routines.newRoutineButton.center.x, routines.newRoutineButton.frame.origin.y - 5 - flippedTriangle.frame.size.height, "Tap the + button to add a new routine.")
                    
                    UIView.animate(withDuration: 0, animations: {
                        //reset locations
                        routineOne.baseView.frame.origin = CGPoint(x:  0, y: 0)
                        routineOne.wobbleView.frame.origin = CGPoint(x: routineOne.routineView.frame.size.width, y: 0)
                        routineOne.trashCanImage.frame.origin = CGPoint(x: routineOne.routineView.frame.size.width + routineOne.wobbleView.frame.size.width/2 - routineOne.trashCanImage.frame.size.width/2, y: routineOne.trashCanImage.frame.origin.y)
                    })
                }
                else if routineState == 5{
                    routineState = 0
                    shouldRoutineTutorial = false

                    //turn off tutorial
                    let realm = try! Realm()
                    
                    let shouldTutorial = realm.objects(ShouldTutorial.self)[0]
                    
                    try! realm.write{
                        shouldTutorial.shouldRoutineTutorial = false
                    }

                    turnOffTutorialView(1)
                }
                
                routineState += 1
            }
        }
            
        //stopwatch
        else if selectedIndex == 3{
            if shouldStopwatchTutorial == true{
                //first state
                if stopwatchState == 0{
                    startFunctionalView()
                    explanationText("Time your day here. \nSort your time into categories or routines.")
                }
                else if stopwatchState == 1{
                    functionViewTutorial.isHidden = true
                    
                    holeBlurView(stopwatch.categoryView.frame)
                    
                    triangleTutorialView(screenWidth/2, stopwatch.categoryView.frame.origin.y + stopwatch.categoryView.frame.size.height + 5, "Tap the category/routine label to change the category/routine.")
                }
                else if stopwatchState == 2{
                    stopwatchState = 0
                    shouldStopwatchTutorial = false
                    
                    
                    //turn off tutorial
                    let realm = try! Realm()
                    
                    let shouldTutorial = realm.objects(ShouldTutorial.self)[0]
                    
                    try! realm.write{
                        shouldTutorial.shouldStopwatchTutorial = false
                    }

                    turnOffTutorialView(0)
                }
                
                stopwatchState += 1
            }
        }
            
        //charts
        else if selectedIndex == 4{
            if shouldChartsTutorial == true{
                //first state
                if chartState == 0{
                    startFunctionalView()
                    explanationText("View your time spent in the form of a bar chart or a pie chart.")
                }
                else if chartState == 1{
                    functionViewTutorial.isHidden = true
                    
                    holeBlurView(charts.dateLabel.frame)
                    
                    triangleTutorialView(screenWidth/2,charts.dateLabel.frame.origin.y + charts.dateLabel.frame.size.height + 5,"Tap on the date to view the calendar. Choose a date to see stats from that date.")
                }
                else if chartState == 2{
                    chartState = 0
                    shouldChartsTutorial = false
                    
                    //turn off tutorial
                    let realm = try! Realm()
                    
                    let shouldTutorial = realm.objects(ShouldTutorial.self)[0]
                    
                    try! realm.write{
                        shouldTutorial.shouldChartsTutorial = false
                    }

                    turnOffTutorialView(0)
                }
                
                chartState += 1
            }
        }
            
        //timeline
        else if selectedIndex == 5{
            if shouldTimelineTutorial == true{
                //first state
                if timelineState == 0{
                    startFunctionalView()
                    explanationText("View your time spent in the form of a timeline. Record your day in the Stopwatch tab.")
                }
                else if timelineState == 1{
                    functionViewTutorial.isHidden = true
                    
                    holeBlurView(timeline.dateButton.frame)
                    
                    triangleTutorialView(screenWidth/2, timeline.dateButton.frame.origin.y + timeline.dateButton.frame.size.height + 5, "Tap on the date to view the calendar. Choose a date to see stats from that date.")
                }
                else if timelineState == 2{
                    timelineState = 0
                    shouldTimelineTutorial = false
                    
                    //turn off tutorial
                    let realm = try! Realm()
                    
                    let shouldTutorial = realm.objects(ShouldTutorial.self)[0]
                    
                    try! realm.write{
                        shouldTutorial.shouldTimelineTutorial = false
                    }

                    turnOffTutorialView(0)
                }
                
                timelineState += 1
            }
        }

        //if custom color tutorial
        if shouldCustomColorTutorial == true{
            if customColorState == 1{
                customColorState = 0
                shouldCustomColorTutorial = false

                //turn off tutorial
                let realm = try! Realm()
                
                let shouldTutorial = realm.objects(ShouldTutorial.self)[0]
                
                try! realm.write{
                    shouldTutorial.shouldCustomColorTutorial = false
                }

                turnOffTutorialView(1)
            }
        }

        //calendar tutorial
        if shouldCalendarTutorial == true{
            if calendarState == 1{
                //enable everything
                cPopup.tutorialBlurView.isHidden = true
                tutorialBlurView.isHidden = false
                
                let currentCalendarCell = cPopup.collectionView.cellForItem(at: [0,cPopup.highlightedMonth]) as! CalendarPopupCard
                
                //setup to look like date
                flippedTriangle.isHidden = true
                
                blurView.isHidden = true
                blurButton.isHidden = false
                
                holeBlurView(CGRect(x: currentCalendarCell.monthButton.frame.origin.x + calendarContainerView.frame.origin.x, y: calendarContainerView.frame.origin.y, width: currentCalendarCell.monthButton.frame.size.width, height: currentCalendarCell.monthButton.frame.size.height))
                
                triangleTutorialView(screenWidth/2, calendarContainerView.frame.origin.y + currentCalendarCell.labelView.frame.size.height, "Tap the top or swipe up/down to view the calendar in month mode.")
                
                calendarState = 2
            }
            else if calendarState == 2{
                calendarState = 0
                shouldCalendarTutorial = false
                
                //turn off tutorial
                let realm = try! Realm()
                
                let shouldTutorial = realm.objects(ShouldTutorial.self)[0]
                
                try! realm.write{
                    shouldTutorial.shouldCalendarTutorial = false
                }
                
                blurView.isHidden = false
                
                turnOffTutorialView(0)
            }
        }

    }
    
    func turnOffTutorialView(_ state: Int){
        // 0 = triangle, 1 = flippedTriangle
        if state == 0{
            resetTutorialBlurView()
            tutorialBlurView.isHidden = true
            functionViewTutorial.isHidden = true
            tutorialMoveOnButton.isHidden = true
            
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                self.tutorialView.frame.origin.x = self.screenWidth
                self.triangle.frame.origin.x = self.screenWidth
            }, completion: {_ in
                self.tutorialView.isHidden = true
                self.triangle.isHidden = true
            })
        }
        else if state == 1{
            tutorialBlurView.isHidden = true
            tutorialMoveOnButton.isHidden = true
            functionViewTutorial.isHidden = true
            resetTutorialBlurView()
            
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                self.tutorialView.frame.origin.x = self.screenWidth
                self.flippedTriangle.frame.origin.x = self.screenWidth
            }, completion: {_ in
                self.tutorialView.isHidden = true
                self.flippedTriangle.isHidden = true
            })
        }
        
    }
    
    func resetTutorialBlurView(){
        tutorialBlurView.layer.sublayers = nil
        tutorialBlurView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    func holeBlurView(_ holeFrame: CGRect){
        let pathBigRect = UIBezierPath(rect: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        let pathSmallRect = UIBezierPath(rect: holeFrame)

        pathBigRect.append(pathSmallRect)
        pathBigRect.usesEvenOddFillRule = true

        let fillLayer = CAShapeLayer()
        fillLayer.path = pathBigRect.cgPath
        fillLayer.fillRule = CAShapeLayerFillRule.evenOdd
        fillLayer.fillColor = UIColor.black.cgColor
        fillLayer.opacity = 0.5
        
        tutorialBlurView.backgroundColor = .clear
        tutorialBlurView.layer.addSublayer(fillLayer)
    }
    
    func triangleTutorialView(_ center: CGFloat, _ triangleY: CGFloat, _ labelText: String){
        //setup of tutorial and text
        tutorialView.isHidden = false
        triangle.isHidden = false
        
        triangle.center.x = center
        triangle.frame.origin.y = triangleY
        
        tutorialLabel.frame.size = CGSize(width: screenWidth - 2 * tutorialSpacingWidth, height: 100)
        tutorialLabel.text = labelText
        tutorialLabel.sizeToFit()
        
        tutorialLabel.center.x = screenWidth/2
        tutorialLabel.frame.origin.y = 20
        
        tutorialView.frame = CGRect(x: 0, y: triangle.frame.origin.y + triangle.frame.size.height, width: screenWidth, height: tutorialLabel.frame.size.height + 40)
        
        //setup of animations
        let prevTV = tutorialView.frame.origin.x
        let prevT = triangle.frame.origin.x
        
        tutorialView.frame.origin.x = screenWidth
        triangle.frame.origin.x = screenWidth
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.tutorialView.frame.origin.x = prevTV
            self.triangle.frame.origin.x = prevT
        }, completion: nil)
        
    }
    
    func flippedTriangleTutorialView(_ center: CGFloat, _ triangleY: CGFloat, _ labelText: String){
        //setup of tutorial and text
        tutorialView.isHidden = false
        flippedTriangle.isHidden = false
        
        flippedTriangle.center.x = center
        flippedTriangle.frame.origin.y = triangleY
        
        tutorialLabel.frame.size = CGSize(width: screenWidth - 2 * tutorialSpacingWidth, height: 100)
        tutorialLabel.text = labelText
        tutorialLabel.sizeToFit()
        
        tutorialLabel.center.x = screenWidth/2
        tutorialLabel.frame.origin.y = 20
        
        tutorialView.frame = CGRect(x: 0, y: flippedTriangle.frame.origin.y - (tutorialLabel.frame.size.height + 40), width: screenWidth, height: tutorialLabel.frame.size.height + 40)
        
        //setup of animations
        let prevTV = tutorialView.frame.origin.x
        let prevT = flippedTriangle.frame.origin.x
        
        tutorialView.frame.origin.x = screenWidth
        flippedTriangle.frame.origin.x = screenWidth
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.tutorialView.frame.origin.x = prevTV
            self.flippedTriangle.frame.origin.x = prevT
        }, completion: nil)
    }
    
    func explanationText(_ labelText: String){
        explanationLabel.frame = CGRect(x: tutorialSpacingWidth, y: functionLabel.frame.size.height + tutorialSpacingHeight * 2, width: screenWidth - 2 * tutorialSpacingWidth, height: 156)
        explanationLabel.text = labelText
        explanationLabel.sizeToFit()
        explanationLabel.center.x = screenWidth/2
    }
    
    @IBAction func pageControlChanged(_ sender: Any) {
        tutorialCollectionView.scrollToItem(at: IndexPath(item: pageControl.currentPage, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    @IBAction func blurButtonPressed(_ sender: Any) {
        if calendarDown == true{

            let selectionGenerator = UISelectionFeedbackGenerator()
            selectionGenerator.selectionChanged()
            
            //retract view
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                
                self.calendarContainerView.frame.origin.y = -self.calendarContainerView.frame.size.height
                
            }, completion: nil)
            
            calendarDown = false
            
            cPopup.isYearEnabled = false
            
            //blur surrounding
            blurView.isHidden = true
        }
    }
    
    func calendarTutorial(){
        if shouldCalendarTutorial == true{
            //check - for if custom color is tutorialized in a segue
            let realm = try! Realm()
            
            let firstRealmTutorial = realm.objects(ShouldTutorial.self)[0]
            
            if firstRealmTutorial.shouldCalendarTutorial == false{
                shouldCalendarTutorial = false
                return
            }
            calendarState = 1
            
            //enable everything
            blurView.isHidden = false
            blurButton.isHidden = true
            cPopup.tutorialBlurView.isHidden = false
            tutorialMoveOnButton.isHidden = false

            //setup of tutorial and text
            tutorialView.isHidden = false
            flippedTriangle.isHidden = false
            
            let customCalendarPoint = CGPoint(x: 0, y: calendarContainerView.frame.origin.y + cPopup.tutorialBlurView.frame.size.height)
            
            flippedTriangle.center.x = screenWidth/2
            flippedTriangle.frame.origin.y = customCalendarPoint.y - 5 - flippedTriangle.frame.size.height
            
            tutorialLabel.frame.size = CGSize(width: screenWidth - 2 * tutorialSpacingWidth, height: 100)
            tutorialLabel.text = "Tap a day to select that date."
            tutorialLabel.sizeToFit()
            
            tutorialLabel.center.x = screenWidth/2
            tutorialLabel.frame.origin.y = calendarTutorialSpacingHeight
            
            tutorialView.frame = CGRect(x: 0, y: flippedTriangle.frame.origin.y - (tutorialLabel.frame.size.height + 2 * calendarTutorialSpacingHeight), width: screenWidth, height: tutorialLabel.frame.size.height + 2 * calendarTutorialSpacingHeight)
            
            //setup of animations
            let prevTV = tutorialView.frame.origin.x
            let prevT = flippedTriangle.frame.origin.x
            
            tutorialView.frame.origin.x = screenWidth
            flippedTriangle.frame.origin.x = screenWidth
            
            UIView.animate(withDuration: 0.25, delay: 0.5, options: .curveEaseInOut, animations: {
                self.tutorialView.frame.origin.x = prevTV
                self.flippedTriangle.frame.origin.x = prevT
            }, completion: nil)
        }
    }
    
    //turn off tutorial
    func shutOffTutorial(){
        let realm = try! Realm()
        
        let shouldTutorial = realm.objects(ShouldTutorial.self)[0]
        
        try! realm.write{
            shouldTutorial.shouldBeginningMain = false
        }

        pageControl.isHidden = true
        tutorialCollectionView.isHidden = true

        //update routines
        //call routine from realms
        let routineRealm = realm.objects(Routine.self)
        
        //update rowNum
        routines.rowNum = routineRealm.count
        
        //set alphas to 0
        for _ in 0..<routines.rowNum{
            routines.alphaOfCells.append(0)
        }
        
        routines.viewDidAppear(false)
        
        checkShouldTutorial()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MainView"{
            mainContainerController = segue.destination as! TabBarController
            
            //set category delegate
            categories = mainContainerController.viewControllers![0] as! Categories
            categories.delegate = self
            
            //set planner delegate
            planner = mainContainerController.viewControllers![1] as! Planner
            planner.delegate = self
            
            //set routine
            routines = mainContainerController.viewControllers![2] as! Routines
            
            //set stopwatch
            stopwatch = mainContainerController.viewControllers![3] as! Stopwatch
            
            //set charts delegate
            charts = mainContainerController.viewControllers![4] as! Charts
            charts.delegate = self
            
            //set timeline delegate
            timeline = mainContainerController.viewControllers![5] as! Timeline
            timeline.delegate = self
        }
            
        else if segue.identifier == "TabBar"{
            let tabBarContainer = segue.destination as! TabBar

            tabBarContainer.delegate = self
            
        }
            
        else if segue.identifier == "CalendarPopup"{
            cPopup = segue.destination as! CalendarPopup
            
            cPopup.delegate = self
        }
            
        else if segue.identifier == "NewCategory"{
            categoryPopup = segue.destination as! CategoryPopup
            
            categoryPopup.delegate = self
        }
            
        else if segue.identifier == "LaunchScreenVC"{
            let launchScreenVC = segue.destination as! LaunchScreenVC
            
            launchScreenVC.delegate = self
        }
    }
    
    func switchTab(index: Int){
        mainContainerController.selectedIndex = index
        selectedIndex = index
        
        checkShouldTutorial()
    }
}

extension MainController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //page one
        if indexPath.row == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PageOne", for: indexPath) as! PageOneOnboarding
            
            cell.delegate = self
            
            if screenWidth == 375 && screenHeight == 812{
                cell.labelOne.frame = CGRect(x: 135, y: 70, width: 104, height: 104)
                cell.labelTwo.frame = CGRect(x: 40, y: 214, width: 295, height: 78)
                cell.labelThree.frame = CGRect(x: 40, y: 332, width: 295, height: 125)
                cell.continueButton.frame = CGRect(x: 40, y: 517, width: 295, height: 70)
                cell.noThankYouButton.frame = CGRect(x: 40, y: 637, width: 295, height: 70)
            }
            else if screenWidth == 414 && screenHeight == 736{
                cell.labelOne.frame = CGRect(x: 155, y: 50, width: 104, height: 104)
                cell.labelTwo.frame = CGRect(x: 50, y: 194, width: 314, height: 78)
                cell.labelThree.frame = CGRect(x: 50, y: 312, width: 314, height: 125)
                cell.continueButton.frame = CGRect(x: 50, y: 487, width: 314, height: 70)
                cell.noThankYouButton.frame = CGRect(x: 50, y: 597, width: 314, height: 70)
            }
            else if screenWidth == 375 && screenHeight == 667{
                cell.labelOne.frame = CGRect(x: 142, y: 50, width: 91, height: 91)
                cell.labelOne.font = cell.labelOne.font.withSize(70)
                cell.labelTwo.frame = CGRect(x: 40, y: 191, width: 295, height: 65)
                cell.labelTwo.font = cell.labelTwo.font.withSize(25)
                cell.labelThree.frame = CGRect(x: 31, y: 306, width: 304, height: 98)
                cell.labelThree.font = cell.labelThree.font.withSize(25)
                cell.continueButton.frame = CGRect(x: 40, y: 454, width: 295, height: 60)
                cell.continueButton.titleLabel?.font = cell.continueButton.titleLabel?.font.withSize(25)
                cell.noThankYouButton.frame = CGRect(x: 40, y: 554, width: 295, height: 60)
                cell.noThankYouButton.titleLabel?.font = cell.noThankYouButton.titleLabel?.font.withSize(25)
            }
            else if screenWidth == 320 && screenHeight == 568{
                cell.labelOne.frame = CGRect(x: 121, y: 60, width: 78, height: 78)
                cell.labelOne.font = cell.labelOne.font.withSize(60)
                cell.labelTwo.frame = CGRect(x: 103, y: 178, width: 115, height: 52)
                cell.labelTwo.font = cell.labelTwo.font.withSize(20)
                cell.labelThree.frame = CGRect(x: 40, y: 270, width: 240, height: 78)
                cell.labelThree.font = cell.labelThree.font.withSize(20)
                cell.continueButton.frame = CGRect(x: 40, y: 388, width: 240, height: 50)
                cell.continueButton.titleLabel?.font = cell.continueButton.titleLabel?.font.withSize(20)
                cell.noThankYouButton.frame = CGRect(x: 40, y: 468, width: 240, height: 50)
                cell.noThankYouButton.titleLabel?.font = cell.noThankYouButton.titleLabel?.font.withSize(20)
            }
            else if screenWidth == 768 && screenHeight == 1024{
                cell.labelOne.frame = CGRect(x: 306, y: 50, width: 156, height: 156)
                cell.labelOne.font = cell.labelOne.font.withSize(120)
                cell.labelTwo.frame = CGRect(x: 50, y: 256, width: 668, height: 130)
                cell.labelTwo.font = cell.labelTwo.font.withSize(50)
                cell.labelThree.frame = CGRect(x: 50, y: 436, width: 668, height: 195)
                cell.labelThree.font = cell.labelThree.font.withSize(50)
                cell.continueButton.frame = CGRect(x: 50, y: 691, width: 668, height: 100)
                cell.continueButton.titleLabel?.font = cell.continueButton.titleLabel?.font.withSize(50)
                cell.noThankYouButton.frame = CGRect(x: 50, y: 831, width: 668, height: 100)
                cell.noThankYouButton.titleLabel?.font = cell.noThankYouButton.titleLabel?.font.withSize(50)
            }
            else if screenWidth == 834 && screenHeight == 1194{
                cell.labelOne.frame = CGRect(x: 327, y: 80, width: 181, height: 182)
                cell.labelOne.font = cell.labelOne.font.withSize(140)
                cell.labelTwo.frame = CGRect(x: 50, y: 322, width: 734, height: 143)
                cell.labelTwo.font = cell.labelTwo.font.withSize(55)
                cell.labelThree.frame = CGRect(x: 50, y: 525, width: 734, height: 215)
                cell.labelThree.font = cell.labelThree.font.withSize(55)
                cell.continueButton.frame = CGRect(x: 50, y: 800, width: 734, height: 120)
                cell.continueButton.titleLabel?.font = cell.continueButton.titleLabel?.font.withSize(55)
                cell.noThankYouButton.frame = CGRect(x: 50, y: 970, width: 734, height: 120)
                cell.noThankYouButton.titleLabel?.font = cell.noThankYouButton.titleLabel?.font.withSize(55)
            }
            else if screenWidth == 834 && screenHeight == 1112{
                cell.labelOne.frame = CGRect(x: 333, y: 60, width: 168, height: 169)
                cell.labelOne.font = cell.labelOne.font.withSize(130)
                cell.labelTwo.frame = CGRect(x: 50, y: 279, width: 734, height: 143)
                cell.labelTwo.font = cell.labelTwo.font.withSize(55)
                cell.labelThree.frame = CGRect(x: 50, y: 472, width: 734, height: 215)
                cell.labelThree.font = cell.labelThree.font.withSize(55)
                cell.continueButton.frame = CGRect(x: 50, y: 757, width: 734, height: 110)
                cell.continueButton.titleLabel?.font = cell.continueButton.titleLabel?.font.withSize(55)
                cell.noThankYouButton.frame = CGRect(x: 50, y: 917, width: 734, height: 110)
                cell.noThankYouButton.titleLabel?.font = cell.noThankYouButton.titleLabel?.font.withSize(55)
            }
            else if screenWidth == 1024 && screenHeight == 1366{
                cell.labelOne.frame = CGRect(x: 409, y: 90, width: 207, height: 208)
                cell.labelOne.font = cell.labelOne.font.withSize(160)
                cell.labelTwo.frame = CGRect(x: 100, y: 358, width: 824, height: 156)
                cell.labelTwo.font = cell.labelTwo.font.withSize(60)
                cell.labelThree.frame = CGRect(x: 100, y: 574, width: 824, height: 234)
                cell.labelThree.font = cell.labelThree.font.withSize(60)
                cell.continueButton.frame = CGRect(x: 100, y: 908, width: 824, height: 140)
                cell.continueButton.titleLabel?.font = cell.continueButton.titleLabel?.font.withSize(60)
                cell.noThankYouButton.frame = CGRect(x: 100, y: 1108, width: 824, height: 140)
                cell.noThankYouButton.titleLabel?.font = cell.noThankYouButton.titleLabel?.font.withSize(60)
            }
            else if screenWidth == 810 && screenHeight == 1080{
                cell.labelOne.frame = CGRect(x: 321, y: 50, width: 168, height: 169)
                cell.labelOne.font = cell.labelOne.font.withSize(130)
                cell.labelTwo.frame = CGRect(x: 50, y: 269, width: 710, height: 143)
                cell.labelTwo.font = cell.labelTwo.font.withSize(55)
                cell.labelThree.frame = CGRect(x: 50, y: 462, width: 710, height: 215)
                cell.labelThree.font = cell.labelThree.font.withSize(55)
                cell.continueButton.frame = CGRect(x: 50, y: 737, width: 710, height: 110)
                cell.continueButton.titleLabel?.font = cell.continueButton.titleLabel?.font.withSize(55)
                cell.noThankYouButton.frame = CGRect(x: 50, y: 897, width: 710, height: 110)
                cell.noThankYouButton.titleLabel?.font = cell.noThankYouButton.titleLabel?.font.withSize(55)
            }
            return cell
        }
        
        //page two
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PageTwo", for: indexPath) as! PageTwoOnboarding
        
        cell.delegate = self

        if screenWidth == 375 && screenHeight == 812{
            cell.labelOne.frame = CGRect(x: 40, y: 70, width: 295, height: 158)
            cell.labelTwo.frame = CGRect(x: 40, y: 268, width: 295, height: 164)
            cell.enableNotificationsButton.frame = CGRect(x: 40, y: 517, width: 295, height: 70)
            cell.noThankYouButton.frame = CGRect(x: 40, y: 637, width: 295, height: 70)
        }
        else if screenWidth == 414 && screenHeight == 736{
            cell.labelOne.frame = CGRect(x: 50, y: 50, width: 314, height: 158)
            cell.labelTwo.frame = CGRect(x: 50, y: 258, width: 314, height: 164)
            cell.enableNotificationsButton.frame = CGRect(x: 50, y: 487, width: 314, height: 70)
            cell.noThankYouButton.frame = CGRect(x: 50, y: 597, width: 314, height: 70)
        }
        else if screenWidth == 375 && screenHeight == 667{
            cell.labelOne.frame = CGRect(x: 40, y: 50, width: 295, height: 117)
            cell.labelOne.font = cell.labelOne.font.withSize(45)
            cell.labelTwo.frame = CGRect(x: 40, y: 220, width: 295, height: 98)
            cell.labelTwo.font = cell.labelTwo.font.withSize(25)
            cell.enableNotificationsButton.frame = CGRect(x: 40, y: 454, width: 295, height: 60)
            cell.enableNotificationsButton.titleLabel?.font = cell.enableNotificationsButton.titleLabel?.font.withSize(25)
            cell.noThankYouButton.frame = CGRect(x: 40, y: 554, width: 295, height: 60)
            cell.noThankYouButton.titleLabel?.font = cell.noThankYouButton.titleLabel?.font.withSize(25)
        }
        else if screenWidth == 320 && screenHeight == 568{
            cell.labelOne.frame = CGRect(x: 40, y: 60, width: 240, height: 104)
            cell.labelOne.font = cell.labelOne.font.withSize(40)
            cell.labelTwo.frame = CGRect(x: 40, y: 236, width: 240, height: 78)
            cell.labelTwo.font = cell.labelTwo.font.withSize(20)
            cell.enableNotificationsButton.frame = CGRect(x: 40, y: 388, width: 240, height: 50)
            cell.enableNotificationsButton.titleLabel?.font = cell.enableNotificationsButton.titleLabel?.font.withSize(20)
            cell.noThankYouButton.frame = CGRect(x: 40, y: 468, width: 240, height: 50)
            cell.noThankYouButton.titleLabel?.font = cell.noThankYouButton.titleLabel?.font.withSize(20)
        }
        else if screenWidth == 768 && screenHeight == 1024{
            cell.labelOne.frame = CGRect(x: 50, y: 50, width: 668, height: 234)
            cell.labelOne.font = cell.labelOne.font.withSize(90)
            cell.labelTwo.frame = CGRect(x: 50, y: 334, width: 668, height: 195)
            cell.labelTwo.font = cell.labelTwo.font.withSize(50)
            cell.enableNotificationsButton.frame = CGRect(x: 50, y: 691, width: 668, height: 100)
            cell.enableNotificationsButton.titleLabel?.font = cell.enableNotificationsButton.titleLabel?.font.withSize(50)
            cell.noThankYouButton.frame = CGRect(x: 50, y: 831, width: 668, height: 100)
            cell.noThankYouButton.titleLabel?.font = cell.noThankYouButton.titleLabel?.font.withSize(50)
        }
        else if screenWidth == 834 && screenHeight == 1194{
            cell.labelOne.frame = CGRect(x: 50, y: 80, width: 734, height: 260)
            cell.labelOne.font = cell.labelOne.font.withSize(100)
            cell.labelTwo.frame = CGRect(x: 50, y: 400, width: 734, height: 215)
            cell.labelTwo.font = cell.labelTwo.font.withSize(55)
            cell.enableNotificationsButton.frame = CGRect(x: 50, y: 800, width: 734, height: 120)
            cell.enableNotificationsButton.titleLabel?.font = cell.enableNotificationsButton.titleLabel?.font.withSize(55)
            cell.noThankYouButton.frame = CGRect(x: 50, y: 970, width: 734, height: 120)
            cell.noThankYouButton.titleLabel?.font = cell.noThankYouButton.titleLabel?.font.withSize(55)
        }
        else if screenWidth == 834 && screenHeight == 1112{
            cell.labelOne.frame = CGRect(x: 50, y: 60, width: 734, height: 260)
            cell.labelOne.font = cell.labelOne.font.withSize(100)
            cell.labelTwo.frame = CGRect(x: 50, y: 370, width: 734, height: 215)
            cell.labelTwo.font = cell.labelTwo.font.withSize(55)
            cell.enableNotificationsButton.frame = CGRect(x: 50, y: 757, width: 734, height: 110)
            cell.enableNotificationsButton.titleLabel?.font = cell.enableNotificationsButton.titleLabel?.font.withSize(55)
            cell.noThankYouButton.frame = CGRect(x: 50, y: 917, width: 734, height: 110)
            cell.noThankYouButton.titleLabel?.font = cell.noThankYouButton.titleLabel?.font.withSize(55)
        }
        else if screenWidth == 1024 && screenHeight == 1366{
            cell.labelOne.frame = CGRect(x: 100, y: 90, width: 824, height: 286)
            cell.labelOne.font = cell.labelOne.font.withSize(110)
            cell.labelTwo.frame = CGRect(x: 100, y: 436, width: 824, height: 234)
            cell.labelTwo.font = cell.labelTwo.font.withSize(60)
            cell.enableNotificationsButton.frame = CGRect(x: 100, y: 908, width: 824, height: 140)
            cell.enableNotificationsButton.titleLabel?.font = cell.enableNotificationsButton.titleLabel?.font.withSize(60)
            cell.noThankYouButton.frame = CGRect(x: 100, y: 1108, width: 824, height: 140)
            cell.noThankYouButton.titleLabel?.font = cell.noThankYouButton.titleLabel?.font.withSize(60)
        }
        else if screenWidth == 810 && screenHeight == 1080{
            cell.labelOne.frame = CGRect(x: 50, y: 50, width: 710, height: 260)
            cell.labelOne.font = cell.labelOne.font.withSize(100)
            cell.labelTwo.frame = CGRect(x: 50, y: 360, width: 710, height: 215)
            cell.labelTwo.font = cell.labelTwo.font.withSize(55)
            cell.enableNotificationsButton.frame = CGRect(x: 50, y: 737, width: 710, height: 110)
            cell.enableNotificationsButton.titleLabel?.font = cell.enableNotificationsButton.titleLabel?.font.withSize(55)
            cell.noThankYouButton.frame = CGRect(x: 50, y: 897, width: 710, height: 110)
            cell.noThankYouButton.titleLabel?.font = cell.noThankYouButton.titleLabel?.font.withSize(55)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth, height: screenHeight)
    }
    
    //change page control
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.section
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        
        pageControl.currentPage = Int(x/view.frame.width)
    }
}

extension MainController: toMainView{
    func calendarDown(days: Int, months: Int) {
        //change highlighted view and scroll to calendar
        cPopup.highlightedMonth = months
        cPopup.highlightedDay = days
        cPopup.collectionView.reloadData()
        cPopup.collectionView.scrollToItem(at: [0,months], at: .centeredHorizontally, animated: false)
        
        //haptic feedback
        mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
        mediumGenerator?.prepare()
        mediumGenerator?.impactOccurred()
        mediumGenerator = nil
        
        //pulldown view
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.25, options: .curveEaseOut, animations: {
            self.calendarContainerView.frame.origin.y = (self.screenHeight - self.calendarContainerView.frame.size.height)/2
        }, completion: nil)
        
        calendarDown = true
        
        //blur surrounding
        blurView.isHidden = false
        
        calendarTutorial()
    }
    
    func calendarUp() {
        //retract view
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations:{
            self.calendarContainerView.frame.origin.y = -self.calendarContainerView.frame.size.height
            }, completion: nil)
        
        calendarDown = false
        
        cPopup.isYearEnabled = false
        
        //blur surrounding
        blurView.isHidden = true
    }
}

extension MainController: registerPress{
    func registerPress(day: Int, monthsSince: Int) {
        
        let selectionGenerator = UISelectionFeedbackGenerator()
        selectionGenerator.selectionChanged()
        
        //if planner selected
        if selectedIndex == 1{
            planner.registerPress(day: day, monthsSince: monthsSince)
        }
        
        //if charts selected
        else if selectedIndex == 4{
            charts.changeDate(day: day, monthsSince: monthsSince)
            
        }
        
        //if timeline selected
        else if selectedIndex == 5{
            timeline.changeDate(day: day, monthsSince: monthsSince)
        }
    }
}

extension MainController: bringCategoryPopup{
    func bringPopup() {
        
        //retract view (only for XR)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.25, options: .curveEaseOut, animations: {
            
            self.newCategory.frame.origin.y = (self.screenHeight - self.newCategory.frame.size.height)/2
            
        }, completion: nil)
        
        popupDown = true
        //blur surrounding
        blurView.isHidden = false
    }
    
    func editPopup(path: Int) {
        //retract view (only for XR)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.25, options: .curveEaseOut, animations: {
            
            self.newCategory.frame.origin.y = (self.screenHeight - self.newCategory.frame.size.height)/2
            
        }, completion: nil)
        
        popupDown = true
        
        //blur surrounding
        blurView.isHidden = false
        
        //popup is editing
        categoryPopup.isEditingPopup = true
        categoryPopup.editingPopupIndexPath = path
        categoryPopup.editPopup()
    }
}

extension MainController: dismissPopup{
    func bringPopupUp() {
        //retract view (only for XR)
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            
            self.newCategory.frame.origin.y = -self.newCategory.frame.size.height
            
        }, completion: nil)
        
        categories.tableView.reloadData()
        
        popupDown = false
        
        //blur surrounding
        blurView.isHidden = true
    }
    
    func showTutorial() {
        if shouldCustomColorTutorial == true{
            //check - for if custom color is tutorialized in a segue
            let realm = try! Realm()
            
            let firstRealmTutorial = realm.objects(ShouldTutorial.self)[0]
            
            if firstRealmTutorial.shouldCustomColorTutorial == false{
                shouldCustomColorTutorial = false
                return
            }
            
            customColorState = 1
            
            //show customColorTutorial
            let customColorPoint = categoryPopup.customColor.superview?.convert(categoryPopup.customColor.frame.origin, to: nil) ?? CGPoint(x: 0, y: 0)
            
            holeBlurView(CGRect(x: customColorPoint.x, y: customColorPoint.y, width: categoryPopup.customColor.frame.size.width, height: categoryPopup.customColor.frame.size.height))
            
            tutorialBlurView.isHidden = false
            tutorialMoveOnButton.isHidden = false

            //setup of tutorial and text
            tutorialView.isHidden = false
            flippedTriangle.isHidden = false
            
            flippedTriangle.center.x = screenWidth/2
            flippedTriangle.frame.origin.y = customColorPoint.y - 5 - flippedTriangle.frame.size.height
            
            tutorialLabel.frame.size = CGSize(width: screenWidth - 2 * tutorialSpacingWidth, height: 100)
            tutorialLabel.text = "Tap and HOLD for the desired color."
            tutorialLabel.sizeToFit()
            
            tutorialLabel.center.x = screenWidth/2
            tutorialLabel.frame.origin.y = 20
            
            tutorialView.frame = CGRect(x: 0, y: flippedTriangle.frame.origin.y - (tutorialLabel.frame.size.height + 40), width: screenWidth, height: tutorialLabel.frame.size.height + 40)
            
            //setup of animations
            let prevTV = tutorialView.frame.origin.x
            let prevT = flippedTriangle.frame.origin.x
            
            tutorialView.frame.origin.x = screenWidth
            flippedTriangle.frame.origin.x = screenWidth
            
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                self.tutorialView.frame.origin.x = prevTV
                self.flippedTriangle.frame.origin.x = prevT
            }, completion: nil)
        }
    }
}

extension MainController: pageOneOnboard{
    //continue to second page
    func continueToSecond() {
        tutorialCollectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: true)
        
        pageControl.currentPage = 1
    }
    
    //turn off tutorial
    func turnOffTutorial() {
        //turn off all the tutorials
        let realm = try! Realm()
        
        let shouldTutorial = realm.objects(ShouldTutorial.self)[0]
        
        try! realm.write{
            shouldTutorial.shouldBeginningMain = false
            shouldTutorial.shouldCategoryTutorial = false
            shouldTutorial.shouldPlannerTutorial = false
            shouldTutorial.shouldRoutineTutorial = false
            shouldTutorial.shouldStopwatchTutorial = false
            shouldTutorial.shouldChartsTutorial = false
            shouldTutorial.shouldTimelineTutorial = false
            shouldTutorial.shouldCustomColorTutorial = false
            shouldTutorial.shouldCalendarTutorial = false
        }
        shouldBeginningMain = false
        shouldCategoryTutorial = false
        shouldPlannerTutorial = false
        shouldRoutineTutorial = false
        shouldStopwatchTutorial = false
        shouldChartsTutorial = false
        shouldTimelineTutorial = false
        shouldCustomColorTutorial = false
        shouldCalendarTutorial = false
        
        pageControl.isHidden = true
        tutorialCollectionView.isHidden = true
        
        //delete tutorial task
        let taskSaved = realm.objects(TaskSaved.self).first!
        
        //delete task
        try! realm.write{
            realm.delete(taskSaved)
        }
        
        //update routines
        //call routine from realms
        let routineRealm = realm.objects(Routine.self)
        
        //update rowNum
        routines.rowNum = routineRealm.count
        
        //set alphas to 0
        for _ in 0..<routines.rowNum{
            routines.alphaOfCells.append(0)
        }
        
        //enable push notifications
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert,.sound], completionHandler:    {
            (granted, error) in
            DispatchQueue.main.async {
                self.shutOffTutorial()
            }
        })
        
        routines.viewDidAppear(false)
        
    }
}

extension MainController: pageTwoOnboard{
    func enableNotifications() {
        //enable push notifications
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert,.sound], completionHandler:    {
            (granted, error) in
            DispatchQueue.main.async {
                self.shutOffTutorial()
            }
        })
    }
    
    func endTutorial() {
        shutOffTutorial()
    }
}

extension MainController: hideLaunchScreen{
    func hideLaunchScreen() {
        splashScreenView.isHidden = true
    }
}
