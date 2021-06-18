//
//  NewTask.swift
//  TimeKeep
//
//  Created by Mi Yan on 4/27/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//

import UIKit
import RealmSwift
import CircleColorPicker
import BEMCheckBox

class NewTask: UIViewController, UITextFieldDelegate {

    //custom segment control
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var alarmAnimate: UIView!
    
    @IBOutlet weak var mainView: UIView!
    
    //how much to increase mainview for a new alarm
    var alarmUpdateConstant: CGFloat = 96
    
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var x: UIButton!
    
    @IBOutlet weak var checkMark: UIButton!
    
    @IBOutlet weak var deleteView: UIView!
    
    var alarmHour = 0
    var alarmMinute = 0
    
    // 0 - no alarm set, 1 - alarm set
    var selectedSegment = 0
    
    @IBOutlet weak var customText: UILabel!
    
    @IBOutlet weak var timeTextField: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var customColor: CircleColorPickerView!
    
    //tableView has some weird properties
    var tableViewYConstant: CGFloat = 658
    
    //all colors for color picker
    var colorArray: [UIColor] =
    [UIColor(hue: 0.0, saturation: 1.0, brightness: 1, alpha: 1),
    UIColor(hue: 0.0, saturation: 0.667, brightness: 1, alpha: 1),
    UIColor(hue: 0.0, saturation: 0.333, brightness: 1, alpha: 1),
    UIColor(hue: 0.083, saturation: 1.0, brightness: 1, alpha: 1),
    UIColor(hue: 0.083, saturation: 0.667, brightness: 1, alpha: 1),
    UIColor(hue: 0.083, saturation: 0.333, brightness: 1, alpha: 1),
    UIColor(hue: 0.167, saturation: 1.0, brightness: 1, alpha: 1),
    UIColor(hue: 0.167, saturation: 0.667, brightness: 1, alpha: 1),
    UIColor(hue: 0.167, saturation: 0.333, brightness: 1, alpha: 1),
    UIColor(hue: 0.25, saturation: 1.0, brightness: 1, alpha: 1),
    UIColor(hue: 0.25, saturation: 0.667, brightness: 1, alpha: 1),
    UIColor(hue: 0.25, saturation: 0.333, brightness: 1, alpha: 1),
    UIColor(hue: 0.333, saturation: 1.0, brightness: 1, alpha: 1),
    UIColor(hue: 0.333, saturation: 0.667, brightness: 1, alpha: 1),
    UIColor(hue: 0.333, saturation: 0.333, brightness: 1, alpha: 1),
    UIColor(hue: 0.417, saturation: 1.0, brightness: 1, alpha: 1),
    UIColor(hue: 0.417, saturation: 0.667, brightness: 1, alpha: 1),
    UIColor(hue: 0.417, saturation: 0.333, brightness: 1, alpha: 1),
    UIColor(hue: 0.5, saturation: 1.0, brightness: 1, alpha: 1),
    UIColor(hue: 0.5, saturation: 0.667, brightness: 1, alpha: 1),
    UIColor(hue: 0.5, saturation: 0.333, brightness: 1, alpha: 1),
    UIColor(hue: 0.583, saturation: 1.0, brightness: 1, alpha: 1),
    UIColor(hue: 0.583, saturation: 0.667, brightness: 1, alpha: 1),
    UIColor(hue: 0.583, saturation: 0.333, brightness: 1, alpha: 1),
    UIColor(hue: 0.667, saturation: 1.0, brightness: 1, alpha: 1),
    UIColor(hue: 0.667, saturation: 0.667, brightness: 1, alpha: 1),
    UIColor(hue: 0.667, saturation: 0.333, brightness: 1, alpha: 1),
    UIColor(hue: 0.75, saturation: 1.0, brightness: 1, alpha: 1),
    UIColor(hue: 0.75, saturation: 0.667, brightness: 1, alpha: 1),
    UIColor(hue: 0.75, saturation: 0.333, brightness: 1, alpha: 1),
    UIColor(hue: 0.833, saturation: 1.0, brightness: 1, alpha: 1),
    UIColor(hue: 0.833, saturation: 0.667, brightness: 1, alpha: 1),
    UIColor(hue: 0.833, saturation: 0.333, brightness: 1, alpha: 1),
    UIColor(hue: 0.917, saturation: 1.0, brightness: 1, alpha: 1),
    UIColor(hue: 0.917, saturation: 0.667, brightness: 1, alpha: 1),
    UIColor(hue: 0.917, saturation: 0.333, brightness: 1, alpha: 1)
    ]
    
    //which one to save - end date, start date, or alarm date
    enum DateChosen{
        case startDate
        case endDate
        case alarmDate
        case neither
    }
    
    //if alarms are enabled
    var alarmsEnabled: Bool = true
    
    //colorPicker
    @IBOutlet weak var colorPicker: UICollectionView!
    
    //haptic feedback
    var mediumGenerator: UIImpactFeedbackGenerator? = nil
    
    //is editing
    var isEditingNewTask = false
    var editingPath: Int = 0
    
    //is editing color number
    var isEditingColorNum: Int = -1
    
    //get CalendarPopup
    var calendarContainer = CalendarPopup()
    
    //start, alarm, and end dates
    var startMonth: Int = -1
    var startDay: Int = -1
    @IBOutlet weak var startLabel: UILabel!
    
    var endMonth: Int = -1
    var endDay: Int = -1
    @IBOutlet weak var endLabel: UILabel!
    
    var alarmMonth: Int = -1
    var alarmDay: Int = -1
    @IBOutlet weak var alarmLabel: UILabel!
    
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var blurButton: UIButton!
    
    //actual save button
    @IBOutlet weak var saveButton: UIButton!
    
    //instantiate enum which tells what to save to for the calendar
    var whichDate = DateChosen.neither
    
    //array of months for label
    var monthArray: [String] = ["January","February","March","April","May","June","July", "August","September","October","November","December"]
    
    //color selected from colorpicker -- -1 = no cell chosen
    var cellNumber = -1
    
    //get selected category #
    var categoryNum = -1
    
    //if textfield is not empty
    var textFieldFilled = false
    
    //if a color is chosen
    var isColorChosen = false
    var colorChosen = UIColor.clear
    
    //which tableview selected
    var tableViewRowHeight: CGFloat = 44
    
    //main calendar view
    @IBOutlet weak var calendarContainerView: UIView!
    
    @IBOutlet weak var customButton: UIButton!
    
    //buttons
    @IBOutlet weak var startDateButton: UIButton!
    @IBOutlet weak var endDateButton: UIButton!
    @IBOutlet weak var alarmDateButton: UIButton!
    
    //resize
    var screenHeight: CGFloat = 0
    var screenWidth: CGFloat = 0
    
    @IBOutlet weak var alarmTypeView: UIView!
    
    @IBOutlet weak var trashCanIconImageView: UIImageView!
    @IBOutlet weak var trashCanButton: UIButton!
    
    //labels
    @IBOutlet weak var newTask: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var alarmL: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var alarmDateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    //seperators
    @IBOutlet weak var firstSeperator: UIView!
    @IBOutlet weak var secondSeperator: UIView!
    @IBOutlet weak var thirdSeperator: UIView!
    @IBOutlet weak var fourthSeperator: UIView!
    @IBOutlet weak var fifthSeperator: UIView!
    @IBOutlet weak var sixthSeperator: UIView!
    
    //dateViews
    @IBOutlet weak var startDateView: UIView!
    @IBOutlet weak var alarmDateView: UIView!
    @IBOutlet weak var endDateView: UIView!
    
    //cell size constant
    var cellSizeConstant: CGFloat = 50
    var cellSpacing: CGFloat = 4
    
    //editing days since
    var editingDaysSince: Int = 0
    
    //tutorial for custom color & calendar
    @IBOutlet weak var tutorialBlurView: UIView!
    @IBOutlet weak var flippedTriangle: UIImageView!
    @IBOutlet weak var triangle: UIImageView!
    @IBOutlet weak var tutorialView: UIView!
    @IBOutlet weak var tutorialLabel: UILabel!
    @IBOutlet weak var moveOnButton: UIButton!
    
    var customColorState = 0
    var shouldCustomColorTutorial = false
    
    var calendarState = 0
    var shouldCalendarTutorial = false
    
    //spacing for resizing
    var tutorialSpacingWidth: CGFloat = 24
    var calendarTutorialSpacingHeight: CGFloat = 20
    var tutorialScreenWidth: CGFloat = 0
    
    //if has viewDidAppeared before
    var hasViewDidAppearBefore: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //custom color picker setup
        customColor.delegate = self

        //resize everything
        let screen = UIScreen.main.bounds
        screenWidth = screen.size.width
        screenHeight = screen.size.height
        
        //standard tableview setup
        tableView.delegate = self
        tableView.dataSource = self
        
        //set tableview border color
        tableView.layer.borderColor = UIColor.black.cgColor
        tableView.layer.borderWidth = 2
        nameTextField.delegate = self
        
        //set custom color to hidden and color picker to not hidden
        customColor.isHidden = true
        colorPicker.isHidden = false
        
        //dismiss if tapped
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        contentView.addGestureRecognizer(tapGesture)
        
        //date picker as keyboard
        timeTextField.setInputViewDatePicker(target: self, selector: #selector(tapDone))
        
        resizeDevice()
        
        //no alarm date setup
        contentViewHeightConstraint.constant -= alarmUpdateConstant
        saveButton.frame.origin.y -= alarmUpdateConstant
        deleteView.frame.origin.y -= alarmUpdateConstant
        mainView.frame.size.height -= alarmUpdateConstant
        tableView.frame.origin.y = tableViewYConstant
        
        //get if alarms are enabled
        let current = UNUserNotificationCenter.current()

        current.getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .notDetermined {
                self.alarmsEnabled = false
            } else if settings.authorizationStatus == .denied {
                self.alarmsEnabled = false
            } else if settings.authorizationStatus == .authorized {
                self.alarmsEnabled = true
            }
        })
        
        //check if custom color tutorial
        let realm = try! Realm()
        
        let firstRealmTutorial = realm.objects(ShouldTutorial.self)[0]
        
        if firstRealmTutorial.shouldCustomColorTutorial == true{
            shouldCustomColorTutorial = true
        }
        if firstRealmTutorial.shouldCalendarTutorial == true{
            shouldCalendarTutorial = true
        }
        
        //setup
        
        //Jan 1 2020
        var dateComponents = DateComponents()
        dateComponents.year = 2020
        dateComponents.month = 1
        dateComponents.day = 1
        
        let firstDate = Calendar.current.date(from: dateComponents)!
        
        //get current date month since Jan 1 2020
        let monthFromFirstMonth: Int = Calendar.current.dateComponents([.month], from: firstDate, to: Date()).month ?? 0
        
        //get current day
        let currentDay: Int = Calendar.current.dateComponents([.day], from: Date()).day ?? 0
        //if not editing - set start,end, and alarm dates
        if isEditingNewTask == false{
            //set start, end, and alarm dates to the current day
            startMonth = monthFromFirstMonth
            startDay = currentDay
            startLabel.text = "\(monthArray[monthFromFirstMonth % 12]) \(currentDay), \(Int(monthFromFirstMonth/12) + 2020)"
            
            endMonth = monthFromFirstMonth
            endDay = currentDay
            endLabel.text = "\(monthArray[monthFromFirstMonth % 12]) \(currentDay), \(Int(monthFromFirstMonth/12) + 2020)"
            
            alarmMonth = monthFromFirstMonth
            alarmDay = currentDay
            alarmLabel.text = "\(monthArray[monthFromFirstMonth % 12]) \(currentDay), \(Int(monthFromFirstMonth/12) + 2020)"
            
            
            //set alarm time as the alarm hour and minute from today and the current date
            let date = Date()
            
            let alarmTime = Calendar.current.dateComponents([.hour,.minute], from: date)
            
            alarmHour = alarmTime.hour ?? 0
            alarmMinute = alarmTime.minute ?? 0

            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .short
            dateFormatter.dateStyle = .none
            timeTextField.text = dateFormatter.string(from: date)
            
        }
        
        //if editing
        else{
            
            let realm = try! Realm()

            //get task being edited
            //Jan 1 2020
            var dateComponents = DateComponents()
            dateComponents.year = 2020
            dateComponents.month = 1
            dateComponents.day = 1
            
            let firstDate = Calendar.current.date(from: dateComponents)!
            
            //calculations to find what month and day it is
            var daysAdded = DateComponents()
            daysAdded.day = editingDaysSince
            
            let newDate = Calendar.current.date(byAdding: daysAdded, to: firstDate)!
            
            let monthSince = Calendar.current.dateComponents([.month], from: firstDate, to: newDate).month ?? 0
            
            let daySince = Calendar.current.dateComponents([.day], from: newDate).day ?? 0
            
            //filter out saved tasks for the displayed day
            let taskSaved = realm.objects(TaskSaved.self).filter("startMonth <= %@ AND startDay <= %@ AND endMonth >= %@ AND endDay >= %@", monthSince,daySince,monthSince,daySince)
            
            let taskBeingEdited = taskSaved[editingPath]

            //set category field name
            nameTextField.text = taskBeingEdited.name
            textFieldFilled = true
            
            //set color
            
            //set category
            categoryNum = taskBeingEdited.category
            
            //set alarm enabled
            if taskBeingEdited.alarmEnabled == true{
                selectedSegment = 1
                alarmAnimate.frame.origin = checkMark.frame.origin
            }
            else{
                selectedSegment = 0
                alarmAnimate.frame.origin = x.frame.origin
            }
            
            //set start, end, and alarm dates to the current day
            startMonth = taskBeingEdited.startMonth
            startDay = taskBeingEdited.startDay
            startLabel.text = "\(monthArray[taskBeingEdited.startMonth % 12]) \(taskBeingEdited.startDay), \(Int(taskBeingEdited.startMonth/12) + 2020)"
            
            endMonth = taskBeingEdited.endMonth
            endDay = taskBeingEdited.endDay
            endLabel.text = "\(monthArray[taskBeingEdited.endMonth % 12]) \(taskBeingEdited.endDay), \(Int(taskBeingEdited.endMonth/12) + 2020)"
            
            //change color to the custom color
            let categoryColorTemp = UIColor(hue: CGFloat(taskBeingEdited.h), saturation: CGFloat(taskBeingEdited.s), brightness: CGFloat(taskBeingEdited.b), alpha: CGFloat(taskBeingEdited.a))
            
            //change it to custom color
            colorChosen = categoryColorTemp
            
            //enable custom and disable premade
            customColor.color = colorChosen.cgColor
            
            //isEditing colorNumber for ViewDidAppear
            isEditingColorNum = taskBeingEdited.colorNum
            
            isColorChosen = true
            
            //if alarm is enabled
            if taskBeingEdited.alarmEnabled ==  true{
                alarmMonth = taskBeingEdited.alarmMonth
                alarmDay = taskBeingEdited.alarmDay
                alarmLabel.text = "\(monthArray[taskBeingEdited.alarmMonth % 12]) \(taskBeingEdited.alarmDay), \(Int(taskBeingEdited.alarmMonth/12) + 2020)"
                
                //set alarm time as the alarm hour and minute from today and the current date
                let date = Date()
                
                let alarmTime = Calendar.current.dateComponents([.hour,.minute], from: date)
                
                alarmHour = alarmTime.hour ?? 0
                alarmMinute = alarmTime.minute ?? 0

                let dateFormatter = DateFormatter()
                dateFormatter.timeStyle = .short
                dateFormatter.dateStyle = .none
                timeTextField.text = dateFormatter.string(from: date)
            }
                
            //else set alarm to the date right now
            else{
                alarmMonth = monthFromFirstMonth
                alarmDay = currentDay
                alarmLabel.text = "\(monthArray[monthFromFirstMonth % 12]) \(currentDay), \(Int(monthFromFirstMonth/12) + 2020)"
                
                //set alarm time as the alarm hour and minute from today and the current date
                let date = Date()
                
                let alarmTime = Calendar.current.dateComponents([.hour,.minute], from: date)
                
                alarmHour = alarmTime.hour ?? 0
                alarmMinute = alarmTime.minute ?? 0

                let dateFormatter = DateFormatter()
                dateFormatter.timeStyle = .short
                dateFormatter.dateStyle = .none
                timeTextField.text = dateFormatter.string(from: date)
            }
            
            checkSaveEnable()
        }
        
        //standard delegate collectionview
        colorPicker.delegate = self
        colorPicker.dataSource = self
        
        //register taps on the collectionview
        let collectionViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapColorPicker(_:)))
        colorPicker.addGestureRecognizer(collectionViewTapGesture)
        
        //register taps on the tableview
        let tableViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapTableView(_:)))
        tableView.addGestureRecognizer(tableViewTapGesture)
        
        
        /*
        //register taps on the tableview
        let contentViewLongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleContentViewTap(_:)))
        contentViewLongPressGesture.minimumPressDuration = 0
        contentViewLongPressGesture.cancelsTouchesInView = false
        contentViewLongPressGesture.delegate = self
        contentView.addGestureRecognizer(contentViewLongPressGesture)*/
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        if hasViewDidAppearBefore == false{
            if isEditingNewTask == false{
                //auto select red as first color - cell 0
                colorChosen = colorArray[0]
                let tempCell = colorPicker.cellForItem(at: IndexPath(row: 0, section: 0)) as! ColorCell
                tempCell.checkMarkAnimation.setOn(true, animated: true)
                cellNumber = 0
                isColorChosen = true
                
                //set customColor Picker Color
                customColor.color = colorChosen.cgColor
            }
            
            //if editing - change color
            else{
                if isEditingColorNum >= 0{
                    colorPicker.isHidden = false
                    customColor.isHidden = true
                    
                    let tempCell = colorPicker.cellForItem(at: IndexPath(row: isEditingColorNum, section: 0)) as! ColorCell
                    tempCell.checkMarkAnimation.setOn(true, animated: true)
                    cellNumber = isEditingColorNum
                }
                else{
                    colorPicker.isHidden = true
                    customColor.isHidden = false
                }
            }
            hasViewDidAppearBefore = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        if hasViewDidAppearBefore == false{
            //blur setup and disable
            blurView.frame.size = self.view.frame.size
            blurButton.frame.size = blurView.frame.size
            blurView.isHidden = true
            
            //setup custom color picker knobs
            customColor.setupMaskImages(image: UIImage(named: "transparentCircle"))
        }
    }
    
    func resizeDevice(){
        tutorialScreenWidth = screenWidth
        if screenHeight == 812 && screenWidth == 375{
            calendarContainerView.frame = CGRect(x: 0, y: -495, width: 332, height: 495)
            calendarContainerView.center.x = 375/2
            
            newTask.font = newTask.font.withSize(35)
            newTask.frame = CGRect(x: 24, y: 33, width: 183, height: 46)
            
            mainView.frame = CGRect(x: 24, y: 103, width: 327, height: 944)
            
            nameLabel.font = nameLabel.font.withSize(15)
            nameLabel.frame = CGRect(x: 14, y: 14, width: 52, height: 20)
            
            nameTextField.font = nameTextField.font?.withSize(15)
            nameTextField.frame = CGRect(x: 71, y: 14, width: 242, height: 20)
            
            firstSeperator.frame = CGRect(x: 0, y: 48, width: 327, height: 2)
            
            colorLabel.font = colorLabel.font.withSize(15)
            colorLabel.frame = CGRect(x: 14, y: 64, width: 58, height: 20)
            
            colorPicker.frame = CGRect(x: 28, y: 98, width: 270, height: 270)
            customColor.frame = CGRect(x: 28, y: 98, width: 270, height: 270)
            
            customText.frame = CGRect(x: 119, y: 385, width: 88, height: 27)
            customButton.frame = CGRect(x: 79, y: 382, width: 168, height: 33)
            
            secondSeperator.frame = CGRect(x: 0, y: 429, width: 327, height: 2)
            
            startDateLabel.font = startDateLabel.font.withSize(15)
            startDateLabel.frame = CGRect(x: 14, y: 445, width: 89, height: 20)
            startDateView.frame = CGRect(x: 113, y: 445, width: 199, height: 20)
            startLabel.font = startLabel.font.withSize(12)
            startLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 20)
            startDateButton.frame = CGRect(x: 0, y: 0, width: 200, height: 20)
            
            thirdSeperator.frame = CGRect(x: 0, y: 479, width: 327, height: 2)
            
            endDateLabel.font = endDateLabel.font.withSize(15)
            endDateLabel.frame = CGRect(x: 14, y: 495, width: 78, height: 20)
            endDateView.frame = CGRect(x: 113, y: 495, width: 200, height: 20)
            endDateButton.frame = CGRect(x: 0, y: 0, width: 200, height: 20)
            endLabel.font = endLabel.font.withSize(12)
            endLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 20)
            
            fourthSeperator.frame = CGRect(x: 0, y: 529, width: 327, height: 2)
            
            categoryLabel.font = categoryLabel.font.withSize(15)
            categoryLabel.frame = CGRect(x: 14, y: 545, width: 85, height: 20)
            
            tableView.frame = CGRect(x: 14, y: 579, width: 299, height: 220)
            tableViewYConstant = 579
            
            fifthSeperator.frame = CGRect(x: 0, y: 813, width: 327, height: 2)
            
            alarmL.font = alarmL.font.withSize(15)
            alarmL.frame = CGRect(x: 14, y: 829, width: 58, height: 20)
            
            alarmTypeView.frame = CGRect(x: 81, y: 826, width: 232, height: 26)
            alarmAnimate.frame = CGRect(x: 0, y: 0, width: 116, height: 26)
            x.frame = CGRect(x: 0, y: 0, width: 116, height: 26)
            checkMark.frame = CGRect(x: 116, y: 0, width: 116, height: 26)
            
            sixthSeperator.frame = CGRect(x: 0, y: 863, width: 327, height: 2)
            alarmDateLabel.font = alarmDateLabel.font.withSize(15)
            alarmDateLabel.frame = CGRect(x: 14, y: 879, width: 99, height: 20)
            
            alarmDateView.frame = CGRect(x: 127, y: 879, width: 186, height: 20)
            alarmDateLabel.font = alarmDateLabel.font.withSize(15)
            alarmLabel.frame = CGRect(x: 0, y: 0, width: 186, height: 20)
            alarmLabel.font = alarmLabel.font.withSize(12)
            alarmDateButton.frame = CGRect(x: 0, y: 0, width: 186, height: 20)
            
            timeLabel.frame = CGRect(x: 14, y: 910, width: 99, height: 20)
            timeLabel.font = timeLabel.font.withSize(15)
            timeTextField.frame = CGRect(x: 127, y: 910, width: 186, height: 20)
            timeTextField.font = timeTextField.font?.withSize(12)
            
            saveButton.titleLabel?.font = saveButton.titleLabel?.font.withSize(30)
            saveButton.frame = CGRect(x: 24, y: 1061, width: 260, height: 51)
            
            deleteView.frame = CGRect(x: 294, y: 1061, width: 57, height: 51)
            trashCanButton.frame = CGRect(x: 0, y: 0, width: 57, height: 51)
            trashCanIconImageView.frame = CGRect(x: 14, y: 9, width: 29, height: 33)
            
            alarmUpdateConstant = 81
            
            contentViewHeightConstraint.constant = 1126
            
            cellSizeConstant = 40
            cellSpacing = 6
        }
        else if screenHeight == 736 && screenWidth == 414{
            tutorialLabel.font = tutorialLabel.font.withSize(35)
            calendarTutorialSpacingHeight = 10
        }
        else if screenHeight == 667 && screenWidth == 375{
            calendarContainerView.frame = CGRect(x: 0, y: -495, width: 332, height: 495)
            calendarContainerView.center.x = 375/2
            
            tableView.layer.borderWidth = 1
            
            tutorialLabel.font = tutorialLabel.font.withSize(30)
            calendarTutorialSpacingHeight = 10
            
            newTask.font = newTask.font.withSize(35)
            newTask.frame = CGRect(x: 24, y: 33, width: 183, height: 46)
            
            mainView.frame = CGRect(x: 24, y: 103, width: 327, height: 944)
            
            nameLabel.font = nameLabel.font.withSize(15)
            nameLabel.frame = CGRect(x: 14, y: 14, width: 52, height: 20)
            
            nameTextField.font = nameTextField.font?.withSize(15)
            nameTextField.frame = CGRect(x: 71, y: 14, width: 242, height: 20)
            
            firstSeperator.frame = CGRect(x: 0, y: 48, width: 327, height: 2)
            
            colorLabel.font = colorLabel.font.withSize(15)
            colorLabel.frame = CGRect(x: 14, y: 64, width: 58, height: 20)
            
            colorPicker.frame = CGRect(x: 28, y: 98, width: 270, height: 270)
            customColor.frame = CGRect(x: 28, y: 98, width: 270, height: 270)
            
            customText.frame = CGRect(x: 119, y: 385, width: 88, height: 27)
            customButton.frame = CGRect(x: 79, y: 382, width: 168, height: 33)
            
            secondSeperator.frame = CGRect(x: 0, y: 429, width: 327, height: 2)
            
            startDateLabel.font = startDateLabel.font.withSize(15)
            startDateLabel.frame = CGRect(x: 14, y: 445, width: 89, height: 20)
            startDateView.frame = CGRect(x: 113, y: 445, width: 199, height: 20)
            startLabel.font = startLabel.font.withSize(12)
            startLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 20)
            startDateButton.frame = CGRect(x: 0, y: 0, width: 200, height: 20)
            
            thirdSeperator.frame = CGRect(x: 0, y: 479, width: 327, height: 2)
            
            endDateLabel.font = endDateLabel.font.withSize(15)
            endDateLabel.frame = CGRect(x: 14, y: 495, width: 78, height: 20)
            endDateView.frame = CGRect(x: 113, y: 495, width: 200, height: 20)
            endDateButton.frame = CGRect(x: 0, y: 0, width: 200, height: 20)
            endLabel.font = endLabel.font.withSize(12)
            endLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 20)
            
            fourthSeperator.frame = CGRect(x: 0, y: 529, width: 327, height: 2)
            
            categoryLabel.font = categoryLabel.font.withSize(15)
            categoryLabel.frame = CGRect(x: 14, y: 545, width: 85, height: 20)
            
            tableView.frame = CGRect(x: 14, y: 579, width: 299, height: 220)
            tableViewYConstant = 579
            
            fifthSeperator.frame = CGRect(x: 0, y: 813, width: 327, height: 2)
            
            alarmL.font = alarmL.font.withSize(15)
            alarmL.frame = CGRect(x: 14, y: 829, width: 58, height: 20)
            
            alarmTypeView.frame = CGRect(x: 81, y: 826, width: 232, height: 26)
            alarmAnimate.frame = CGRect(x: 0, y: 0, width: 116, height: 26)
            x.frame = CGRect(x: 0, y: 0, width: 116, height: 26)
            checkMark.frame = CGRect(x: 116, y: 0, width: 116, height: 26)
            
            sixthSeperator.frame = CGRect(x: 0, y: 863, width: 327, height: 2)
            alarmDateLabel.font = alarmDateLabel.font.withSize(15)
            alarmDateLabel.frame = CGRect(x: 14, y: 879, width: 99, height: 20)
            
            alarmDateView.frame = CGRect(x: 127, y: 879, width: 186, height: 20)
            alarmDateLabel.font = alarmDateLabel.font.withSize(15)
            alarmLabel.frame = CGRect(x: 0, y: 0, width: 186, height: 20)
            alarmLabel.font = alarmLabel.font.withSize(12)
            alarmDateButton.frame = CGRect(x: 0, y: 0, width: 186, height: 20)
            
            timeLabel.frame = CGRect(x: 14, y: 910, width: 99, height: 20)
            timeLabel.font = timeLabel.font.withSize(15)
            timeTextField.frame = CGRect(x: 127, y: 910, width: 186, height: 20)
            timeTextField.font = timeTextField.font?.withSize(12)
            
            saveButton.titleLabel?.font = saveButton.titleLabel?.font.withSize(30)
            saveButton.frame = CGRect(x: 24, y: 1061, width: 260, height: 51)
            
            deleteView.frame = CGRect(x: 294, y: 1061, width: 57, height: 51)
            trashCanButton.frame = CGRect(x: 0, y: 0, width: 57, height: 51)
            trashCanIconImageView.frame = CGRect(x: 14, y: 9, width: 29, height: 33)
            
            alarmUpdateConstant = 81
            
            contentViewHeightConstraint.constant = 1126
            
            cellSizeConstant = 40
            cellSpacing = 6
        }
        
        else if screenHeight == 568 && screenWidth == 320{
            calendarContainerView.frame = CGRect(x: 0, y: -450, width: 280, height: 450)
            calendarContainerView.center.x = 160
            
            tableViewRowHeight = 32
            tableView.layer.borderWidth = 1
            
            calendarTutorialSpacingHeight = 5
            
            tutorialLabel.font = tutorialLabel.font.withSize(25)
            
            newTask.font = newTask.font.withSize(30)
            newTask.frame = CGRect(x: 24, y: 33, width: 157, height: 39)
            
            mainView.frame = CGRect(x: 24, y: 96, width: 272, height: 904)
            
            nameLabel.font = nameLabel.font.withSize(15)
            nameLabel.frame = CGRect(x: 14, y: 14, width: 52, height: 20)
            
            nameTextField.font = nameTextField.font?.withSize(15)
            nameTextField.frame = CGRect(x: 71, y: 14, width: 187, height: 20)
            
            firstSeperator.frame = CGRect(x: 0, y: 48, width: 272, height: 2)
            
            colorLabel.font = colorLabel.font.withSize(15)
            colorLabel.frame = CGRect(x: 14, y: 64, width: 58, height: 20)
            
            colorPicker.frame = CGRect(x: 21, y: 98, width: 230, height: 230)
            customColor.frame = CGRect(x: 21, y: 98, width: 230, height: 230)
            
            customText.frame = CGRect(x: 92, y: 345, width: 88, height: 27)
            customButton.frame = CGRect(x: 52, y: 342, width: 168, height: 33)
            
            secondSeperator.frame = CGRect(x: 0, y: 389, width: 272, height: 2)
            
            startDateLabel.font = startDateLabel.font.withSize(15)
            startDateLabel.frame = CGRect(x: 14, y: 405, width: 89, height: 20)
            startDateView.frame = CGRect(x: 113, y: 405, width: 145, height: 20)
            
            startLabel.font = startLabel.font.withSize(12)
            startLabel.frame = CGRect(x: 0, y: 0, width: 145, height: 20)
            startDateButton.frame = CGRect(x: 0, y: 0, width: 145, height: 20)
            
            thirdSeperator.frame = CGRect(x: 0, y: 439, width: 272, height: 2)
            
            endDateLabel.font = endDateLabel.font.withSize(15)
            endDateLabel.frame = CGRect(x: 14, y: 455, width: 78, height: 20)
            endDateView.frame = CGRect(x: 113, y: 455, width: 145, height: 20)
            endDateButton.frame = CGRect(x: 0, y: 0, width: 145, height: 20)
            endLabel.font = endLabel.font.withSize(12)
            endLabel.frame = CGRect(x: 0, y: 0, width: 145, height: 20)
            
            fourthSeperator.frame = CGRect(x: 0, y: 489, width: 272, height: 2)
            
            categoryLabel.font = categoryLabel.font.withSize(15)
            categoryLabel.frame = CGRect(x: 14, y: 505, width: 85, height: 20)
            
            tableView.frame = CGRect(x: 14, y: 539, width: 244, height: 220)
            tableViewYConstant = 539
            
            fifthSeperator.frame = CGRect(x: 0, y: 773, width: 272, height: 2)
            
            alarmL.font = alarmL.font.withSize(15)
            alarmL.frame = CGRect(x: 14, y: 789, width: 58, height: 20)
            
            alarmTypeView.frame = CGRect(x: 77, y: 786, width: 181, height: 26)
            alarmAnimate.frame = CGRect(x: 0, y: 0, width: 90.5, height: 26)
            x.frame = CGRect(x: 0, y: 0, width: 90.5, height: 26)
            checkMark.frame = CGRect(x: 90.5, y: 0, width: 90.5, height: 26)
            
            sixthSeperator.frame = CGRect(x: 0, y: 823, width: 327, height: 2)
            alarmDateLabel.font = alarmDateLabel.font.withSize(15)
            alarmDateLabel.frame = CGRect(x: 14, y: 839, width: 99, height: 20)
            
            alarmDateView.frame = CGRect(x: 118, y: 839, width: 140, height: 20)
            alarmDateLabel.font = alarmDateLabel.font.withSize(15)
            alarmLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 20)
            alarmLabel.font = alarmLabel.font.withSize(12)
            alarmDateButton.frame = CGRect(x: 0, y: 0, width: 140, height: 20)
            
            timeLabel.frame = CGRect(x: 14, y: 870, width: 99, height: 20)
            timeLabel.font = timeLabel.font.withSize(15)
            timeTextField.frame = CGRect(x: 118, y: 870, width: 140, height: 20)
            timeTextField.font = timeTextField.font?.withSize(12)
            
            saveButton.titleLabel?.font = saveButton.titleLabel?.font.withSize(25)
            saveButton.frame = CGRect(x: 24, y: 1014, width: 213, height: 42)
            
            deleteView.frame = CGRect(x: 247, y: 1014, width: 49, height: 42)
            trashCanButton.frame = CGRect(x: 0, y: 0, width: 49, height: 42)
            trashCanIconImageView.frame = CGRect(x: 12, y: 7, width: 25, height: 28)
            
            alarmUpdateConstant = 81
            
            contentViewHeightConstraint.constant = 1070
            
            cellSizeConstant = 35
            cellSpacing = 4
        }
        else if screenWidth == 768 && screenHeight == 1024{
            tutorialScreenWidth = 712
            
            tutorialLabel.font = tutorialLabel.font.withSize(55)
            
            tableViewRowHeight = 61
            
            newTask.font = newTask.font.withSize(50)
            newTask.frame = CGRect(x: 24, y: 30, width: 261, height: 65)
            
            mainView.frame = CGRect(x: 24, y: 125, width: 664, height: 1626)
            
            nameLabel.font = nameLabel.font.withSize(30)
            nameLabel.frame = CGRect(x: 15, y: 15, width: 103, height: 39)
            
            nameTextField.font = nameTextField.font?.withSize(30)
            nameTextField.frame = CGRect(x: 123, y: 15, width: 526, height: 39)
            
            firstSeperator.frame = CGRect(x: 0, y: 69, width: 664, height: 2)
            
            colorLabel.font = colorLabel.font.withSize(30)
            colorLabel.frame = CGRect(x: 15, y: 86, width: 115, height: 39)
            
            colorPicker.frame = CGRect(x: 17, y: 140, width: 630, height: 630)
            customColor.frame = CGRect(x: 17, y: 140, width: 630, height: 630)
            
            customText.font = customText.font.withSize(20)
            customText.frame = CGRect(x: 192, y: 798, width: 280, height: 27)
            customButton.frame = CGRect(x: 192, y: 785, width: 280, height: 52)
            
            secondSeperator.frame = CGRect(x: 0, y: 852, width: 664, height: 2)
            
            startDateLabel.font = startDateLabel.font.withSize(30)
            startDateLabel.frame = CGRect(x: 15, y: 869, width: 178, height: 39)
            startDateView.frame = CGRect(x: 208, y: 869, width: 441, height: 39)
            
            startLabel.font = startLabel.font.withSize(25)
            startLabel.frame = CGRect(x: 0, y: 0, width: 441, height: 39)
            startDateButton.frame = CGRect(x: 0, y: 0, width: 441, height: 39)
            
            thirdSeperator.frame = CGRect(x: 0, y: 917, width: 664, height: 2)
            
            endDateLabel.font = endDateLabel.font.withSize(30)
            endDateLabel.frame = CGRect(x: 15, y: 934, width: 156, height: 39)
            endDateView.frame = CGRect(x: 208, y: 934, width: 441, height: 39)
            endDateButton.frame = CGRect(x: 0, y: 0, width: 441, height: 39)
            endLabel.font = endLabel.font.withSize(25)
            endLabel.frame = CGRect(x: 0, y: 0, width: 441, height: 39)
            
            fourthSeperator.frame = CGRect(x: 0, y: 988, width: 664, height: 2)
            
            categoryLabel.font = categoryLabel.font.withSize(30)
            categoryLabel.frame = CGRect(x: 15, y: 1005, width: 170, height: 39)
            
            tableView.frame = CGRect(x: 15, y: 1059, width: 634, height: 356)
            tableViewYConstant = 1059
            
            fifthSeperator.frame = CGRect(x: 0, y: 1430, width: 664, height: 2)
            
            alarmL.font = alarmL.font.withSize(30)
            alarmL.frame = CGRect(x: 15, y: 1447, width: 116, height: 39)
            
            alarmTypeView.frame = CGRect(x: 228, y: 1447, width: 421, height: 39)
            alarmAnimate.frame = CGRect(x: 0, y: 0, width: 210.5, height: 39)
            x.frame = CGRect(x: 0, y: 0, width: 210.5, height: 39)
            checkMark.frame = CGRect(x: 210.5, y: 0, width: 210.5, height: 39)
            
            sixthSeperator.frame = CGRect(x: 0, y: 1501, width: 664, height: 2)
            alarmDateLabel.font = alarmDateLabel.font.withSize(30)
            alarmDateLabel.frame = CGRect(x: 15, y: 1518, width: 198, height: 39)
            
            alarmDateView.frame = CGRect(x: 228, y: 1518, width: 421, height: 39)
            alarmLabel.frame = CGRect(x: 0, y: 0, width: 421, height: 39)
            alarmLabel.font = alarmLabel.font.withSize(25)
            alarmDateButton.frame = CGRect(x: 0, y: 0, width: 421, height: 39)
            
            timeLabel.frame = CGRect(x: 15, y: 1572, width: 198, height: 39)
            timeLabel.font = timeLabel.font.withSize(30)
            timeTextField.frame = CGRect(x: 228, y: 1572, width: 421, height: 39)
            timeTextField.font = timeTextField.font?.withSize(25)
            
            saveButton.titleLabel?.font = saveButton.titleLabel?.font.withSize(60)
            saveButton.frame = CGRect(x: 24, y: 1766, width: 508, height: 107)
            
            deleteView.frame = CGRect(x: 547, y: 1766, width: 141, height: 107)
            trashCanButton.frame = CGRect(x: 0, y: 0, width: 141, height: 107)
            trashCanIconImageView.frame = CGRect(x: 34, y: 11, width: 73, height: 85)
            
            calendarContainerView.frame = CGRect(x: 56, y: -700, width: 656, height: 700)
            
            alarmUpdateConstant = 125
            
            contentViewHeightConstraint.constant = 1888
            
            cellSizeConstant = 95
            cellSpacing = 12
        }
        else if screenWidth == 834 && screenHeight == 1112{
            tutorialScreenWidth = 712
            
            tutorialLabel.font = tutorialLabel.font.withSize(60)
            
            tableViewRowHeight = 61
            
            newTask.font = newTask.font.withSize(50)
            newTask.frame = CGRect(x: 24, y: 30, width: 261, height: 65)
            
            mainView.frame = CGRect(x: 24, y: 125, width: 664, height: 1626)
            
            nameLabel.font = nameLabel.font.withSize(30)
            nameLabel.frame = CGRect(x: 15, y: 15, width: 103, height: 39)
            
            nameTextField.font = nameTextField.font?.withSize(30)
            nameTextField.frame = CGRect(x: 123, y: 15, width: 526, height: 39)
            
            firstSeperator.frame = CGRect(x: 0, y: 69, width: 664, height: 2)
            
            colorLabel.font = colorLabel.font.withSize(30)
            colorLabel.frame = CGRect(x: 15, y: 86, width: 115, height: 39)
            
            colorPicker.frame = CGRect(x: 17, y: 140, width: 630, height: 630)
            customColor.frame = CGRect(x: 17, y: 140, width: 630, height: 630)
            
            customText.font = customText.font.withSize(20)
            customText.frame = CGRect(x: 192, y: 798, width: 280, height: 27)
            customButton.frame = CGRect(x: 192, y: 785, width: 280, height: 52)
            
            secondSeperator.frame = CGRect(x: 0, y: 852, width: 664, height: 2)
            
            startDateLabel.font = startDateLabel.font.withSize(30)
            startDateLabel.frame = CGRect(x: 15, y: 869, width: 178, height: 39)
            startDateView.frame = CGRect(x: 208, y: 869, width: 441, height: 39)
            
            startLabel.font = startLabel.font.withSize(25)
            startLabel.frame = CGRect(x: 0, y: 0, width: 441, height: 39)
            startDateButton.frame = CGRect(x: 0, y: 0, width: 441, height: 39)
            
            thirdSeperator.frame = CGRect(x: 0, y: 917, width: 664, height: 2)
            
            endDateLabel.font = endDateLabel.font.withSize(30)
            endDateLabel.frame = CGRect(x: 15, y: 934, width: 156, height: 39)
            endDateView.frame = CGRect(x: 208, y: 934, width: 441, height: 39)
            endDateButton.frame = CGRect(x: 0, y: 0, width: 441, height: 39)
            endLabel.font = endLabel.font.withSize(25)
            endLabel.frame = CGRect(x: 0, y: 0, width: 441, height: 39)
            
            fourthSeperator.frame = CGRect(x: 0, y: 988, width: 664, height: 2)
            
            categoryLabel.font = categoryLabel.font.withSize(30)
            categoryLabel.frame = CGRect(x: 15, y: 1005, width: 170, height: 39)
            
            tableView.frame = CGRect(x: 15, y: 1059, width: 634, height: 356)
            tableViewYConstant = 1059
            
            fifthSeperator.frame = CGRect(x: 0, y: 1430, width: 664, height: 2)
            
            alarmL.font = alarmL.font.withSize(30)
            alarmL.frame = CGRect(x: 15, y: 1447, width: 116, height: 39)
            
            alarmTypeView.frame = CGRect(x: 228, y: 1447, width: 421, height: 39)
            alarmAnimate.frame = CGRect(x: 0, y: 0, width: 210.5, height: 39)
            x.frame = CGRect(x: 0, y: 0, width: 210.5, height: 39)
            checkMark.frame = CGRect(x: 210.5, y: 0, width: 210.5, height: 39)
            
            sixthSeperator.frame = CGRect(x: 0, y: 1501, width: 664, height: 2)
            alarmDateLabel.font = alarmDateLabel.font.withSize(30)
            alarmDateLabel.frame = CGRect(x: 15, y: 1518, width: 198, height: 39)
            
            alarmDateView.frame = CGRect(x: 228, y: 1518, width: 421, height: 39)
            alarmLabel.frame = CGRect(x: 0, y: 0, width: 421, height: 39)
            alarmLabel.font = alarmLabel.font.withSize(25)
            alarmDateButton.frame = CGRect(x: 0, y: 0, width: 421, height: 39)
            
            timeLabel.frame = CGRect(x: 15, y: 1572, width: 198, height: 39)
            timeLabel.font = timeLabel.font.withSize(30)
            timeTextField.frame = CGRect(x: 228, y: 1572, width: 421, height: 39)
            timeTextField.font = timeTextField.font?.withSize(25)
            
            saveButton.titleLabel?.font = saveButton.titleLabel?.font.withSize(60)
            saveButton.frame = CGRect(x: 24, y: 1766, width: 508, height: 107)
            
            deleteView.frame = CGRect(x: 547, y: 1766, width: 141, height: 107)
            trashCanButton.frame = CGRect(x: 0, y: 0, width: 141, height: 107)
            trashCanIconImageView.frame = CGRect(x: 34, y: 11, width: 73, height: 85)
            
            calendarContainerView.frame = CGRect(x: 56, y: -700, width: 722, height: 700)
            
            alarmUpdateConstant = 125
            
            contentViewHeightConstraint.constant = 1888
            
            cellSizeConstant = 95
            cellSpacing = 12
        }
        else if screenWidth == 1024 && screenHeight == 1366{
            tutorialScreenWidth = 712
            
            tutorialLabel.font = tutorialLabel.font.withSize(60)
            
            tableViewRowHeight = 61
            
            newTask.font = newTask.font.withSize(50)
            newTask.frame = CGRect(x: 24, y: 30, width: 261, height: 65)
            
            mainView.frame = CGRect(x: 24, y: 125, width: 664, height: 1626)
            
            nameLabel.font = nameLabel.font.withSize(30)
            nameLabel.frame = CGRect(x: 15, y: 15, width: 103, height: 39)
            
            nameTextField.font = nameTextField.font?.withSize(30)
            nameTextField.frame = CGRect(x: 123, y: 15, width: 526, height: 39)
            
            firstSeperator.frame = CGRect(x: 0, y: 69, width: 664, height: 2)
            
            colorLabel.font = colorLabel.font.withSize(30)
            colorLabel.frame = CGRect(x: 15, y: 86, width: 115, height: 39)
            
            colorPicker.frame = CGRect(x: 17, y: 140, width: 630, height: 630)
            customColor.frame = CGRect(x: 17, y: 140, width: 630, height: 630)
            
            customText.font = customText.font.withSize(20)
            customText.frame = CGRect(x: 192, y: 798, width: 280, height: 27)
            customButton.frame = CGRect(x: 192, y: 785, width: 280, height: 52)
            
            secondSeperator.frame = CGRect(x: 0, y: 852, width: 664, height: 2)
            
            startDateLabel.font = startDateLabel.font.withSize(30)
            startDateLabel.frame = CGRect(x: 15, y: 869, width: 178, height: 39)
            startDateView.frame = CGRect(x: 208, y: 869, width: 441, height: 39)
            
            startLabel.font = startLabel.font.withSize(25)
            startLabel.frame = CGRect(x: 0, y: 0, width: 441, height: 39)
            startDateButton.frame = CGRect(x: 0, y: 0, width: 441, height: 39)
            
            thirdSeperator.frame = CGRect(x: 0, y: 917, width: 664, height: 2)
            
            endDateLabel.font = endDateLabel.font.withSize(30)
            endDateLabel.frame = CGRect(x: 15, y: 934, width: 156, height: 39)
            endDateView.frame = CGRect(x: 208, y: 934, width: 441, height: 39)
            endDateButton.frame = CGRect(x: 0, y: 0, width: 441, height: 39)
            endLabel.font = endLabel.font.withSize(25)
            endLabel.frame = CGRect(x: 0, y: 0, width: 441, height: 39)
            
            fourthSeperator.frame = CGRect(x: 0, y: 988, width: 664, height: 2)
            
            categoryLabel.font = categoryLabel.font.withSize(30)
            categoryLabel.frame = CGRect(x: 15, y: 1005, width: 170, height: 39)
            
            tableView.frame = CGRect(x: 15, y: 1059, width: 634, height: 356)
            tableViewYConstant = 1059
            
            fifthSeperator.frame = CGRect(x: 0, y: 1430, width: 664, height: 2)
            
            alarmL.font = alarmL.font.withSize(30)
            alarmL.frame = CGRect(x: 15, y: 1447, width: 116, height: 39)
            
            alarmTypeView.frame = CGRect(x: 228, y: 1447, width: 421, height: 39)
            alarmAnimate.frame = CGRect(x: 0, y: 0, width: 210.5, height: 39)
            x.frame = CGRect(x: 0, y: 0, width: 210.5, height: 39)
            checkMark.frame = CGRect(x: 210.5, y: 0, width: 210.5, height: 39)
            
            sixthSeperator.frame = CGRect(x: 0, y: 1501, width: 664, height: 2)
            alarmDateLabel.font = alarmDateLabel.font.withSize(30)
            alarmDateLabel.frame = CGRect(x: 15, y: 1518, width: 198, height: 39)
            
            alarmDateView.frame = CGRect(x: 228, y: 1518, width: 421, height: 39)
            alarmLabel.frame = CGRect(x: 0, y: 0, width: 421, height: 39)
            alarmLabel.font = alarmLabel.font.withSize(25)
            alarmDateButton.frame = CGRect(x: 0, y: 0, width: 421, height: 39)
            
            timeLabel.frame = CGRect(x: 15, y: 1572, width: 198, height: 39)
            timeLabel.font = timeLabel.font.withSize(30)
            timeTextField.frame = CGRect(x: 228, y: 1572, width: 421, height: 39)
            timeTextField.font = timeTextField.font?.withSize(25)
            
            saveButton.titleLabel?.font = saveButton.titleLabel?.font.withSize(60)
            saveButton.frame = CGRect(x: 24, y: 1766, width: 508, height: 107)
            
            deleteView.frame = CGRect(x: 547, y: 1766, width: 141, height: 107)
            trashCanButton.frame = CGRect(x: 0, y: 0, width: 141, height: 107)
            trashCanIconImageView.frame = CGRect(x: 34, y: 11, width: 73, height: 85)
            
            alarmUpdateConstant = 125
            
            contentViewHeightConstraint.constant = 1888
            
            cellSizeConstant = 95
            cellSpacing = 12
            
            calendarContainer.screenWidth = 768
            calendarContainer.screenHeight = 1024
            calendarContainer.resizeDevice()
            calendarContainer.collectionView.reloadData()
            
            calendarContainerView.frame = CGRect(x: 56, y: -700, width: 914, height: 700)
        }
        else if screenWidth == 834 && screenHeight == 1194{
            tutorialScreenWidth = 712
            
            tutorialLabel.font = tutorialLabel.font.withSize(60)
            
            tableViewRowHeight = 61
            
            newTask.font = newTask.font.withSize(50)
            newTask.frame = CGRect(x: 24, y: 30, width: 261, height: 65)
            
            mainView.frame = CGRect(x: 24, y: 125, width: 664, height: 1626)
            
            nameLabel.font = nameLabel.font.withSize(30)
            nameLabel.frame = CGRect(x: 15, y: 15, width: 103, height: 39)
            
            nameTextField.font = nameTextField.font?.withSize(30)
            nameTextField.frame = CGRect(x: 123, y: 15, width: 526, height: 39)
            
            firstSeperator.frame = CGRect(x: 0, y: 69, width: 664, height: 2)
            
            colorLabel.font = colorLabel.font.withSize(30)
            colorLabel.frame = CGRect(x: 15, y: 86, width: 115, height: 39)
            
            colorPicker.frame = CGRect(x: 17, y: 140, width: 630, height: 630)
            customColor.frame = CGRect(x: 17, y: 140, width: 630, height: 630)
            
            customText.font = customText.font.withSize(20)
            customText.frame = CGRect(x: 192, y: 798, width: 280, height: 27)
            customButton.frame = CGRect(x: 192, y: 785, width: 280, height: 52)
            
            secondSeperator.frame = CGRect(x: 0, y: 852, width: 664, height: 2)
            
            startDateLabel.font = startDateLabel.font.withSize(30)
            startDateLabel.frame = CGRect(x: 15, y: 869, width: 178, height: 39)
            startDateView.frame = CGRect(x: 208, y: 869, width: 441, height: 39)
            
            startLabel.font = startLabel.font.withSize(25)
            startLabel.frame = CGRect(x: 0, y: 0, width: 441, height: 39)
            startDateButton.frame = CGRect(x: 0, y: 0, width: 441, height: 39)
            
            thirdSeperator.frame = CGRect(x: 0, y: 917, width: 664, height: 2)
            
            endDateLabel.font = endDateLabel.font.withSize(30)
            endDateLabel.frame = CGRect(x: 15, y: 934, width: 156, height: 39)
            endDateView.frame = CGRect(x: 208, y: 934, width: 441, height: 39)
            endDateButton.frame = CGRect(x: 0, y: 0, width: 441, height: 39)
            endLabel.font = endLabel.font.withSize(25)
            endLabel.frame = CGRect(x: 0, y: 0, width: 441, height: 39)
            
            fourthSeperator.frame = CGRect(x: 0, y: 988, width: 664, height: 2)
            
            categoryLabel.font = categoryLabel.font.withSize(30)
            categoryLabel.frame = CGRect(x: 15, y: 1005, width: 170, height: 39)
            
            tableView.frame = CGRect(x: 15, y: 1059, width: 634, height: 356)
            tableViewYConstant = 1059
            
            fifthSeperator.frame = CGRect(x: 0, y: 1430, width: 664, height: 2)
            
            alarmL.font = alarmL.font.withSize(30)
            alarmL.frame = CGRect(x: 15, y: 1447, width: 116, height: 39)
            
            alarmTypeView.frame = CGRect(x: 228, y: 1447, width: 421, height: 39)
            alarmAnimate.frame = CGRect(x: 0, y: 0, width: 210.5, height: 39)
            x.frame = CGRect(x: 0, y: 0, width: 210.5, height: 39)
            checkMark.frame = CGRect(x: 210.5, y: 0, width: 210.5, height: 39)
            
            sixthSeperator.frame = CGRect(x: 0, y: 1501, width: 664, height: 2)
            alarmDateLabel.font = alarmDateLabel.font.withSize(30)
            alarmDateLabel.frame = CGRect(x: 15, y: 1518, width: 198, height: 39)
            
            alarmDateView.frame = CGRect(x: 228, y: 1518, width: 421, height: 39)
            alarmLabel.frame = CGRect(x: 0, y: 0, width: 421, height: 39)
            alarmLabel.font = alarmLabel.font.withSize(25)
            alarmDateButton.frame = CGRect(x: 0, y: 0, width: 421, height: 39)
            
            timeLabel.frame = CGRect(x: 15, y: 1572, width: 198, height: 39)
            timeLabel.font = timeLabel.font.withSize(30)
            timeTextField.frame = CGRect(x: 228, y: 1572, width: 421, height: 39)
            timeTextField.font = timeTextField.font?.withSize(25)
            
            saveButton.titleLabel?.font = saveButton.titleLabel?.font.withSize(60)
            saveButton.frame = CGRect(x: 24, y: 1766, width: 508, height: 107)
            
            deleteView.frame = CGRect(x: 547, y: 1766, width: 141, height: 107)
            trashCanButton.frame = CGRect(x: 0, y: 0, width: 141, height: 107)
            trashCanIconImageView.frame = CGRect(x: 34, y: 11, width: 73, height: 85)
            
            calendarContainerView.frame = CGRect(x: 56, y: -700, width: 722, height: 700)
            
            alarmUpdateConstant = 125
            
            contentViewHeightConstraint.constant = 1888
            
            cellSizeConstant = 95
            cellSpacing = 12
        }
        else if screenWidth == 810 && screenHeight == 1080{
            tutorialScreenWidth = 712
            
            tutorialLabel.font = tutorialLabel.font.withSize(60)
            
            newTask.font = newTask.font.withSize(50)
            newTask.frame = CGRect(x: 24, y: 30, width: 261, height: 65)
            
            mainView.frame = CGRect(x: 24, y: 125, width: 664, height: 1626)
            
            nameLabel.font = nameLabel.font.withSize(30)
            nameLabel.frame = CGRect(x: 15, y: 15, width: 103, height: 39)
            
            nameTextField.font = nameTextField.font?.withSize(30)
            nameTextField.frame = CGRect(x: 123, y: 15, width: 526, height: 39)
            
            firstSeperator.frame = CGRect(x: 0, y: 69, width: 664, height: 2)
            
            colorLabel.font = colorLabel.font.withSize(30)
            colorLabel.frame = CGRect(x: 15, y: 86, width: 115, height: 39)
            
            colorPicker.frame = CGRect(x: 17, y: 140, width: 630, height: 630)
            customColor.frame = CGRect(x: 17, y: 140, width: 630, height: 630)
            
            customText.font = customText.font.withSize(20)
            customText.frame = CGRect(x: 192, y: 798, width: 280, height: 27)
            customButton.frame = CGRect(x: 192, y: 785, width: 280, height: 52)
            
            secondSeperator.frame = CGRect(x: 0, y: 852, width: 664, height: 2)
            
            startDateLabel.font = startDateLabel.font.withSize(30)
            startDateLabel.frame = CGRect(x: 15, y: 869, width: 178, height: 39)
            startDateView.frame = CGRect(x: 208, y: 869, width: 441, height: 39)
            
            startLabel.font = startLabel.font.withSize(25)
            startLabel.frame = CGRect(x: 0, y: 0, width: 441, height: 39)
            startDateButton.frame = CGRect(x: 0, y: 0, width: 441, height: 39)
            
            thirdSeperator.frame = CGRect(x: 0, y: 917, width: 664, height: 2)
            
            endDateLabel.font = endDateLabel.font.withSize(30)
            endDateLabel.frame = CGRect(x: 15, y: 934, width: 156, height: 39)
            endDateView.frame = CGRect(x: 208, y: 934, width: 441, height: 39)
            endDateButton.frame = CGRect(x: 0, y: 0, width: 441, height: 39)
            endLabel.font = endLabel.font.withSize(25)
            endLabel.frame = CGRect(x: 0, y: 0, width: 441, height: 39)
            
            fourthSeperator.frame = CGRect(x: 0, y: 988, width: 664, height: 2)
            
            categoryLabel.font = categoryLabel.font.withSize(30)
            categoryLabel.frame = CGRect(x: 15, y: 1005, width: 170, height: 39)
            
            tableView.frame = CGRect(x: 15, y: 1059, width: 634, height: 356)
            tableViewYConstant = 1059
            
            fifthSeperator.frame = CGRect(x: 0, y: 1430, width: 664, height: 2)
            
            alarmL.font = alarmL.font.withSize(30)
            alarmL.frame = CGRect(x: 15, y: 1447, width: 116, height: 39)
            
            alarmTypeView.frame = CGRect(x: 228, y: 1447, width: 421, height: 39)
            alarmAnimate.frame = CGRect(x: 0, y: 0, width: 210.5, height: 39)
            x.frame = CGRect(x: 0, y: 0, width: 210.5, height: 39)
            checkMark.frame = CGRect(x: 210.5, y: 0, width: 210.5, height: 39)
            
            sixthSeperator.frame = CGRect(x: 0, y: 1501, width: 664, height: 2)
            alarmDateLabel.font = alarmDateLabel.font.withSize(30)
            alarmDateLabel.frame = CGRect(x: 15, y: 1518, width: 198, height: 39)
            
            alarmDateView.frame = CGRect(x: 228, y: 1518, width: 421, height: 39)
            alarmLabel.frame = CGRect(x: 0, y: 0, width: 421, height: 39)
            alarmLabel.font = alarmLabel.font.withSize(25)
            alarmDateButton.frame = CGRect(x: 0, y: 0, width: 421, height: 39)
            
            timeLabel.frame = CGRect(x: 15, y: 1572, width: 198, height: 39)
            timeLabel.font = timeLabel.font.withSize(30)
            timeTextField.frame = CGRect(x: 228, y: 1572, width: 421, height: 39)
            timeTextField.font = timeTextField.font?.withSize(25)
            
            saveButton.titleLabel?.font = saveButton.titleLabel?.font.withSize(60)
            saveButton.frame = CGRect(x: 24, y: 1766, width: 508, height: 107)
            
            deleteView.frame = CGRect(x: 547, y: 1766, width: 141, height: 107)
            trashCanButton.frame = CGRect(x: 0, y: 0, width: 141, height: 107)
            trashCanIconImageView.frame = CGRect(x: 34, y: 11, width: 73, height: 85)
            
            calendarContainerView.frame = CGRect(x: 56, y: -700, width: 699, height: 700)
            
            alarmUpdateConstant = 125
            
            contentViewHeightConstraint.constant = 1888
            
            cellSizeConstant = 95
            cellSpacing = 12
        }

        //general resize
        tutorialBlurView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        moveOnButton.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        contentView.layoutIfNeeded()
    }
    
    @IBAction func moveOnPressed(_ sender: Any) {
        customColorTutorialFunc()
        calendarTutorial()

        //haptic feedback
        let selectionGenerator = UISelectionFeedbackGenerator()
        selectionGenerator.selectionChanged()
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
    
    func startingCustomColorTutorial(){
        if shouldCustomColorTutorial == true{
            customColorState = 1
            
            tutorialBlurView.isHidden = false
            tutorialView.isHidden = false
            triangle.isHidden = false
            moveOnButton.isHidden = false
            
            var tempContentOffset: CGFloat = 0
            if tutorialScreenWidth == 712{
                //scroll progamatically
                scrollView.setContentOffset(CGPoint(x: 0, y: 200), animated: true)
                tempContentOffset = 200
            }
            else{
                //scroll progamatically
                scrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
                tempContentOffset = 100
            }
            
            //setup of tutorial and text
            triangle.center.x = tutorialScreenWidth/2
            let absPosCustomColor = CGPoint(x: customColor.frame.origin.x + mainView.frame.origin.x, y: customColor.frame.origin.y + mainView.frame.origin.y - tempContentOffset)
            triangle.frame.origin.y = absPosCustomColor.y + customColor.frame.size.height + 5
            
            holeBlurView(CGRect(x: absPosCustomColor.x, y: absPosCustomColor.y, width: customColor.frame.size.width, height: customColor.frame.size.height))
            
            tutorialLabel.frame.size = CGSize(width: tutorialScreenWidth - 2 * tutorialSpacingWidth, height: 100)
            tutorialLabel.text = "Tap and HOLD for the desired color."
            tutorialLabel.sizeToFit()
            
            tutorialLabel.center.x = tutorialScreenWidth/2
            tutorialLabel.frame.origin.y = 20
            
            tutorialView.frame = CGRect(x: 0, y: triangle.frame.origin.y + triangle.frame.size.height, width: tutorialScreenWidth, height: tutorialLabel.frame.size.height + 40)
            
            //setup of animations
            let prevTV = tutorialView.frame.origin.x
            let prevT = triangle.frame.origin.x
            
            tutorialView.frame.origin.x = screenWidth
            triangle.frame.origin.x = screenWidth
            
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                self.tutorialView.frame.origin.x = prevTV
                self.triangle.frame.origin.x = prevT
            }, completion: nil)

            //disable scroll
            self.presentationController?.presentedView?.gestureRecognizers?.forEach {
                $0.isEnabled = false
            }
        }
    }
    
    func customColorTutorialFunc(){
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

                resetTutorialBlurView()
                
                tutorialBlurView.isHidden = true
                moveOnButton.isHidden = true
                
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                    self.tutorialView.frame.origin.x = self.screenWidth
                    self.triangle.frame.origin.x = self.tutorialScreenWidth
                }, completion: {_ in
                    self.tutorialView.isHidden = true
                    self.triangle.isHidden = true
                })
                
                //enable scroll
                self.presentationController?.presentedView?.gestureRecognizers?.forEach {
                    $0.isEnabled = true
                }
            }
        }
    }
    
    func startingCalendarTutorial(){
        if shouldCalendarTutorial == true{
            calendarState = 1
            
            //enable everything
            blurView.isHidden = false
            blurButton.isHidden = true
            
            calendarContainer.tutorialBlurView.isHidden = false
            moveOnButton.isHidden = false

            //setup of tutorial and text
            tutorialView.isHidden = false
            flippedTriangle.isHidden = false
            
            let customCalendarPoint = CGPoint(x: 0, y:  calendarContainer.tutorialBlurView.frame.size.height + calendarContainerView.frame.origin.y)
            
            flippedTriangle.center.x = tutorialScreenWidth/2
            flippedTriangle.frame.origin.y = customCalendarPoint.y - 5 - flippedTriangle.frame.size.height
            
            tutorialLabel.frame.size = CGSize(width: tutorialScreenWidth - 2 * tutorialSpacingWidth, height: 100)
            tutorialLabel.text = "Tap a day to select that date."
            tutorialLabel.sizeToFit()
            
            tutorialLabel.center.x = tutorialScreenWidth/2
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
    
    func calendarTutorial(){
        if shouldCalendarTutorial == true{
           if calendarState == 1{
               //enable everything
               calendarContainer.tutorialBlurView.isHidden = true
               tutorialBlurView.isHidden = false
               
                let currentCalendarCell = calendarContainer.collectionView.cellForItem(at: [0,calendarContainer.highlightedMonth]) as! CalendarPopupCard
               
               //setup to look like date
               flippedTriangle.isHidden = true
               
               blurView.isHidden = true
               blurButton.isHidden = false
               holeBlurView(CGRect(x: currentCalendarCell.monthButton.frame.origin.x + calendarContainerView.frame.origin.x, y: calendarContainerView.frame.origin.y, width: currentCalendarCell.monthButton.frame.size.width, height: currentCalendarCell.monthButton.frame.size.height))
            
               //setup of tutorial and text
               tutorialView.isHidden = false
               triangle.isHidden = false
            
               let customCalendarPoint = CGPoint(x: 0, y: calendarContainerView.frame.origin.y + calendarContainer.tutorialBlurView.frame.size.height)
               
               triangle.center.x = tutorialScreenWidth/2
               triangle.frame.origin.y = customCalendarPoint.y + 5
               
               tutorialLabel.frame.size = CGSize(width: tutorialScreenWidth - 2 * tutorialSpacingWidth, height: 100)
               tutorialLabel.text = "Tap the top or swipe up/down to view the calendar in month mode."
               tutorialLabel.sizeToFit()
               
               tutorialLabel.center.x = tutorialScreenWidth/2
               tutorialLabel.frame.origin.y = 20
               
               tutorialView.frame = CGRect(x: 0, y: triangle.frame.origin.y + triangle.frame.size.height, width: tutorialScreenWidth, height: tutorialLabel.frame.size.height + 40)
               
               //setup of animations
               let prevTV = tutorialView.frame.origin.x
               let prevT = triangle.frame.origin.x
               
               tutorialView.frame.origin.x = tutorialScreenWidth
               triangle.frame.origin.x = tutorialScreenWidth
               
               UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                   self.tutorialView.frame.origin.x = prevTV
                   self.triangle.frame.origin.x = prevT
               }, completion: nil)
               
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
            
                tutorialBlurView.isHidden = true
                moveOnButton.isHidden = true
                blurView.isHidden = false
                resetTutorialBlurView()
               
               UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                   self.tutorialView.frame.origin.x = self.tutorialScreenWidth
                   self.triangle.frame.origin.x = self.tutorialScreenWidth
               }, completion: {_ in
                   self.tutorialView.isHidden = true
                   self.triangle.isHidden = true
               })
           }
        }
    }
    
    @IBAction func changeColor(_ sender: Any) {
        if colorPicker.isHidden == false{
            
            //hide colorpicker and make customcolor appear
            UIView.transition(with: colorPicker, duration: 0.4, options: .transitionCrossDissolve, animations: {
                self.colorPicker.isHidden = true
                self.customColor.isHidden = false
            }, completion: nil)
            
            //change custom color to chosen color if color picked
            if isColorChosen == true{
                customColor.color = colorChosen.cgColor
            }
            
            //deselect previous cell in colorPicker
            if cellNumber >= 0{
                let selectedCell = colorPicker.cellForItem(at: [0,cellNumber]) as! ColorCell
                selectedCell.checkMarkAnimation.setOn(false, animated: false)
                
                cellNumber = -1
            }
            
            //chosen color is true
            isColorChosen = true
            
            //show tutorial if not done before
            startingCustomColorTutorial()
            
            //haptic feedback
            mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
            mediumGenerator?.prepare()
            mediumGenerator?.impactOccurred()
            mediumGenerator = nil
            
            customText.text = "PREMADE"
        }
            
        //custom color picker changed to normal color picker
        else{
            
            //hide customcolor and make colorpicker appear
            UIView.transition(with: customColor, duration: 0.4, options: .transitionCrossDissolve, animations: {
                self.customColor.isHidden = true
                self.colorPicker.isHidden = false
            }, completion: nil)
            
            //select if its a premade color, otherwise, don't
            if colorArray.contains(UIColor(cgColor: customColor.color)) == true{
                isColorChosen = true
                colorChosen = UIColor(cgColor: customColor.color)
                let indexOfColor = colorArray.firstIndex(of: colorChosen) ?? 0
                let cellOfColor = colorPicker.cellForItem(at: [0,indexOfColor]) as! ColorCell
                
                //select cell
                colorPicker.selectItem(at: [0,indexOfColor], animated: false, scrollPosition: .top)
                cellOfColor.checkMarkAnimation.setOn(true, animated: true)
                
                cellNumber = indexOfColor
            }
            else{
                isColorChosen = false
            }
            
            //haptic feedback
            mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
            mediumGenerator?.prepare()
            mediumGenerator?.impactOccurred()
            mediumGenerator = nil
            
            customText.text = "CUSTOM"
        }
        
        checkSaveEnable()
    }
    
    //tapped on tableview(category)
    @objc func handleTapTableView(_ sender: UITapGestureRecognizer) {
        let locationPressed = sender.location(in: tableView)
        
        //if not a seperator
        if locationPressed.y.truncatingRemainder(dividingBy: tableViewRowHeight) <= tableViewRowHeight{

            //see if categoryNum is valid
            
            //start realm
            let realm = try! Realm()
            
            //call category from realms
            let categoryRealm = realm.objects(Category.self)
            
            if categoryRealm.count >= Int(locationPressed.y/tableViewRowHeight) + 1{
                
                //if previous category selected and another category to be selected
                if categoryNum >= 0 && Int(locationPressed.y/tableViewRowHeight) != categoryNum{

                    //deselect previous cell
                    let previousCategory = tableView.cellForRow(at: [0,categoryNum]) as! NewTaskCategoryCell
                    previousCategory.checkMark.setOn(false, animated: true)

                    //selected category #
                    categoryNum = Int(locationPressed.y/tableViewRowHeight)

                    //haptic feedback
                    let selectionGenerator = UISelectionFeedbackGenerator()
                    selectionGenerator.selectionChanged()
                    
                    let categorySelected = tableView.cellForRow(at: [0,categoryNum]) as! NewTaskCategoryCell
                    categorySelected.checkMark.setOn(true, animated: true)
                }
                
                //deselect already selected category
                else if categoryNum >= 0 && Int(locationPressed.y/tableViewRowHeight) == categoryNum{

                    //haptic feedback
                    let selectionGenerator = UISelectionFeedbackGenerator()
                    selectionGenerator.selectionChanged()
                    
                    //deselect previous cell
                    let previousCategory = tableView.cellForRow(at: [0,categoryNum]) as! NewTaskCategoryCell
                    previousCategory.checkMark.setOn(false, animated: true)
                    
                    //no selected category
                    categoryNum = -1
                }
                
                //no previous category selected
                else if categoryNum < 0{

                    //haptic feedback
                    let selectionGenerator = UISelectionFeedbackGenerator()
                    selectionGenerator.selectionChanged()
                    
                    //selected category #
                    categoryNum = Int(locationPressed.y/tableViewRowHeight)
                    
                    let categorySelected = tableView.cellForRow(at: [0,categoryNum]) as! NewTaskCategoryCell
                    categorySelected.checkMark.setOn(true, animated: true)
                }
                
                //see if save button should be enabled
                checkSaveEnable()
            }
        }
    }
    
    //tapped on collectionview(colorPicker)
    @objc func handleTapColorPicker(_ sender: UITapGestureRecognizer) {
        let locationPressed = sender.location(in: colorPicker)
        
        //if thing pressed is an actual cell
        if locationPressed.x.truncatingRemainder(dividingBy: cellSizeConstant + cellSpacing) <= cellSizeConstant && locationPressed.y.truncatingRemainder(dividingBy: cellSizeConstant + cellSpacing) <= cellSizeConstant{
            
            //deselect previous cell number if a previous cell number is chosen
            if cellNumber >= 0 && cellNumber != Int(locationPressed.y/(cellSizeConstant + cellSpacing)) * 6 + Int(locationPressed.x/(cellSizeConstant + cellSpacing)){
                
                var cell = colorPicker.cellForItem(at: [0,cellNumber]) as! ColorCell

                //deselect animation
                cell.checkMarkAnimation.setOn(false, animated: true)

                //new cell number chosen
                cellNumber = Int(locationPressed.y/(cellSizeConstant + cellSpacing)) * 6 + Int(locationPressed.x/(cellSizeConstant + cellSpacing))
                
                //animation selection
                cell = colorPicker.cellForItem(at: [0,cellNumber]) as! ColorCell

                //select animation
                cell.checkMarkAnimation.setOn(true, animated: true)

                //haptic feedback
                let selectionGenerator = UISelectionFeedbackGenerator()
                selectionGenerator.selectionChanged()
                
                //a color is chosen
                isColorChosen = true
                colorChosen = colorArray[cellNumber]
                
            }
            
            //if same cellNumber chosen - deselection animation
            else if cellNumber >= 0 && cellNumber == Int(locationPressed.y/(cellSizeConstant + cellSpacing)) * 6 + Int(locationPressed.x/(cellSizeConstant + cellSpacing)){
                
                //animation selection
                let cell = colorPicker.cellForItem(at: [0,cellNumber]) as! ColorCell

                //deselect animation
                cell.checkMarkAnimation.setOn(false, animated: true)
                
                //haptic feedback
                let selectionGenerator = UISelectionFeedbackGenerator()
                selectionGenerator.selectionChanged()
                
                //no cell chosen
                cellNumber = -1
                isColorChosen = false
            }
            
            // if no previous cell chosen
            else if cellNumber < 0{
                
                //update cell chosen
                cellNumber = Int(locationPressed.y/(cellSizeConstant + cellSpacing)) * 6 + Int(locationPressed.x/(cellSizeConstant + cellSpacing))
                
                //animation selection
                let cell = colorPicker.cellForItem(at: [0,cellNumber]) as! ColorCell

                //select animation
                cell.checkMarkAnimation.setOn(true, animated: true)
                
                //haptic feedback
                let selectionGenerator = UISelectionFeedbackGenerator()
                selectionGenerator.selectionChanged()
                
                //a color is chosen
                isColorChosen = true
                colorChosen = colorArray[cellNumber]
            }
            
            //see if save button should be enabled
            checkSaveEnable()
            
        }
    }
    
    @IBAction func textFieldChanged(_ sender: Any) {
        if nameTextField.text ?? "" == ""{
            textFieldFilled = false
        }
        else{
            textFieldFilled = true
        }

        //see if save button should be enabled
        checkSaveEnable()
    }
    
    //end keyboard if pressed
    @objc func dismissKeyboard(){
        nameTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
    
    //custom segment control
    @IBAction func xButton(_ sender: Any) {
        if selectedSegment != 0{
            selectedSegment = 0

            //haptic feedback
            let selectionGenerator = UISelectionFeedbackGenerator()
            selectionGenerator.selectionChanged()
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.alarmAnimate.frame.origin = self.x.frame.origin
            }, completion: nil)
            
            //retract mainview
            contentViewHeightConstraint.constant -= alarmUpdateConstant
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.25, options: .curveEaseOut, animations: {

                self.contentView.layoutIfNeeded()
                self.saveButton.frame.origin.y -= self.alarmUpdateConstant
                self.deleteView.frame.origin.y -= self.alarmUpdateConstant
                self.mainView.frame.size.height -= self.alarmUpdateConstant
                self.tableView.frame.origin.y = self.tableViewYConstant
            }, completion: nil)
            
            //check save
            checkSaveEnable()
        }
    }
    
    @IBAction func checkButton(_ sender: Any) {
        if selectedSegment != 1 && alarmsEnabled == true{
            selectedSegment = 1
            
            //haptic feedback
            let selectionGenerator = UISelectionFeedbackGenerator()
            selectionGenerator.selectionChanged()
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.alarmAnimate.frame.origin = self.checkMark.frame.origin
            }, completion: nil)
            
            //extend mainview
            contentViewHeightConstraint.constant += alarmUpdateConstant
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.25, options: .curveEaseOut, animations: {
                
                self.contentView.layoutIfNeeded()
                self.saveButton.frame.origin.y += self.alarmUpdateConstant
                self.deleteView.frame.origin.y += self.alarmUpdateConstant
                self.mainView.frame.size.height += self.alarmUpdateConstant
                self.tableView.frame.origin.y = self.tableViewYConstant
            }, completion: nil)
            
            //check save
            checkSaveEnable()
        }
    }
    
    //calendar comes down
    @IBAction func startDatePressed(_ sender: Any) {
        whichDate = DateChosen.startDate
        openCalendar()
    }
    
    @IBAction func endDatePressed(_ sender: Any) {
        whichDate = DateChosen.endDate
        openCalendar()
    }
    
    @IBAction func alarmDatePressed(_ sender: Any) {
        whichDate = DateChosen.alarmDate
        openCalendar()
    }
    
    //open calendar
    func openCalendar(){
        
        switch whichDate{
        case .startDate:
            calendarContainer.highlightedMonth = startMonth
            calendarContainer.highlightedDay = startDay
            
        case .endDate:
            calendarContainer.highlightedMonth = endMonth
            calendarContainer.highlightedDay = endDay
            
        case .alarmDate:
            calendarContainer.highlightedMonth = alarmMonth
            calendarContainer.highlightedDay = alarmDay
            
        case .neither:
            Swift.print("error - opencalendar")
        }
        
        //enable blurview
        blurView.isHidden = false
        
        calendarContainer.collectionView.reloadData()
        calendarContainer.collectionView.scrollToItem(at: [0,calendarContainer.highlightedMonth], at: .centeredHorizontally, animated: false)
        
        
        self.presentationController?.presentedView?.gestureRecognizers?.forEach {
            $0.isEnabled = false
        }
        
        //haptic feedback
        mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
        mediumGenerator?.prepare()
        mediumGenerator?.impactOccurred()
        mediumGenerator = nil
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.25, options: .curveEaseOut, animations: {
            
            self.calendarContainerView.frame.origin.y = (self.view.frame.height - self.calendarContainerView.frame.size.height)/2
            
        }, completion: nil)
        
        //calendar tutorial
        startingCalendarTutorial()
    }
    
    //actual saveTask
    func saveTask() {
        
        //haptic feedback
        mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
        mediumGenerator?.prepare()
        mediumGenerator?.impactOccurred()
        mediumGenerator = nil
        
        //start realm
        let realm = try! Realm()
        
        //get category realm
        let categoryRealm = realm.objects(Category.self)

        //turn color into hsba
        let hsbaList = colorChosen.getHSBAComponents()
        
        //if it is not editing
        if isEditingNewTask == false{
            //save function
            let taskRealm = TaskSaved()
            
            //name
            taskRealm.name = nameTextField.text ?? ""
            
            //category
            taskRealm.category = categoryNum
            
            //if no category chosen
            if categoryNum == -1{
                taskRealm.categoryName = ""
            }
            else{
                taskRealm.categoryName = categoryRealm[categoryNum].name
            }
            
            //colors
            taskRealm.h = hsbaList.hue
            taskRealm.s = hsbaList.saturation
            taskRealm.b = hsbaList.brightness
            taskRealm.a = hsbaList.alpha
            
            //color num
            if customColor.isHidden == true{
                taskRealm.colorNum = cellNumber
            }
            
            //start dates
            taskRealm.startMonth = startMonth
            taskRealm.startDay = startDay
            
            //end dates
            taskRealm.endMonth = endMonth
            taskRealm.endDay = endDay
            
            //if alarm enabled or not
            if selectedSegment == 0{
                taskRealm.alarmEnabled = false
            }
            else{
                taskRealm.alarmEnabled = true
                
                //add alarm
                let center = UNUserNotificationCenter.current()
                
                //alarm contents
                let content = UNMutableNotificationContent()
                content.title = nameTextField.text ?? ""
                
                //alarm time
                var dateComponents = DateComponents()
                dateComponents.year = Int(alarmMonth/12) + 2020
                dateComponents.month = alarmMonth % 12 + 1
                dateComponents.day = alarmDay
                dateComponents.hour = alarmHour
                dateComponents.minute = alarmMinute

                //save alarm times
                taskRealm.alarmMonth = alarmMonth
                taskRealm.alarmDay = alarmDay
                taskRealm.alarmHour = alarmHour
                taskRealm.alarmMinute = alarmMinute
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                
                let uuidString = UUID().uuidString
                
                taskRealm.alarmID = uuidString
                
                let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
                
                center.add(request) { (error) in
                    
                }
            }
            
            try! realm.write {
                realm.add(taskRealm)
            }
        }
        
        //if editing
        else{
            print("HAS EDITED")
            //get editing task

            //Jan 1 2020
            var dateComponents = DateComponents()
            dateComponents.year = 2020
            dateComponents.month = 1
            dateComponents.day = 1
            
            let firstDate = Calendar.current.date(from: dateComponents)!
            
            //calculations to find what month and day it is
            var daysAdded = DateComponents()
            daysAdded.day = editingDaysSince
            
            let newDate = Calendar.current.date(byAdding: daysAdded, to: firstDate)!
            
            let monthSince = Calendar.current.dateComponents([.month], from: firstDate, to: newDate).month ?? 0
            
            let daySince = Calendar.current.dateComponents([.day], from: newDate).day ?? 0
            
            //filter out saved tasks for the displayed day
            let taskSaved = realm.objects(TaskSaved.self).filter("startMonth <= %@ AND startDay <= %@ AND endMonth >= %@ AND endDay >= %@", monthSince,daySince,monthSince,daySince)
            
            let taskRealm = taskSaved[editingPath]
            
            //remove previous alarm if it exists
            if taskRealm.alarmEnabled == true{
                let alarmID = taskRealm.alarmID
                
                let center = UNUserNotificationCenter.current()
                
                //remove notification
                center.removePendingNotificationRequests(withIdentifiers: [alarmID])
            }
            
            try! realm.write{
                taskRealm.name = nameTextField.text ?? ""
                
                //category
                taskRealm.category = categoryNum
                
                //if no category chosen
                if categoryNum == -1{
                    taskRealm.categoryName = ""
                }
                else{
                    taskRealm.categoryName = categoryRealm[categoryNum].name
                }
                
                //colors
                taskRealm.h = hsbaList.hue
                taskRealm.s = hsbaList.saturation
                taskRealm.b = hsbaList.brightness
                taskRealm.a = hsbaList.alpha

                //color num
                if customColor.isHidden == true{
                    taskRealm.colorNum = cellNumber
                }
                
                //start dates
                taskRealm.startMonth = startMonth
                taskRealm.startDay = startDay
                
                //end dates
                taskRealm.endMonth = endMonth
                taskRealm.endDay = endDay
                
                //if alarm enabled or not
                if selectedSegment == 0{
                    taskRealm.alarmEnabled = false
                }
                else{
                    taskRealm.alarmEnabled = true
                    
                    //add alarm
                    let center = UNUserNotificationCenter.current()
                    
                    //alarm contents
                    let content = UNMutableNotificationContent()
                    content.title = nameTextField.text ?? ""
                    
                    //alarm time
                    var dateComponents = DateComponents()
                    dateComponents.year = Int(alarmMonth/12) + 2020
                    dateComponents.month = alarmMonth % 12 + 1
                    dateComponents.day = alarmDay
                    dateComponents.hour = alarmHour
                    dateComponents.minute = alarmMinute

                    //save alarm times
                    taskRealm.alarmMonth = alarmMonth
                    taskRealm.alarmDay = alarmDay
                    taskRealm.alarmHour = alarmHour
                    taskRealm.alarmMinute = alarmMinute
                    
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                    
                    let uuidString = UUID().uuidString
                    
                    taskRealm.alarmID = uuidString
                    
                    let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
                    
                    center.add(request) { (error) in
                        
                    }
                }
                //alarm dates
                taskRealm.alarmMonth = alarmMonth
                taskRealm.alarmDay = alarmDay
                
            }
        }
    }
    
    @IBAction func deleteTask(_ sender: Any) {
        //haptic feedback
        mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
        mediumGenerator?.prepare()
        mediumGenerator?.impactOccurred()
        mediumGenerator = nil
    }
    
    //whether or not save enabled
    func checkSaveEnable(){
        
        //textfield not empty
        if textFieldFilled == true &&
        
        //color chosen
        isColorChosen == true &&
        
        //end date > start date
        endDay >= startDay && endMonth >= startMonth{
            
            //if no alarm
            if selectedSegment == 0{
                //save button is enabled + turns green
                saveButton.isUserInteractionEnabled = true
                UIView.animate(withDuration: 0.5, animations: {
                    self.saveButton.backgroundColor = UIColor(hex: "5DD048")
                })
            }
            // if alarm
            else{
                
                //check if alarm is > current time
                var dateComponents = DateComponents()
                dateComponents.year = Int(alarmMonth/12) + 2020
                dateComponents.month = alarmMonth % 12 + 1
                dateComponents.day = alarmDay
                dateComponents.hour = alarmHour
                dateComponents.minute = alarmMinute
                
                let alarmDate = Calendar.current.date(from: dateComponents)!
                
                if alarmDate > Date(){
                    //save button is enabled + turns green
                    saveButton.isUserInteractionEnabled = true
                    UIView.animate(withDuration: 0.5, animations: {
                        self.saveButton.backgroundColor = UIColor(hex: "5DD048")
                    })
                    
                }
                else{
                    //save button is disabled + turns gray
                    saveButton.isUserInteractionEnabled = false
                    
                    UIView.animate(withDuration: 0.5, animations: {
                        self.saveButton.backgroundColor = UIColor(hex: "C8C8C8")
                    })
                }
                            
            }
        }
            
        else{
            //save button is disabled + turns gray
            saveButton.isUserInteractionEnabled = false
            
            UIView.animate(withDuration: 0.5, animations: {
                self.saveButton.backgroundColor = UIColor(hex: "C8C8C8")
            })
        }
        
    }
    
    
    //set calendar delegate + refresh data in planner VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CalendarPopup"{
            calendarContainer = segue.destination as! CalendarPopup
            
            calendarContainer.delegate = self
        }
        
        if segue.identifier == "Planner"{
            let plannerVC = segue.destination as! Planner
            
            saveTask()
            
            plannerVC.plannerCV.reloadData()
        }
    }
    
    
    //if done tapped on textfield
    @objc func tapDone() {
        if let datePicker = self.timeTextField.inputView as? UIDatePicker {
            let dateformatter = DateFormatter()
            dateformatter.timeStyle = .short
            dateformatter.dateStyle = .none
            self.timeTextField.text = dateformatter.string(from: datePicker.date)
            
            let alarmTime = Calendar.current.dateComponents([.hour,.minute], from: datePicker.date)
            
            alarmHour = alarmTime.hour ?? 0
            alarmMinute = alarmTime.minute ?? 0
        }
        
        //check save
        checkSaveEnable()
        self.timeTextField.resignFirstResponder()
    }
    
    //exit calendar if pressed outside
    @IBAction func blurViewPressed(_ sender: Any) {
        
        //same date as started with
        switch whichDate{
        case .startDate:
            registerPress(day: startDay, monthsSince: startMonth)
        case .endDate:
            registerPress(day: endDay, monthsSince: endMonth)
        case .alarmDate:
            registerPress(day: alarmDay, monthsSince: alarmMonth)
        case .neither:
            Swift.print("error")
        }
        
        blurView.isHidden = true
    }
}

extension NewTask: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //start realm
        let realm = try! Realm()
        
        //call category from realms
        let categoryRealm = realm.objects(Category.self)
        
        return categoryRealm.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell") as! NewTaskCategoryCell
        
        //start realm
        let realm = try! Realm()
        
        let categoryRealm = realm.objects(Category.self)
        
        let categoryItem = categoryRealm[indexPath.item]
        
        //set name
        cell.categoryName.text = categoryItem.name

        //cell checkmark settings
        cell.checkMark.boxType = .square
        cell.checkMark.onAnimationType = .oneStroke
        cell.checkMark.tintColor = .clear
        cell.checkMark.onCheckColor = .white
        cell.checkMark.onTintColor = .white
        
        if screenWidth == 375 && screenHeight == 812{
            cell.colorView.frame = CGRect(x: 0, y: 0, width: 40, height: 44)
            cell.seperator.frame = CGRect(x: 0, y: 42, width: 299, height: 2)
            cell.categoryName.frame = CGRect(x: 50, y: 9, width: 209, height: 26)
            cell.checkMark.frame = CGRect(x: 269, y: 9, width: 25, height: 25)
        }
        
        else if screenWidth == 375 && screenHeight == 667{
            cell.colorView.frame = CGRect(x: 0, y: 0, width: 40, height: 44)
            cell.seperator.frame = CGRect(x: 0, y: 43, width: 299, height: 1)
            cell.categoryName.frame = CGRect(x: 50, y: 9.5, width: 209, height: 26)
            cell.checkMark.frame = CGRect(x: 269, y: 9.5, width: 25, height: 25)
        }
        else if screenWidth == 320 && screenHeight == 568{
            cell.colorView.frame = CGRect(x: 0, y: 0, width: 30, height: 32)
            cell.seperator.frame = CGRect(x: 0, y: 31, width: 244, height: 1)
            cell.categoryName.font = cell.categoryName.font.withSize(15)
            cell.categoryName.frame = CGRect(x: 35, y: 5.5, width: 179, height: 20)
            cell.checkMark.frame = CGRect(x: 219, y: 5.5, width: 20, height: 20)
        }
        else if screenWidth == 768 && screenHeight == 1024{
            cell.colorView.frame = CGRect(x: 0, y: 0, width: 70, height: 59)
            cell.seperator.frame = CGRect(x: 0, y: 59, width: 634, height: 2)
            cell.categoryName.font = cell.categoryName.font.withSize(30)
            cell.categoryName.frame = CGRect(x: 80, y: 10, width: 488, height: 39)
            cell.checkMark.frame = CGRect(x: 578, y: 10, width: 41, height: 41)
        }
        else if screenWidth == 834 && screenHeight == 1112{
            cell.colorView.frame = CGRect(x: 0, y: 0, width: 70, height: 59)
            cell.seperator.frame = CGRect(x: 0, y: 59, width: 634, height: 2)
            cell.categoryName.font = cell.categoryName.font.withSize(30)
            cell.categoryName.frame = CGRect(x: 80, y: 10, width: 488, height: 39)
            cell.checkMark.frame = CGRect(x: 578, y: 10, width: 41, height: 41)
        }
        else if screenWidth == 1024 && screenHeight == 1366{
            cell.colorView.frame = CGRect(x: 0, y: 0, width: 70, height: 59)
            cell.seperator.frame = CGRect(x: 0, y: 59, width: 634, height: 2)
            cell.categoryName.font = cell.categoryName.font.withSize(30)
            cell.categoryName.frame = CGRect(x: 80, y: 10, width: 488, height: 39)
            cell.checkMark.frame = CGRect(x: 578, y: 10, width: 41, height: 41)
        }
        else if screenWidth == 834 && screenHeight == 1194{
            cell.colorView.frame = CGRect(x: 0, y: 0, width: 70, height: 59)
            cell.seperator.frame = CGRect(x: 0, y: 59, width: 634, height: 2)
            cell.categoryName.font = cell.categoryName.font.withSize(30)
            cell.categoryName.frame = CGRect(x: 80, y: 10, width: 488, height: 39)
            cell.checkMark.frame = CGRect(x: 578, y: 10, width: 41, height: 41)
        }
        else if screenWidth == 810 && screenHeight == 1080{
            cell.colorView.frame = CGRect(x: 0, y: 0, width: 70, height: 59)
            cell.seperator.frame = CGRect(x: 0, y: 59, width: 634, height: 2)
            cell.categoryName.font = cell.categoryName.font.withSize(30)
            cell.categoryName.frame = CGRect(x: 80, y: 10, width: 488, height: 39)
            cell.checkMark.frame = CGRect(x: 578, y: 10, width: 41, height: 41)
        }
        
        
        //if selected category - select it
        if categoryNum == indexPath.row{
            cell.checkMark.setOn(true, animated: false)
        }
        
        //set color
        cell.colorView.backgroundColor = UIColor(hue: CGFloat(categoryItem.h), saturation: CGFloat(categoryItem.s), brightness: CGFloat(categoryItem.b), alpha: CGFloat(categoryItem.a))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //start realm
        let realm = try! Realm()
        
        //call category from realms
        let categoryRealm = realm.objects(Category.self)
        
        //if last row - get rid of seperator
        if indexPath.row == categoryRealm.count - 1{
            if screenWidth == 320 && screenHeight == 568{
                return 30
            }
            else if screenWidth == 768 && screenHeight == 1024{
                return 59
            }
            else if screenWidth == 1024 && screenHeight == 1366{
                return 59
            }
            else if screenWidth == 834 && screenHeight == 1194{
                return 59
            }
            else if screenWidth == 834 && screenHeight == 1112{
                return 59
            }
            else if screenWidth == 810 && screenHeight == 1080{
                return 59
            }
            return 42
        }

        if screenWidth == 320 && screenHeight == 568{
            return 32
        }
        else if screenWidth == 768 && screenHeight == 1024{
            return 61
        }
        else if screenWidth == 1024 && screenHeight == 1366{
            return 61
        }
        else if screenWidth == 834 && screenHeight == 1194{
            return 61
        }
        else if screenWidth == 834 && screenHeight == 1112{
            return 61
        }
        else if screenWidth == 810 && screenHeight == 1080{
            return 61
        }
        return 44
        
    }
}

extension NewTask: registerPress{
    func registerPress(day: Int, monthsSince: Int) {
        //haptic feedback
        let selectionGenerator = UISelectionFeedbackGenerator()
        selectionGenerator.selectionChanged()
        
        //save + label
        switch whichDate{
        case .startDate:
            startDay = day
            startMonth = monthsSince
            startLabel.text = "\(monthArray[monthsSince % 12]) \(day), \(Int(monthsSince/12) + 2020)"
            
        case .endDate:
            endDay = day
            endMonth = monthsSince
            endLabel.text = "\(monthArray[monthsSince % 12]) \(day), \(Int(monthsSince/12) + 2020)"
        
        case .alarmDate:
            alarmDay = day
            alarmMonth = monthsSince
            alarmLabel.text = "\(monthArray[monthsSince % 12]) \(day), \(Int(monthsSince/12) + 2020)"
            
        case .neither:
            Swift.print("error")
        }
        
        self.presentationController?.presentedView?.gestureRecognizers?.forEach {
            $0.isEnabled = true
        }
        
        //turn off blurview
        blurView.isHidden = true
        
        //close calendar
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            
            self.calendarContainerView.frame.origin.y = -self.calendarContainerView.frame.size.height
            
        }, completion:nil)
        
        calendarContainer.isYearEnabled = false
        
        //see if save button should be enabled
        checkSaveEnable()
    }
}

//setup collection view
extension NewTask: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
       //Basic Collectionview setup
       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return 36
       }
       
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "color", for: indexPath) as! ColorCell

            cell.backgroundColor = colorArray[indexPath.item]
            
            cell.checkMarkAnimation.boxType = .square
            cell.checkMarkAnimation.onAnimationType = .oneStroke
            cell.checkMarkAnimation.tintColor = .clear
            //cell.checkMarkAnimation.onFillColor = UIColor(hex: "E85A4F")
            cell.checkMarkAnimation.onCheckColor = .white
            cell.checkMarkAnimation.onTintColor = .white
            
            cell.checkMarkAnimation.center = CGPoint(x: cell.frame.size.width/2, y: cell.frame.size.height/2)
            
            if screenWidth == 320 && screenHeight == 568{
                cell.checkMarkAnimation.frame.size = CGSize(width: 20, height: 20)
                cell.checkMarkAnimation.center = CGPoint(x: 35/2, y: 35/2)
            }
            else if screenWidth == 768 && screenHeight == 1024{
                cell.checkMarkAnimation.frame.size = CGSize(width: 80, height: 80)
                cell.checkMarkAnimation.center = CGPoint(x: 95/2, y: 95/2)
            }
            else if screenWidth == 834 && screenHeight == 1194{
                cell.checkMarkAnimation.frame.size = CGSize(width: 80, height: 80)
                cell.checkMarkAnimation.center = CGPoint(x: 95/2, y: 95/2)
            }
            else if screenWidth == 834 && screenHeight == 1112{
                cell.checkMarkAnimation.frame.size = CGSize(width: 80, height: 80)
                cell.checkMarkAnimation.center = CGPoint(x: 95/2, y: 95/2)
            }
            else if screenWidth == 810 && screenHeight == 1080{
                cell.checkMarkAnimation.frame.size = CGSize(width: 80, height: 80)
                cell.checkMarkAnimation.center = CGPoint(x: 95/2, y: 95/2)
            }
            else if screenWidth == 1024 && screenHeight == 1366{
                cell.checkMarkAnimation.frame.size = CGSize(width: 80, height: 80)
                cell.checkMarkAnimation.center = CGPoint(x: 95/2, y: 95/2)
            }
            
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return cellSpacing
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return cellSpacing
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: cellSizeConstant, height: cellSizeConstant)
        }
}

extension NewTask: CircleColorPickerViewDelegate{
    func onColorChanged(newColor: CGColor) {
        //only happens if custom color picker is selected
        if customColor.isHidden == false{
            colorChosen = UIColor(cgColor: newColor)
            
            /*
            scrollView.isScrollEnabled = false

            self.presentationController?.presentedView?.gestureRecognizers?.forEach {
                $0.isEnabled = false
            }
                 */
            let selectionGenerator = UISelectionFeedbackGenerator()
            selectionGenerator.selectionChanged()
            
            isColorChosen = true
        }
    }
}

extension NewTask: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


//datepicker in keyboard

extension UITextField {
    
    func setInputViewDatePicker(target: Any, selector: Selector) {
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = .time
        self.inputView = datePicker
        
        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel))
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancel, flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
    
}
