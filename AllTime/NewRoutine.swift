//
//  NewRoutine.swift
//  TimeKeep
//
//  Created by Mi Yan on 5/16/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//

import UIKit
import RealmSwift
import BEMCheckBox
import CircleColorPicker

class NewRoutine: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var premadeColorCV: UICollectionView!
    @IBOutlet weak var customColor: CircleColorPickerView!
    
    @IBOutlet weak var selectedView: UIView!
    
    @IBOutlet weak var goalLabel: UILabel!
    
    var isColorChosen = false
    
    //haptic feedback
    var mediumGenerator: UIImpactFeedbackGenerator? = nil
    
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var amountButton: UIButton!
    
    //color selected from colorpicker -- -1 = no cell chosen
    var cellNumber = -1
    
    //get selected category #
    var categoryNum = -1
    
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
    
    enum routineType{
        case time
        case amount
    }
    
    var chosenRoutineType = routineType.time
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var goalTextField: UITextField!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var colorChosen: UIColor = .clear
    
    //check save
    var isNameFilled = false
    var isGoalFilled = false
    
    //resize
    var screenWidth: CGFloat = 0
    var screenHeight: CGFloat = 0
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    //all labels
    @IBOutlet weak var newRoutine: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var goal: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var trashCanView: UIView!
    @IBOutlet weak var trashCanIconImageView: UIImageView!
    @IBOutlet weak var trashCanButton: UIButton!
    
    @IBOutlet weak var masterView: UIView!
    
    //seperators
    @IBOutlet weak var firstSeperator: UIView!
    @IBOutlet weak var secondSeperator: UIView!
    @IBOutlet weak var thirdSeperator: UIView!
    @IBOutlet weak var fourthSeperator: UIView!
    
    //custom or premade buttons and labels
    @IBOutlet weak var customLabel: UILabel!
    @IBOutlet weak var customButton: UIButton!
    
    //time or amount label
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    //cell size constant
    var cellSizeConstant: CGFloat = 50
    var cellSpacing: CGFloat = 4
    
    //tutorial for custom color & calendar
    @IBOutlet weak var tutorialBlurView: UIView!
    @IBOutlet weak var flippedTriangle: UIImageView!
    @IBOutlet weak var triangle: UIImageView!
    @IBOutlet weak var tutorialView: UIView!
    @IBOutlet weak var tutorialLabel: UILabel!
    @IBOutlet weak var moveOnButton: UIButton!

    var customColorState = 0
    var shouldCustomColorTutorial = false
    
    var tableViewRowHeight: CGFloat = 44
    
    var tutorialSpacingWidth: CGFloat = 24
    var tutorialScreenWidth: CGFloat = 0
    
    //if has viewDidAppeared before
    var hasViewDidAppearBefore: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //custom color delegate
        customColor.delegate = self
        
        //standard tableview delegate
        tableView.delegate = self
        tableView.dataSource = self
        
        //set tableview border color
        tableView.layer.borderColor = UIColor.black.cgColor
        tableView.layer.borderWidth = 2
        
        //standard collection view delegate
        premadeColorCV.delegate = self
        premadeColorCV.dataSource = self
        
        //textfield delegate
        nameTextField.delegate = self
        goalTextField.delegate = self
        
        //check if custom color tutorial
        let realm = try! Realm()
        
        let firstRealmTutorial = realm.objects(ShouldTutorial.self)[0]
        
        if firstRealmTutorial.shouldCustomColorTutorial == true{
            shouldCustomColorTutorial = true
        }
        
        //dismiss keyboard if tapped outside
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        contentView.addGestureRecognizer(tapGesture)
        
        //register taps on the collectionview
        let collectionViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapColorPicker(_:)))
        premadeColorCV.addGestureRecognizer(collectionViewTapGesture)

        //register taps on the tableview
        let tableViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapTableView(_:)))
        tableView.addGestureRecognizer(tableViewTapGesture)
        
        //resize everything
        let screen = UIScreen.main.bounds
        screenWidth = screen.size.width
        screenHeight = screen.size.height
        
        //set custom color to hidden and color picker to not hidden
        customColor.isHidden = true
        premadeColorCV.isHidden = false
        
        resizeDevice()
     }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        //setup custom color picker knobs
        customColor.setupMaskImages(image: UIImage(named: "transparentCircle"))
        
        
        //select red - first ColorCell
        cellNumber = 0
        let cell = premadeColorCV.cellForItem(at: [0,cellNumber]) as! ColorCell

        //color chosen
        isColorChosen = true
        colorChosen = colorArray[cellNumber]

        //select animation
        cell.checkMarkAnimation.setOn(true, animated: true)
        
        //set customColor Picker Color
        customColor.color = colorChosen.cgColor
    }
    
    //resize device
    func resizeDevice(){
        tutorialScreenWidth = screenWidth
        if screenWidth == 375 && screenHeight == 812{
            newRoutine.font = newRoutine.font.withSize(35)
            newRoutine.frame = CGRect(x: 24, y: 33, width: 252, height: 46)
            
            masterView.frame = CGRect(x: 24, y: 103, width: 327, height: 840)
            
            nameLabel.font = nameLabel.font.withSize(15)
            nameLabel.frame = CGRect(x: 14, y: 14, width: 52, height: 20)
            
            nameTextField.font = nameTextField.font?.withSize(15)
            nameTextField.frame = CGRect(x: 70, y: 14, width: 243, height: 20)
            
            firstSeperator.frame = CGRect(x: 0, y: 48, width: 327, height: 2)
            
            colorLabel.font = colorLabel.font.withSize(15)
            colorLabel.frame = CGRect(x: 14, y: 64, width: 58, height: 20)
            
            premadeColorCV.frame = CGRect(x: 28, y: 98, width: 270, height: 270)
            customColor.frame = CGRect(x: 28, y: 98, width: 270, height: 270)
            
            customButton.frame = CGRect(x: 79, y: 382, width: 168, height: 33)
            customLabel.frame = CGRect(x: 119, y: 385, width: 88, height: 27)
            
            secondSeperator.frame = CGRect(x: 0, y: 434, width: 327, height: 2)
            
            timeLabel.frame = CGRect(x: 14, y: 450, width: 150, height: 42)
            timeButton.frame = CGRect(x: 14, y: 450, width: 150, height: 42)
            selectedView.frame = CGRect(x: 14, y: 450, width: 150, height: 42)
            
            amountLabel.frame = CGRect(x: 164, y: 450, width: 150, height: 42)
            amountButton.frame = CGRect(x: 164, y: 450, width: 150, height: 42)
            
            thirdSeperator.frame = CGRect(x: 0, y: 506, width: 327, height: 2)
            
            goal.font = goal.font.withSize(15)
            goal.frame = CGRect(x: 14, y: 522, width: 48, height: 20)
            
            goalTextField.frame = CGRect(x: 72, y: 522, width: 108, height: 20)
            
            goalLabel.font = goalLabel.font.withSize(15)
            goalLabel.frame = CGRect(x: 185, y: 522, width: 128, height: 20)
            
            fourthSeperator.frame = CGRect(x: 0, y: 556, width: 327, height: 2)
            
            categoryLabel.font = categoryLabel.font.withSize(15)
            categoryLabel.frame = CGRect(x: 14, y: 572, width: 85, height: 20)
            
            tableView.frame = CGRect(x: 14, y: 606, width: 299, height: 220)
            
            saveButton.titleLabel?.font = saveButton.titleLabel?.font.withSize(30)
            saveButton.frame = CGRect(x: 24, y: 957, width: 260, height: 51)
            
            trashCanView.frame = CGRect(x: 294, y: 957, width: 57, height: 51)
            trashCanButton.frame = CGRect(x: 0, y: 0, width: 57, height: 51)
            trashCanIconImageView.frame = CGRect(x: 14, y: 9, width: 29, height: 33)
            
            heightConstraint.constant = 1022
            
            cellSizeConstant = 40
            cellSpacing = 6
        }
        else if screenHeight == 736 && screenWidth == 414{
            tutorialLabel.font = tutorialLabel.font.withSize(35) 
        }
        else if screenWidth == 375 && screenHeight == 667{
            newRoutine.font = newRoutine.font.withSize(35)
            newRoutine.frame = CGRect(x: 24, y: 33, width: 252, height: 46)
            
            tutorialLabel.font = tutorialLabel.font.withSize(30)
            
            tableView.layer.borderWidth = 1
            
            masterView.frame = CGRect(x: 24, y: 103, width: 327, height: 840)
            
            nameLabel.font = nameLabel.font.withSize(15)
            nameLabel.frame = CGRect(x: 14, y: 14, width: 52, height: 20)
            
            nameTextField.font = nameTextField.font?.withSize(15)
            nameTextField.frame = CGRect(x: 70, y: 14, width: 243, height: 20)
            
            firstSeperator.frame = CGRect(x: 0, y: 48, width: 327, height: 2)
            
            colorLabel.font = colorLabel.font.withSize(15)
            colorLabel.frame = CGRect(x: 14, y: 64, width: 58, height: 20)
            
            premadeColorCV.frame = CGRect(x: 28, y: 98, width: 270, height: 270)
            customColor.frame = CGRect(x: 28, y: 98, width: 270, height: 270)
            
            customButton.frame = CGRect(x: 79, y: 382, width: 168, height: 33)
            customLabel.frame = CGRect(x: 119, y: 385, width: 88, height: 27)
            
            secondSeperator.frame = CGRect(x: 0, y: 434, width: 327, height: 2)
            
            timeLabel.frame = CGRect(x: 14, y: 450, width: 150, height: 42)
            timeButton.frame = CGRect(x: 14, y: 450, width: 150, height: 42)
            selectedView.frame = CGRect(x: 14, y: 450, width: 150, height: 42)
            
            amountLabel.frame = CGRect(x: 164, y: 450, width: 150, height: 42)
            amountButton.frame = CGRect(x: 164, y: 450, width: 150, height: 42)
            
            thirdSeperator.frame = CGRect(x: 0, y: 506, width: 327, height: 2)
            
            goal.font = goal.font.withSize(15)
            goal.frame = CGRect(x: 14, y: 522, width: 48, height: 20)
            
            goalTextField.frame = CGRect(x: 72, y: 522, width: 108, height: 20)
            
            goalLabel.font = goalLabel.font.withSize(15)
            goalLabel.frame = CGRect(x: 185, y: 522, width: 128, height: 20)
            
            fourthSeperator.frame = CGRect(x: 0, y: 556, width: 327, height: 2)
            
            categoryLabel.font = categoryLabel.font.withSize(15)
            categoryLabel.frame = CGRect(x: 14, y: 572, width: 85, height: 20)
            
            tableView.frame = CGRect(x: 14, y: 606, width: 299, height: 220)
            
            saveButton.titleLabel?.font = saveButton.titleLabel?.font.withSize(30)
            saveButton.frame = CGRect(x: 24, y: 957, width: 260, height: 51)
            
            trashCanView.frame = CGRect(x: 294, y: 957, width: 57, height: 51)
            trashCanButton.frame = CGRect(x: 0, y: 0, width: 57, height: 51)
            trashCanIconImageView.frame = CGRect(x: 14, y: 9, width: 29, height: 33)
            
            heightConstraint.constant = 1022
            
            cellSizeConstant = 40
            cellSpacing = 6
        }
        else if screenWidth == 320 && screenHeight == 568{
            tableViewRowHeight = 32
            tableView.layer.borderWidth = 1
            
            tutorialLabel.font = tutorialLabel.font.withSize(25)
            
            newRoutine.font = newRoutine.font.withSize(30)
            newRoutine.frame = CGRect(x: 24, y: 33, width: 216, height: 39)
            
            masterView.frame = CGRect(x: 24, y: 96, width: 272, height: 795)
            
            nameLabel.font = nameLabel.font.withSize(15)
            nameLabel.frame = CGRect(x: 14, y: 14, width: 52, height: 20)
            
            nameTextField.font = nameTextField.font?.withSize(15)
            nameTextField.frame = CGRect(x: 71, y: 14, width: 187, height: 20)
            
            firstSeperator.frame = CGRect(x: 0, y: 48, width: 272, height: 2)
            
            colorLabel.font = colorLabel.font.withSize(15)
            colorLabel.frame = CGRect(x: 14, y: 64, width: 58, height: 20)
            
            premadeColorCV.frame = CGRect(x: 21, y: 98, width: 230, height: 230)
            customColor.frame = CGRect(x: 21, y: 98, width: 230, height: 230)
            
            customButton.frame = CGRect(x: 52, y: 342, width: 168, height: 33)
            customLabel.frame = CGRect(x: 92, y: 345, width: 88, height: 27)
            
            secondSeperator.frame = CGRect(x: 0, y: 389, width: 272, height: 2)
            
            timeLabel.font = timeLabel.font.withSize(18)
            timeLabel.frame = CGRect(x: 14, y: 405, width: 122, height: 42)
            timeButton.frame = CGRect(x: 14, y: 405, width: 122, height: 42)
            selectedView.frame = CGRect(x: 14, y: 405, width: 122, height: 42)
            
            amountLabel.font = amountLabel.font.withSize(18)
            amountLabel.frame = CGRect(x: 136, y: 405, width: 122, height: 42)
            amountButton.frame = CGRect(x: 136, y: 405, width: 122, height: 42)
            
            thirdSeperator.frame = CGRect(x: 0, y: 461, width: 272, height: 2)
            
            goal.font = goal.font.withSize(15)
            goal.frame = CGRect(x: 14, y: 477, width: 48, height: 20)
            
            goalTextField.frame = CGRect(x: 72, y: 477, width: 106, height: 20)
            
            goalLabel.font = goalLabel.font.withSize(15)
            goalLabel.frame = CGRect(x: 183, y: 477, width: 75, height: 20)
            
            fourthSeperator.frame = CGRect(x: 0, y: 511, width: 272, height: 2)
            
            categoryLabel.font = categoryLabel.font.withSize(15)
            categoryLabel.frame = CGRect(x: 14, y: 527, width: 85, height: 20)
            
            tableView.frame = CGRect(x: 14, y: 561, width: 244, height: 220)
            
            saveButton.titleLabel?.font = saveButton.titleLabel?.font.withSize(25)
            saveButton.frame = CGRect(x: 24, y: 905, width: 213, height: 42)
            
            trashCanView.frame = CGRect(x: 247, y: 905, width: 49, height: 42)
            trashCanButton.frame = CGRect(x: 0, y: 0, width: 49, height: 42)
            trashCanIconImageView.frame = CGRect(x: 12, y: 7, width: 25, height: 28)
            
            heightConstraint.constant = 961
            
            cellSizeConstant = 35
            cellSpacing = 4
        }
        else if screenWidth == 768 && screenHeight == 1024{
            tutorialScreenWidth = 712
            
            tutorialLabel.font = tutorialLabel.font.withSize(55)
            
            tableViewRowHeight = 61
            
            newRoutine.font = newRoutine.font.withSize(50)
            newRoutine.frame = CGRect(x: 24, y: 30, width: 360, height: 65)
            
            masterView.frame = CGRect(x: 24, y: 125, width: 664, height: 1463)
            
            nameLabel.font = nameLabel.font.withSize(30)
            nameLabel.frame = CGRect(x: 15, y: 15, width: 103, height: 39)
            
            nameTextField.font = nameTextField.font?.withSize(30)
            nameTextField.frame = CGRect(x: 123, y: 15, width: 526, height: 39)
            
            firstSeperator.frame = CGRect(x: 0, y: 69, width: 664, height: 2)
            
            colorLabel.font = colorLabel.font.withSize(30)
            colorLabel.frame = CGRect(x: 15, y: 86, width: 115, height: 39)
            
            premadeColorCV.frame = CGRect(x: 17, y: 140, width: 630, height: 630)
            customColor.frame = CGRect(x: 17, y: 140, width: 630, height: 630)
            
            customButton.frame = CGRect(x: 192, y: 785, width: 280, height: 52)
            customLabel.frame = CGRect(x: 192, y: 797, width: 280, height: 27)
            
            customLabel.font = customLabel.font.withSize(20)
            
            secondSeperator.frame = CGRect(x: 0, y: 852, width: 684, height: 2)
            
            timeLabel.font = timeLabel.font.withSize(30)
            timeLabel.frame = CGRect(x: 15, y: 869, width: 317, height: 61)
            timeButton.frame = CGRect(x: 15, y: 869, width: 317, height: 61)
            selectedView.frame = CGRect(x: 15, y: 869, width: 317, height: 61)
            
            amountLabel.font = amountLabel.font.withSize(30)
            amountLabel.frame = CGRect(x: 332, y: 869, width: 317, height: 61)
            amountButton.frame = CGRect(x: 332, y: 869, width: 317, height: 61)
            
            thirdSeperator.frame = CGRect(x: 0, y: 945, width: 664, height: 2)
            
            goal.font = goal.font.withSize(30)
            goal.frame = CGRect(x: 15, y: 962, width: 96, height: 39)
            
            goalTextField.font = goalTextField.font?.withSize(30)
            goalTextField.frame = CGRect(x: 116, y: 962, width: 204, height: 39)
            
            goalLabel.font = goalLabel.font.withSize(30)
            goalLabel.frame = CGRect(x: 325, y: 962, width: 200, height: 39)
            
            fourthSeperator.frame = CGRect(x: 0, y: 1016, width: 664, height: 2)
            
            categoryLabel.font = categoryLabel.font.withSize(30)
            categoryLabel.frame = CGRect(x: 15, y: 1033, width: 170, height: 39)
            
            tableView.frame = CGRect(x: 15, y: 1092, width: 634, height: 356)
            
            saveButton.titleLabel?.font = saveButton.titleLabel?.font.withSize(60)
            saveButton.frame = CGRect(x: 24, y: 1603, width: 508, height: 107)
            
            trashCanView.frame = CGRect(x: 547, y: 1603, width: 141, height: 107)
            trashCanButton.frame = CGRect(x: 0, y: 0, width: 141, height: 107)
            trashCanIconImageView.frame = CGRect(x: 34, y: 11, width: 73, height: 85)
            
            heightConstraint.constant = 1725
            
            cellSizeConstant = 95
            cellSpacing = 12
        }
        else if screenWidth == 1024 && screenHeight == 1366{
            tutorialScreenWidth = 712
            
            tutorialLabel.font = tutorialLabel.font.withSize(60)
            
            tableViewRowHeight = 61
            
            newRoutine.font = newRoutine.font.withSize(50)
            newRoutine.frame = CGRect(x: 24, y: 30, width: 360, height: 65)
            
            masterView.frame = CGRect(x: 24, y: 125, width: 664, height: 1463)
            
            nameLabel.font = nameLabel.font.withSize(30)
            nameLabel.frame = CGRect(x: 15, y: 15, width: 103, height: 39)
            
            nameTextField.font = nameTextField.font?.withSize(30)
            nameTextField.frame = CGRect(x: 123, y: 15, width: 526, height: 39)
            
            firstSeperator.frame = CGRect(x: 0, y: 69, width: 664, height: 2)
            
            colorLabel.font = colorLabel.font.withSize(30)
            colorLabel.frame = CGRect(x: 15, y: 86, width: 115, height: 39)
            
            premadeColorCV.frame = CGRect(x: 17, y: 140, width: 630, height: 630)
            customColor.frame = CGRect(x: 17, y: 140, width: 630, height: 630)
            
            customButton.frame = CGRect(x: 192, y: 785, width: 280, height: 52)
            customLabel.frame = CGRect(x: 192, y: 797, width: 280, height: 27)
            
            customLabel.font = customLabel.font.withSize(20)
            
            secondSeperator.frame = CGRect(x: 0, y: 852, width: 684, height: 2)
            
            timeLabel.font = timeLabel.font.withSize(30)
            timeLabel.frame = CGRect(x: 15, y: 869, width: 317, height: 61)
            timeButton.frame = CGRect(x: 15, y: 869, width: 317, height: 61)
            selectedView.frame = CGRect(x: 15, y: 869, width: 317, height: 61)
            
            amountLabel.font = amountLabel.font.withSize(30)
            amountLabel.frame = CGRect(x: 332, y: 869, width: 317, height: 61)
            amountButton.frame = CGRect(x: 332, y: 869, width: 317, height: 61)
            
            thirdSeperator.frame = CGRect(x: 0, y: 945, width: 664, height: 2)
            
            goal.font = goal.font.withSize(30)
            goal.frame = CGRect(x: 15, y: 962, width: 96, height: 39)
            
            goalTextField.font = goalTextField.font?.withSize(30)
            goalTextField.frame = CGRect(x: 116, y: 962, width: 204, height: 39)
            
            goalLabel.font = goalLabel.font.withSize(30)
            goalLabel.frame = CGRect(x: 325, y: 962, width: 200, height: 39)
            
            fourthSeperator.frame = CGRect(x: 0, y: 1016, width: 664, height: 2)
            
            categoryLabel.font = categoryLabel.font.withSize(30)
            categoryLabel.frame = CGRect(x: 15, y: 1033, width: 170, height: 39)
            
            tableView.frame = CGRect(x: 15, y: 1092, width: 634, height: 356)
            
            saveButton.titleLabel?.font = saveButton.titleLabel?.font.withSize(60)
            saveButton.frame = CGRect(x: 24, y: 1603, width: 508, height: 107)
            
            trashCanView.frame = CGRect(x: 547, y: 1603, width: 141, height: 107)
            trashCanButton.frame = CGRect(x: 0, y: 0, width: 141, height: 107)
            trashCanIconImageView.frame = CGRect(x: 34, y: 11, width: 73, height: 85)
            
            heightConstraint.constant = 1725
            
            cellSizeConstant = 95
            cellSpacing = 12
        }
        else if screenWidth == 834 && screenHeight == 1194{
            tutorialScreenWidth = 712
            
            tutorialLabel.font = tutorialLabel.font.withSize(60)
            
            tableViewRowHeight = 61
            
            newRoutine.font = newRoutine.font.withSize(50)
            newRoutine.frame = CGRect(x: 24, y: 30, width: 360, height: 65)
            
            masterView.frame = CGRect(x: 24, y: 125, width: 664, height: 1463)
            
            nameLabel.font = nameLabel.font.withSize(30)
            nameLabel.frame = CGRect(x: 15, y: 15, width: 103, height: 39)
            
            nameTextField.font = nameTextField.font?.withSize(30)
            nameTextField.frame = CGRect(x: 123, y: 15, width: 526, height: 39)
            
            firstSeperator.frame = CGRect(x: 0, y: 69, width: 664, height: 2)
            
            colorLabel.font = colorLabel.font.withSize(30)
            colorLabel.frame = CGRect(x: 15, y: 86, width: 115, height: 39)
            
            premadeColorCV.frame = CGRect(x: 17, y: 140, width: 630, height: 630)
            customColor.frame = CGRect(x: 17, y: 140, width: 630, height: 630)
            
            customButton.frame = CGRect(x: 192, y: 785, width: 280, height: 52)
            customLabel.frame = CGRect(x: 192, y: 797, width: 280, height: 27)
            
            customLabel.font = customLabel.font.withSize(20)
            
            secondSeperator.frame = CGRect(x: 0, y: 852, width: 684, height: 2)
            
            timeLabel.font = timeLabel.font.withSize(30)
            timeLabel.frame = CGRect(x: 15, y: 869, width: 317, height: 61)
            timeButton.frame = CGRect(x: 15, y: 869, width: 317, height: 61)
            selectedView.frame = CGRect(x: 15, y: 869, width: 317, height: 61)
            
            amountLabel.font = amountLabel.font.withSize(30)
            amountLabel.frame = CGRect(x: 332, y: 869, width: 317, height: 61)
            amountButton.frame = CGRect(x: 332, y: 869, width: 317, height: 61)
            
            thirdSeperator.frame = CGRect(x: 0, y: 945, width: 664, height: 2)
            
            goal.font = goal.font.withSize(30)
            goal.frame = CGRect(x: 15, y: 962, width: 96, height: 39)
            
            goalTextField.font = goalTextField.font?.withSize(30)
            goalTextField.frame = CGRect(x: 116, y: 962, width: 204, height: 39)
            
            goalLabel.font = goalLabel.font.withSize(30)
            goalLabel.frame = CGRect(x: 325, y: 962, width: 200, height: 39)
            
            fourthSeperator.frame = CGRect(x: 0, y: 1016, width: 664, height: 2)
            
            categoryLabel.font = categoryLabel.font.withSize(30)
            categoryLabel.frame = CGRect(x: 15, y: 1033, width: 170, height: 39)
            
            tableView.frame = CGRect(x: 15, y: 1092, width: 634, height: 356)
            
            saveButton.titleLabel?.font = saveButton.titleLabel?.font.withSize(60)
            saveButton.frame = CGRect(x: 24, y: 1603, width: 508, height: 107)
            
            trashCanView.frame = CGRect(x: 547, y: 1603, width: 141, height: 107)
            trashCanButton.frame = CGRect(x: 0, y: 0, width: 141, height: 107)
            trashCanIconImageView.frame = CGRect(x: 34, y: 11, width: 73, height: 85)
            
            heightConstraint.constant = 1725
            
            cellSizeConstant = 95
            cellSpacing = 12
        }
        else if screenWidth == 834 && screenHeight == 1112{
            tutorialScreenWidth = 712
            
            tutorialLabel.font = tutorialLabel.font.withSize(60)
            
            tableViewRowHeight = 61
            
            newRoutine.font = newRoutine.font.withSize(50)
            newRoutine.frame = CGRect(x: 24, y: 30, width: 360, height: 65)
            
            masterView.frame = CGRect(x: 24, y: 125, width: 664, height: 1463)
            
            nameLabel.font = nameLabel.font.withSize(30)
            nameLabel.frame = CGRect(x: 15, y: 15, width: 103, height: 39)
            
            nameTextField.font = nameTextField.font?.withSize(30)
            nameTextField.frame = CGRect(x: 123, y: 15, width: 526, height: 39)
            
            firstSeperator.frame = CGRect(x: 0, y: 69, width: 664, height: 2)
            
            colorLabel.font = colorLabel.font.withSize(30)
            colorLabel.frame = CGRect(x: 15, y: 86, width: 115, height: 39)
            
            premadeColorCV.frame = CGRect(x: 17, y: 140, width: 630, height: 630)
            customColor.frame = CGRect(x: 17, y: 140, width: 630, height: 630)
            
            customButton.frame = CGRect(x: 192, y: 785, width: 280, height: 52)
            customLabel.frame = CGRect(x: 192, y: 797, width: 280, height: 27)
            
            customLabel.font = customLabel.font.withSize(20)
            
            secondSeperator.frame = CGRect(x: 0, y: 852, width: 684, height: 2)
            
            timeLabel.font = timeLabel.font.withSize(30)
            timeLabel.frame = CGRect(x: 15, y: 869, width: 317, height: 61)
            timeButton.frame = CGRect(x: 15, y: 869, width: 317, height: 61)
            selectedView.frame = CGRect(x: 15, y: 869, width: 317, height: 61)
            
            amountLabel.font = amountLabel.font.withSize(30)
            amountLabel.frame = CGRect(x: 332, y: 869, width: 317, height: 61)
            amountButton.frame = CGRect(x: 332, y: 869, width: 317, height: 61)
            
            thirdSeperator.frame = CGRect(x: 0, y: 945, width: 664, height: 2)
            
            goal.font = goal.font.withSize(30)
            goal.frame = CGRect(x: 15, y: 962, width: 96, height: 39)
            
            goalTextField.font = goalTextField.font?.withSize(30)
            goalTextField.frame = CGRect(x: 116, y: 962, width: 204, height: 39)
            
            goalLabel.font = goalLabel.font.withSize(30)
            goalLabel.frame = CGRect(x: 325, y: 962, width: 200, height: 39)
            
            fourthSeperator.frame = CGRect(x: 0, y: 1016, width: 664, height: 2)
            
            categoryLabel.font = categoryLabel.font.withSize(30)
            categoryLabel.frame = CGRect(x: 15, y: 1033, width: 170, height: 39)
            
            tableView.frame = CGRect(x: 15, y: 1092, width: 634, height: 356)
            
            saveButton.titleLabel?.font = saveButton.titleLabel?.font.withSize(60)
            saveButton.frame = CGRect(x: 24, y: 1603, width: 508, height: 107)
            
            trashCanView.frame = CGRect(x: 547, y: 1603, width: 141, height: 107)
            trashCanButton.frame = CGRect(x: 0, y: 0, width: 141, height: 107)
            trashCanIconImageView.frame = CGRect(x: 34, y: 11, width: 73, height: 85)
            
            heightConstraint.constant = 1725
            
            cellSizeConstant = 95
            cellSpacing = 12
        }
        else if screenWidth == 810 && screenHeight == 1080{
            tutorialScreenWidth = 712
            
            tutorialLabel.font = tutorialLabel.font.withSize(60)
            
            tableViewRowHeight = 61
            
            newRoutine.font = newRoutine.font.withSize(50)
            newRoutine.frame = CGRect(x: 24, y: 30, width: 360, height: 65)
            
            masterView.frame = CGRect(x: 24, y: 125, width: 664, height: 1463)
            
            nameLabel.font = nameLabel.font.withSize(30)
            nameLabel.frame = CGRect(x: 15, y: 15, width: 103, height: 39)
            
            nameTextField.font = nameTextField.font?.withSize(30)
            nameTextField.frame = CGRect(x: 123, y: 15, width: 526, height: 39)
            
            firstSeperator.frame = CGRect(x: 0, y: 69, width: 664, height: 2)
            
            colorLabel.font = colorLabel.font.withSize(30)
            colorLabel.frame = CGRect(x: 15, y: 86, width: 115, height: 39)
            
            premadeColorCV.frame = CGRect(x: 17, y: 140, width: 630, height: 630)
            customColor.frame = CGRect(x: 17, y: 140, width: 630, height: 630)
            
            customButton.frame = CGRect(x: 192, y: 785, width: 280, height: 52)
            customLabel.frame = CGRect(x: 192, y: 797, width: 280, height: 27)
            
            customLabel.font = customLabel.font.withSize(20)
            
            secondSeperator.frame = CGRect(x: 0, y: 852, width: 684, height: 2)
            
            timeLabel.font = timeLabel.font.withSize(30)
            timeLabel.frame = CGRect(x: 15, y: 869, width: 317, height: 61)
            timeButton.frame = CGRect(x: 15, y: 869, width: 317, height: 61)
            selectedView.frame = CGRect(x: 15, y: 869, width: 317, height: 61)
            
            amountLabel.font = amountLabel.font.withSize(30)
            amountLabel.frame = CGRect(x: 332, y: 869, width: 317, height: 61)
            amountButton.frame = CGRect(x: 332, y: 869, width: 317, height: 61)
            
            thirdSeperator.frame = CGRect(x: 0, y: 945, width: 664, height: 2)
            
            goal.font = goal.font.withSize(30)
            goal.frame = CGRect(x: 15, y: 962, width: 96, height: 39)
            
            goalTextField.font = goalTextField.font?.withSize(30)
            goalTextField.frame = CGRect(x: 116, y: 962, width: 204, height: 39)
            
            goalLabel.font = goalLabel.font.withSize(30)
            goalLabel.frame = CGRect(x: 325, y: 962, width: 200, height: 39)
            
            fourthSeperator.frame = CGRect(x: 0, y: 1016, width: 664, height: 2)
            
            categoryLabel.font = categoryLabel.font.withSize(30)
            categoryLabel.frame = CGRect(x: 15, y: 1033, width: 170, height: 39)
            
            tableView.frame = CGRect(x: 15, y: 1092, width: 634, height: 356)
            
            saveButton.titleLabel?.font = saveButton.titleLabel?.font.withSize(60)
            saveButton.frame = CGRect(x: 24, y: 1603, width: 508, height: 107)
            
            trashCanView.frame = CGRect(x: 547, y: 1603, width: 141, height: 107)
            trashCanButton.frame = CGRect(x: 0, y: 0, width: 141, height: 107)
            trashCanIconImageView.frame = CGRect(x: 34, y: 11, width: 73, height: 85)
            
            heightConstraint.constant = 1725
            
            cellSizeConstant = 95
            cellSpacing = 12
        }

        //general resize
        tutorialBlurView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        moveOnButton.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
    }
    
    @IBAction func moveOnPressed(_ sender: Any) {
        customColorTutorialFunc()
        
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
    
    func customColorTutorialFunc(){
        if shouldCustomColorTutorial == true{
            if customColorState == 0{
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
                let absPosCustomColor = CGPoint(x: customColor.frame.origin.x + masterView.frame.origin.x, y: customColor.frame.origin.y + masterView.frame.origin.y - tempContentOffset)
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
                
                tutorialView.frame.origin.x = tutorialScreenWidth
                triangle.frame.origin.x = tutorialScreenWidth
                
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                    self.tutorialView.frame.origin.x = prevTV
                    self.triangle.frame.origin.x = prevT
                }, completion: nil)

                //disable scroll
                self.presentationController?.presentedView?.gestureRecognizers?.forEach {
                    $0.isEnabled = false
                }
            }
            else if customColorState == 1{
                customColorState = 0
                shouldCustomColorTutorial = false

                //turn off tutorial
                let realm = try! Realm()
                
                let shouldTutorial = realm.objects(ShouldTutorial.self)[0]
                
                try! realm.write{
                    shouldTutorial.shouldCustomColorTutorial = false
                }

                tutorialBlurView.isHidden = true
                moveOnButton.isHidden = true
                
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                    self.tutorialView.frame.origin.x = self.screenWidth
                    self.triangle.frame.origin.x = self.screenHeight
                }, completion: {_ in
                    self.tutorialView.isHidden = true
                    self.triangle.isHidden = true
                })
                
                //enable scroll
                self.presentationController?.presentedView?.gestureRecognizers?.forEach {
                    $0.isEnabled = true
                }
            }
            customColorState += 1
        }
    }

     //end keyboard if pressed
     @objc func dismissKeyboard(){
        nameTextField.endEditing(true)
        goalTextField.endEditing(true)
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
                     
                     //deselect previous cell
                     let previousCategory = tableView.cellForRow(at: [0,categoryNum]) as! NewTaskCategoryCell
                     previousCategory.checkMark.setOn(false, animated: true)

                     //haptic feedback
                     let selectionGenerator = UISelectionFeedbackGenerator()
                     selectionGenerator.selectionChanged()
                    
                     //no selected category
                     categoryNum = -1
                 }
                 
                 //no previous category selected
                 else if categoryNum < 0{
                     //selected category #
                     categoryNum = Int(locationPressed.y/tableViewRowHeight)

                     //haptic feedback
                     let selectionGenerator = UISelectionFeedbackGenerator()
                     selectionGenerator.selectionChanged()
                    
                     let categorySelected = tableView.cellForRow(at: [0,categoryNum]) as! NewTaskCategoryCell
                     categorySelected.checkMark.setOn(true, animated: true)
                 }
                
                //check if save should be enabled
                checkSave()
             }
         }
     }
     
     //tapped on collectionview(colorPicker)
     @objc func handleTapColorPicker(_ sender: UITapGestureRecognizer) {
         let locationPressed = sender.location(in: premadeColorCV)
         
         //if thing pressed is an actual cell
         if locationPressed.x.truncatingRemainder(dividingBy: cellSizeConstant + cellSpacing) <= cellSizeConstant && locationPressed.y.truncatingRemainder(dividingBy: cellSizeConstant + cellSpacing) <= cellSizeConstant{
             
             //deselect previous cell number if a previous cell number is chosen
             if cellNumber >= 0 && cellNumber != Int(locationPressed.y/(cellSizeConstant + cellSpacing)) * 6 + Int(locationPressed.x/(cellSizeConstant + cellSpacing)){

                var cell = premadeColorCV.cellForItem(at: [0,cellNumber]) as! ColorCell

                //deselect animation
                cell.checkMarkAnimation.setOn(false, animated: true)

                //new cell number chosen
                cellNumber = Int(locationPressed.y/(cellSizeConstant + cellSpacing)) * 6 + Int(locationPressed.x/(cellSizeConstant + cellSpacing))

                //animation selection
                cell = premadeColorCV.cellForItem(at: [0,cellNumber]) as! ColorCell

                //haptic feedback
                let selectionGenerator = UISelectionFeedbackGenerator()
                selectionGenerator.selectionChanged()

                //color chosen
                isColorChosen = true
                colorChosen = colorArray[cellNumber]

                //select animation
                cell.checkMarkAnimation.setOn(true, animated: true)
                 
             }
             
             //if same cellNumber chosen - deselection animation
             else if cellNumber >= 0 && cellNumber == Int(locationPressed.y/(cellSizeConstant + cellSpacing)) * 6 + Int(locationPressed.x/(cellSizeConstant + cellSpacing)){

                //animation selection
                let cell = premadeColorCV.cellForItem(at: [0,cellNumber]) as! ColorCell

                //color not chosen
                isColorChosen = false

                //haptic feedback
                let selectionGenerator = UISelectionFeedbackGenerator()
                selectionGenerator.selectionChanged()

                //deselect animation
                cell.checkMarkAnimation.setOn(false, animated: true)

                //no cell chosen
                cellNumber = -1
             }
             
             // if no previous cell chosen
             else if cellNumber < 0{

                //update cell chosen
                cellNumber = Int(locationPressed.y/(cellSizeConstant + cellSpacing)) * 6 + Int(locationPressed.x/(cellSizeConstant + cellSpacing))

                //animation selection
                let cell = premadeColorCV.cellForItem(at: [0,cellNumber]) as! ColorCell

                //haptic feedback
                let selectionGenerator = UISelectionFeedbackGenerator()
                selectionGenerator.selectionChanged()

                //color chosen
                isColorChosen = true
                colorChosen = colorArray[cellNumber]

                //select animation
                cell.checkMarkAnimation.setOn(true, animated: true)
             }

            //check if save should be enabled
            checkSave()
         }
     }
    
    //time pressed
    @IBAction func timeButtonPressed(_ sender: Any) {
        chosenRoutineType = .time
        
        //change label to "mins a day"
        goalLabel.text = "mins a day"

        //haptic feedback
        let selectionGenerator = UISelectionFeedbackGenerator()
        selectionGenerator.selectionChanged()
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.selectedView.frame.origin = self.timeButton.frame.origin
        }, completion: nil)
    }
    
    //amount button pressed
    @IBAction func amountButtonPressed(_ sender: Any) {
        chosenRoutineType = .amount
        
        //change label to "a day"
        goalLabel.text = "a day"

        //haptic feedback
        let selectionGenerator = UISelectionFeedbackGenerator()
        selectionGenerator.selectionChanged()
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.selectedView.frame.origin = self.amountButton.frame.origin
        }, completion: nil)
    }
    
    //check if text fields are empty
    @IBAction func nameTextFieldChanged(_ sender: Any) {
        if nameTextField.text != ""{
            isNameFilled = true
        }
        else{
            isNameFilled = false
        }
        
        checkSave()
    }
    @IBAction func goalTextFieldChanged(_ sender: Any) {
        if goalTextField.text != ""{
            isGoalFilled = true
        }
        else{
            isGoalFilled = false
        }
        
        checkSave()
    }
    
    //delete button pressed
    @IBAction func deleteButtonPressed(_ sender: Any) {
        //haptic feedback
        mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
        mediumGenerator?.prepare()
        mediumGenerator?.impactOccurred()
        mediumGenerator = nil
    }
    
    //save button pressed
    @IBAction func saveButtonPressed(_ sender: Any) {
        //haptic feedback
        mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
        mediumGenerator?.prepare()
        mediumGenerator?.impactOccurred()
        mediumGenerator = nil
    }
    
    //check save
    func checkSave(){
        if isNameFilled == true &&
            isGoalFilled == true &&
            isColorChosen == true{
            
            //save button is enabled + turns green
            saveButton.isUserInteractionEnabled = true
            
            //animation of green view
            UIView.animate(withDuration: 0.5, animations: {
                self.saveButton.backgroundColor = UIColor(hex: "5DD048")
            })
        }
            
        else{
            //save button is disabled + turns gray
            saveButton.isUserInteractionEnabled = false
            
            //animation of gray view
            UIView.animate(withDuration: 0.5, animations: {
                self.saveButton.backgroundColor = UIColor(hex: "C8C8C8")
            })
        }
    }
    
    //refresh routines
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SaveToRoutines"{
            let routineVC = segue.destination as! Routines

            //start realm
            let realm = try! Realm()
            
            //save function
            let routineRealm = Routine()
            
            //name
            routineRealm.name = nameTextField.text ?? ""
            
            //call category from realms
            let categoryRealm = realm.objects(Category.self)
            
            //category
            
            //if no category chosen
            routineRealm.categoryNum = categoryNum
            if categoryNum == -1{
                routineRealm.categoryNum = -1
            }
            else{
                routineRealm.categoryName = categoryRealm[categoryNum].name
            }
            
            //turn color into hsba
            let hsbaList = colorChosen.getHSBAComponents()
            
            //colors
            routineRealm.h = hsbaList.hue
            routineRealm.s = hsbaList.saturation
            routineRealm.b = hsbaList.brightness
            routineRealm.a = hsbaList.alpha
            
            //type of routine
            switch chosenRoutineType{
            case .time:
                routineRealm.type = "Time"
            
            case .amount:
                routineRealm.type = "Amount"
            }
            
            routineRealm.numCompleted = 0
            routineRealm.goal = Int(goalTextField.text ?? "0") ?? 0
            
            routineRealm.displayTime = 0
            
            try! realm.write {
                realm.add(routineRealm)
            }
            
            routineVC.alphaOfCells.append(1)
            
            let rowNum = realm.objects(Routine.self).count
            
            //update rowNum
            routineVC.rowNum = rowNum
            
            
            //reload data
            routineVC.tableView.reloadData()
        }
    }
    
    
    @IBAction func changeColor(_ sender: Any) {
        if premadeColorCV.isHidden == false{

            //haptic feedback
            mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
            mediumGenerator?.prepare()
            mediumGenerator?.impactOccurred()
            mediumGenerator = nil
            
            //hide colorpicker and make customcolor appear
            UIView.transition(with: premadeColorCV, duration: 0.4, options: .transitionCrossDissolve, animations: {
                self.premadeColorCV.isHidden = true
                self.customColor.isHidden = false
            }, completion: nil)
            
            //change custom color to chosen color if color picked
            if isColorChosen == true{
                customColor.color = colorChosen.cgColor
            }
            
            //deselect previous cell in colorPicker
            if cellNumber >= 0{
                let selectedCell = premadeColorCV.cellForItem(at: [0,cellNumber]) as! ColorCell
                selectedCell.checkMarkAnimation.setOn(false, animated: false)
                
                cellNumber = -1
            }
            
            //custom color
            customColorTutorialFunc()
            
            //chosen color is true
            isColorChosen = true
            
            customLabel.text = "PREMADE"
        }
            
        //custom color picker changed to normal color picker
        else{

            //haptic feedback
            mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
            mediumGenerator?.prepare()
            mediumGenerator?.impactOccurred()
            mediumGenerator = nil
            
            //hide customcolor and make colorpicker appear
            UIView.transition(with: customColor, duration: 0.4, options: .transitionCrossDissolve, animations: {
                self.customColor.isHidden = true
                self.premadeColorCV.isHidden = false
            }, completion: nil)
            
            //select if its a premade color, otherwise, don't
            if colorArray.contains(UIColor(cgColor: customColor.color)) == true{
                isColorChosen = true
                colorChosen = UIColor(cgColor: customColor.color)
                let indexOfColor = colorArray.firstIndex(of: colorChosen) ?? 0
                let cellOfColor = premadeColorCV.cellForItem(at: [0,indexOfColor]) as! ColorCell
                
                //select cell
                premadeColorCV.selectItem(at: [0,indexOfColor], animated: false, scrollPosition: .top)
                cellOfColor.checkMarkAnimation.setOn(true, animated: true)
                
                cellNumber = indexOfColor
            }
            else{
                isColorChosen = false
            }
            
            customLabel.text = "CUSTOM"
        }
        
        checkSave()
    }
}


extension NewRoutine: CircleColorPickerViewDelegate{
    func onColorChanged(newColor: CGColor) {
        //only happens if custom color picker is selected
        if customColor.isHidden == false{
            colorChosen = UIColor(cgColor: newColor)
            
            /*
            //prevent scrollview from interfering
            scrollView.isScrollEnabled = false

            self.presentationController?.presentedView?.gestureRecognizers?.forEach {
                $0.isEnabled = false
            }*/
            
            let selectionGenerator = UISelectionFeedbackGenerator()
            selectionGenerator.selectionChanged()
            
            isColorChosen = true
        }
    }
}

extension NewRoutine: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension NewRoutine: UITableViewDataSource, UITableViewDelegate{
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
            cell.seperator.frame = CGRect(x: 0, y: 42, width: 299, height: 2)
            cell.categoryName.frame = CGRect(x: 50, y: 9, width: 209, height: 26)
            cell.checkMark.frame = CGRect(x: 269, y: 9, width: 25, height: 25)
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
        else if screenWidth == 834 && screenHeight == 1194{
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
        else if screenWidth == 810 && screenHeight == 1080{
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

//setup collection view
extension NewRoutine: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

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

//text field
extension NewRoutine: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}
