//
//  CategoryPopup.swift
//  TimeKeep
//
//  Created by Mi Yan on 5/19/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift
import CircleColorPicker
import BEMCheckBox

protocol dismissPopup{
    func bringPopupUp()
    
    func showTutorial()
}

class CategoryPopup: UIViewController {
    
    
    @IBOutlet weak var categoryName: UITextField!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var customText: UILabel!
    @IBOutlet weak var colorPicker: UICollectionView!
    @IBOutlet weak var customColor: CircleColorPickerView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    
    @IBOutlet weak var seperatorView: UIView!
    
    @IBOutlet weak var customColorButton: UIButton!
    
    @IBOutlet weak var xButton: UIButton!
    
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var deleteIcon: UIImageView!

    //haptic feedback
    var generator = UISelectionFeedbackGenerator()
    var generatorExit : UIImpactFeedbackGenerator? = nil
    
    //delegate to dismiss popup
    var delegate: dismissPopup?
    
    //color array
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
    
    
    //save button
    @IBOutlet weak var saveButton: UIButton!
    
    //check if filled
    var isColorChosen: Bool! = false
    var isNamed: Bool! = false
    
    //if editings
    var isEditingPopup: Bool! = false
    var editingPopupIndexPath: Int! = 0
    
    //beginning color
    var categoryColor: UIColor! = UIColor(hue: 0, saturation: 1, brightness: 0.75, alpha: 1)
    
    //for resizing
    var screenHeight: CGFloat = 0
    var screenWidth: CGFloat = 0
    
    //cellspacing
    var cellSpacing: CGFloat = 4
    
    //color number
    var colorNum = -1
    
    //universal customcolor behavior
    @IBOutlet weak var customColorView: UIView!
    
    var tempTouches = Set<UITouch>()
    var tempEvent: UIEvent? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //custom color picker setup
        customColor.delegate = self

        //color picker setup
        colorPicker.delegate = self
        colorPicker.dataSource = self
        colorPicker.allowsMultipleSelection = false

        //text field setup
        categoryName.delegate = self

        //disable save button first and color save button gray
        saveButton.isUserInteractionEnabled = false
        saveButton.backgroundColor = UIColor(hex: "C8C8C8")
        
        let screen = UIScreen.main.bounds
        screenWidth = screen.size.width
        screenHeight = screen.size.height
        
        resizeDevice()
        
        //resize xButton to top left corner + make it circular
        xButton.center = popupView.frame.origin

        //set custom color to hidden and color picker to not hidden
        customColor.isHidden = true
        customColorView.isHidden = true
        colorPicker.isHidden = false
        
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap.minimumPressDuration = 0.15
        customColorView.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UILongPressGestureRecognizer? = nil) {
        // handling code
        if sender!.state == .began{
            customColor.touchesBegan(tempTouches, with: tempEvent)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //setup custom color picker knobs
        customColor.setupMaskImages(image: UIImage(named: "transparentCircle"))
        
        //auto select red - first cell
        colorNum = 0
        
        let tempCell = colorPicker.cellForItem(at: IndexPath(row: colorNum, section: 0)) as! ColorCell
        
        tempCell.checkMarkAnimation.setOn(true, animated: true)
        
        colorPicker.selectItem(at: IndexPath(row: colorNum, section: 0), animated: false, scrollPosition: .centeredHorizontally)
        
        categoryColor = colorArray[colorNum]
        
        isColorChosen = true
        
        //set customColor Picker Color
        customColor.color = categoryColor.cgColor
    }
    
    //reszie
    func resizeDevice(){
        if screenWidth == 375 && screenHeight == 812{
            popupView.frame = CGRect(x: 42.5, y: 55.5, width: 290, height: 489)
            
            nameLabel.font = nameLabel.font.withSize(20)
            nameLabel.frame = CGRect(x: 15, y: 15, width: 69, height: 26)
            
            categoryName.frame = CGRect(x: 92, y: 15, width: 183, height: 26)
            categoryName.font = categoryName.font?.withSize(20)
            
            seperatorView.frame = CGRect(x: 0, y: 56, width: 290, height: 2)
            
            colorLabel.font = colorLabel.font.withSize(20)
            colorLabel.frame = CGRect(x: 15, y: 73, width: 77, height: 26)
            
            customColor.frame = CGRect(x: 15, y: 109, width: 260, height: 260)
            colorPicker.frame = CGRect(x: 15, y: 109, width: 260, height: 260)
            
            customColorButton.frame = CGRect(x: 61, y: 373, width: 168, height: 33)
            customText.frame = CGRect(x: 101, y: 376, width: 88, height: 27)
            
            saveButton.titleLabel?.font = saveButton.titleLabel?.font.withSize(30)
            saveButton.frame = CGRect(x: 15, y: 416, width: 196, height: 58)
            
            deleteView.frame = CGRect(x: 226, y: 416, width: 49, height: 58)
            deleteButton.frame = CGRect(x: 0, y: 0, width: 49, height: 58)
            deleteIcon.frame = CGRect(x: 8, y: 10, width: 33, height: 38)
        }
        else if screenWidth == 375 && screenHeight == 667{
            popupView.frame = CGRect(x: 42.5, y: 55.5, width: 290, height: 489)
            
            nameLabel.font = nameLabel.font.withSize(20)
            nameLabel.frame = CGRect(x: 15, y: 15, width: 69, height: 26)
            
            categoryName.frame = CGRect(x: 92, y: 15, width: 183, height: 26)
            categoryName.font = categoryName.font?.withSize(20)
            
            seperatorView.frame = CGRect(x: 0, y: 56, width: 290, height: 2)
            
            colorLabel.font = colorLabel.font.withSize(20)
            colorLabel.frame = CGRect(x: 15, y: 73, width: 77, height: 26)
            
            customColor.frame = CGRect(x: 15, y: 109, width: 260, height: 260)
            colorPicker.frame = CGRect(x: 15, y: 109, width: 260, height: 260)
            
            customColorButton.frame = CGRect(x: 61, y: 373, width: 168, height: 33)
            customText.frame = CGRect(x: 101, y: 376, width: 88, height: 27)
            
            saveButton.titleLabel?.font = saveButton.titleLabel?.font.withSize(30)
            saveButton.frame = CGRect(x: 15, y: 416, width: 196, height: 58)
            
            deleteView.frame = CGRect(x: 226, y: 416, width: 49, height: 58)
            deleteButton.frame = CGRect(x: 0, y: 0, width: 49, height: 58)
            deleteIcon.frame = CGRect(x: 8, y: 10, width: 33, height: 38)
        }
        else if screenWidth == 320 && screenHeight == 568{
            popupView.frame = CGRect(x: 30, y: 51, width: 260, height: 449)
            
            nameLabel.font = nameLabel.font.withSize(15)
            nameLabel.frame = CGRect(x: 15, y: 15, width: 52, height: 20)
            
            categoryName.frame = CGRect(x: 72, y: 15, width: 173, height: 20)
            categoryName.font = categoryName.font?.withSize(15)
            
            seperatorView.frame = CGRect(x: 0, y: 50, width: 260, height: 2)
            
            colorLabel.font = colorLabel.font.withSize(15)
            colorLabel.frame = CGRect(x: 15, y: 67, width: 58, height: 20)
            
            customColor.frame = CGRect(x: 15, y: 102, width: 230, height: 230)
            colorPicker.frame = CGRect(x: 15, y: 102, width: 230, height: 230)
            
            customColorButton.frame = CGRect(x: 55, y: 347, width: 150, height: 27)
            
            customText.font = customText.font.withSize(12)
            customText.frame = CGRect(x: 86, y: 350, width: 88, height: 21)
            
            saveButton.titleLabel?.font = saveButton.titleLabel?.font.withSize(28)
            saveButton.frame = CGRect(x: 15, y: 386, width: 166, height: 48)
            
            deleteView.frame = CGRect(x: 196, y: 386, width: 49, height: 48)
            deleteButton.frame = CGRect(x: 0, y: 0, width: 49, height: 48)
            deleteIcon.frame = CGRect(x: 11, y: 9, width: 27, height: 30)
        }
        else if screenWidth == 768 && screenHeight == 1024{
            popupView.frame = CGRect(x: 114, y: 94, width: 540, height: 836)
            
            nameLabel.font = nameLabel.font.withSize(25)
            nameLabel.frame = CGRect(x: 15, y: 18, width: 86, height: 33)
            
            categoryName.frame = CGRect(x: 109, y: 18, width: 416, height: 33)
            categoryName.font = categoryName.font?.withSize(25)
            
            seperatorView.frame = CGRect(x: 0, y: 66, width: 540, height: 2)
            
            colorLabel.font = colorLabel.font.withSize(25)
            colorLabel.frame = CGRect(x: 15, y: 83, width: 96, height: 33)
            
            customColor.frame = CGRect(x: 15, y: 130, width: 510, height: 510)
            colorPicker.frame = CGRect(x: 15, y: 130, width: 510, height: 510)
            
            customColorButton.frame = CGRect(x: 130, y: 655, width: 280, height: 52)
            
            customText.font = customText.font.withSize(20)
            customText.frame = CGRect(x: 198, y: 668, width: 144, height: 26)
            
            saveButton.titleLabel?.font = saveButton.titleLabel?.font.withSize(50)
            saveButton.frame = CGRect(x: 16, y: 722, width: 386, height: 93)
            
            deleteView.frame = CGRect(x: 417, y: 722, width: 108, height: 93)
            deleteButton.frame = CGRect(x: 0, y: 0, width: 108, height: 93)
            deleteIcon.frame = CGRect(x: 25, y: 13, width: 58, height: 66)
            
            xButton.frame = CGRect(x: -27.5, y: -27.5, width: 55, height: 55)
        }
        else if screenWidth == 834 && screenHeight == 1194{
            popupView.frame = CGRect(x: 147, y: 179, width: 540, height: 836)
            
            nameLabel.font = nameLabel.font.withSize(25)
            nameLabel.frame = CGRect(x: 15, y: 18, width: 86, height: 33)
            
            categoryName.frame = CGRect(x: 109, y: 18, width: 416, height: 33)
            categoryName.font = categoryName.font?.withSize(25)
            
            seperatorView.frame = CGRect(x: 0, y: 66, width: 540, height: 2)
            
            colorLabel.font = colorLabel.font.withSize(25)
            colorLabel.frame = CGRect(x: 15, y: 83, width: 96, height: 33)
            
            customColor.frame = CGRect(x: 15, y: 130, width: 510, height: 510)
            colorPicker.frame = CGRect(x: 15, y: 130, width: 510, height: 510)
            
            customColorButton.frame = CGRect(x: 130, y: 655, width: 280, height: 52)
            
            customText.font = customText.font.withSize(20)
            customText.frame = CGRect(x: 198, y: 668, width: 144, height: 26)
            
            saveButton.titleLabel?.font = saveButton.titleLabel?.font.withSize(50)
            saveButton.frame = CGRect(x: 16, y: 722, width: 386, height: 93)
            
            deleteView.frame = CGRect(x: 417, y: 722, width: 108, height: 93)
            deleteButton.frame = CGRect(x: 0, y: 0, width: 108, height: 93)
            deleteIcon.frame = CGRect(x: 25, y: 13, width: 58, height: 66)
            
            xButton.frame = CGRect(x: -27.5, y: -27.5, width: 55, height: 55)
        }
        else if screenWidth == 834 && screenHeight == 1112{
            popupView.frame = CGRect(x: 147, y: 138, width: 540, height: 836)
            
            nameLabel.font = nameLabel.font.withSize(25)
            nameLabel.frame = CGRect(x: 15, y: 18, width: 86, height: 33)
            
            categoryName.frame = CGRect(x: 109, y: 18, width: 416, height: 33)
            categoryName.font = categoryName.font?.withSize(25)
            
            seperatorView.frame = CGRect(x: 0, y: 66, width: 540, height: 2)
            
            colorLabel.font = colorLabel.font.withSize(25)
            colorLabel.frame = CGRect(x: 15, y: 83, width: 96, height: 33)
            
            customColor.frame = CGRect(x: 15, y: 130, width: 510, height: 510)
            colorPicker.frame = CGRect(x: 15, y: 130, width: 510, height: 510)
            
            customColorButton.frame = CGRect(x: 130, y: 655, width: 280, height: 52)
            
            customText.font = customText.font.withSize(20)
            customText.frame = CGRect(x: 198, y: 668, width: 144, height: 26)
            
            saveButton.titleLabel?.font = saveButton.titleLabel?.font.withSize(50)
            saveButton.frame = CGRect(x: 16, y: 722, width: 386, height: 93)
            
            deleteView.frame = CGRect(x: 417, y: 722, width: 108, height: 93)
            deleteButton.frame = CGRect(x: 0, y: 0, width: 108, height: 93)
            deleteIcon.frame = CGRect(x: 25, y: 13, width: 58, height: 66)
            
            xButton.frame = CGRect(x: -27.5, y: -27.5, width: 55, height: 55)
        }
        else if screenWidth == 810 && screenHeight == 1080{
            popupView.frame = CGRect(x: 135, y: 122, width: 540, height: 836)
            
            nameLabel.font = nameLabel.font.withSize(25)
            nameLabel.frame = CGRect(x: 15, y: 18, width: 86, height: 33)
            
            categoryName.frame = CGRect(x: 109, y: 18, width: 416, height: 33)
            categoryName.font = categoryName.font?.withSize(25)
            
            seperatorView.frame = CGRect(x: 0, y: 66, width: 540, height: 2)
            
            colorLabel.font = colorLabel.font.withSize(25)
            colorLabel.frame = CGRect(x: 15, y: 83, width: 96, height: 33)
            
            customColor.frame = CGRect(x: 15, y: 130, width: 510, height: 510)
            colorPicker.frame = CGRect(x: 15, y: 130, width: 510, height: 510)
            
            customColorButton.frame = CGRect(x: 130, y: 655, width: 280, height: 52)
            
            customText.font = customText.font.withSize(20)
            customText.frame = CGRect(x: 198, y: 668, width: 144, height: 26)
            
            saveButton.titleLabel?.font = saveButton.titleLabel?.font.withSize(50)
            saveButton.frame = CGRect(x: 16, y: 722, width: 386, height: 93)
            
            deleteView.frame = CGRect(x: 417, y: 722, width: 108, height: 93)
            deleteButton.frame = CGRect(x: 0, y: 0, width: 108, height: 93)
            deleteIcon.frame = CGRect(x: 25, y: 13, width: 58, height: 66)
            
            xButton.frame = CGRect(x: -27.5, y: -27.5, width: 55, height: 55)
        }
        else if screenWidth == 1024 && screenHeight == 1366{
            popupView.frame = CGRect(x: 162, y: 187, width: 700, height: 991)
            
            nameLabel.font = nameLabel.font.withSize(30)
            nameLabel.frame = CGRect(x: 20, y: 20, width: 103, height: 39)
            
            categoryName.frame = CGRect(x: 133, y: 20, width: 547, height: 39)
            categoryName.font = categoryName.font?.withSize(30)
            
            seperatorView.frame = CGRect(x: 0, y: 79, width: 700, height: 2)
            
            colorLabel.font = colorLabel.font.withSize(30)
            colorLabel.frame = CGRect(x: 20, y: 101, width: 115, height: 39)
            
            customColor.frame = CGRect(x: 50, y: 160, width: 600, height: 600)
            colorPicker.frame = CGRect(x: 50, y: 160, width: 600, height: 600)
            
            customColorButton.frame = CGRect(x: 184, y: 780, width: 332, height: 61)
            
            customText.font = customText.font.withSize(25)
            customText.frame = CGRect(x: 184, y: 780, width: 332, height: 61)
            
            saveButton.titleLabel?.font = saveButton.titleLabel?.font.withSize(70)
            saveButton.frame = CGRect(x: 16, y: 861, width: 500, height: 110)
            
            deleteView.frame = CGRect(x: 536, y: 861, width: 144, height: 110)
            deleteButton.frame = CGRect(x: 0, y: 0, width: 144, height: 110)
            deleteIcon.frame = CGRect(x: 35, y: 13, width: 74, height: 84)
            
            xButton.frame = CGRect(x: -30, y: -30, width: 60, height: 60)
            
            cellSpacing = 12
        }
        
        //universal resizing
        customColorView.frame = customColor.frame
    }
    
    //setup if editing
    func editPopup(){
        let realm = try! Realm()
        
        let categoryRealm = realm.objects(Category.self)
        
        let categoryItem = categoryRealm[editingPopupIndexPath]
        
        categoryName.text = categoryItem.name
        
        let categoryColorTemp = UIColor(hue: CGFloat(categoryItem.h), saturation: CGFloat(categoryItem.s), brightness: CGFloat(categoryItem.b), alpha: CGFloat(categoryItem.a))
        
        //make it a custom color
        categoryColor = categoryColorTemp
        
        //enable custom and disable premade
        customColor.color = categoryColor.cgColor
        
        //if premade color
        if categoryItem.colorNum >= 0{
            //deselect selected colors
            if (colorPicker.indexPathsForSelectedItems ?? []) != []{
                //deselect cell
                let colorCell = colorPicker.cellForItem(at: colorPicker.indexPathsForSelectedItems![0]) as! ColorCell
                colorCell.checkMarkAnimation.setOn(false, animated: false)
                
                
                colorPicker.deselectItem(at: colorPicker.indexPathsForSelectedItems![0], animated: false)
            }
            
            colorNum = categoryItem.colorNum
            
            let tempCell = colorPicker.cellForItem(at: IndexPath(row: colorNum, section: 0)) as! ColorCell
            
            tempCell.checkMarkAnimation.setOn(true, animated: true)
            
            colorPicker.selectItem(at: IndexPath(row: colorNum, section: 0), animated: false, scrollPosition: .centeredHorizontally)
            
            self.colorPicker.isHidden = false
            self.customColor.isHidden = true
            self.customColorView.isHidden = true
        }
        else{
            self.colorPicker.isHidden = true
            self.customColor.isHidden = false
            self.customColorView.isHidden = false
        }
        
        //can save
        isColorChosen = true
        isNamed = true
        checkSave()
    }
    
    @IBAction func changeColor(_ sender: Any) {
        if colorPicker.isHidden == false{
            
            //hide colorpicker and make customcolor appear
            UIView.transition(with: colorPicker, duration: 0.4, options: .transitionCrossDissolve, animations: {
                self.colorPicker.isHidden = true
                self.customColor.isHidden = false
                self.customColorView.isHidden = false
            }, completion: nil)
            
            //change custom color to chosen color if color picked
            if isColorChosen == true{
                let tempcGColor = categoryColor.cgColor
                //customColor.color = tempcGColor
            }
            
            //deselect previous cell in colorPicker
            if (colorPicker.indexPathsForSelectedItems ?? []) != []{
                let selectedIndexPath = colorPicker.indexPathsForSelectedItems![0]
                colorPicker.deselectItem(at: selectedIndexPath, animated: false)
                
                let selectedCell = colorPicker.cellForItem(at: selectedIndexPath) as! ColorCell
                selectedCell.checkMarkAnimation.setOn(false, animated: false)
            }
            
            //should do delegate tutorial?
            delegate?.showTutorial()
            
            //chosen color is true
            isColorChosen = true

            //haptic feedback
            generatorExit = UIImpactFeedbackGenerator(style: .medium)
            generatorExit?.prepare()
            generatorExit?.impactOccurred()
            generatorExit = nil
            
            customText.text = "PREMADE"
        }
            
        //custom color picker changed to normal color picker
        else{
            
            //hide customcolor and make colorpicker appear
            UIView.transition(with: customColor, duration: 0.4, options: .transitionCrossDissolve, animations: {
                self.customColor.isHidden = true
                self.customColorView.isHidden = true
                self.colorPicker.isHidden = false
            }, completion: nil)
            
            //select if its a premade color, otherwise, don't
            if colorArray.contains(UIColor(cgColor: customColor.color)) == true{
                isColorChosen = true
                categoryColor = UIColor(cgColor: customColor.color)
                let indexOfColor = colorArray.firstIndex(of: categoryColor) ?? 0
                let cellOfColor = colorPicker.cellForItem(at: [0,indexOfColor]) as! ColorCell
                
                //select cell
                colorPicker.selectItem(at: [0,indexOfColor], animated: false, scrollPosition: .top)
                cellOfColor.checkMarkAnimation.setOn(true, animated: true)
            }
            else{
                isColorChosen = false
            }
            
            //haptic feedback
            generatorExit = UIImpactFeedbackGenerator(style: .medium)
            generatorExit?.prepare()
            generatorExit?.impactOccurred()
            generatorExit = nil
            
            customText.text = "CUSTOM"
        }
        
        checkSave()
    }
    
    //save category
    @IBAction func saveButtonPressed(_ sender: Any) {
        //if actually adding in a category
        if isEditingPopup == false{
            //save function
            var newCategory = Category()
            
            newCategory.name = categoryName.text ?? ""
            let hsbaList = categoryColor.getHSBAComponents()
            newCategory.h = hsbaList.hue
            newCategory.s = hsbaList.saturation
            newCategory.b = hsbaList.brightness
            newCategory.a = hsbaList.alpha
            
            //add colorNum if not using a customColor
            if customColor.isHidden == true{
                newCategory.colorNum = colorNum
            }
            
            //start realm
            let realm = try! Realm()
            
            try! realm.write {
                realm.add(newCategory)
            }
        }
            
        //if editing a category
        else{
            
            //start realm
            let realm = try! Realm()
            
            //call category from realms
            let categoryRealm = realm.objects(Category.self)
            
            let hsbaList = categoryColor.getHSBAComponents()
            
            try! realm.write{
                categoryRealm[editingPopupIndexPath].name = categoryName.text!
                categoryRealm[editingPopupIndexPath].h = hsbaList.hue
                categoryRealm[editingPopupIndexPath].s = hsbaList.saturation
                categoryRealm[editingPopupIndexPath].b = hsbaList.brightness
                categoryRealm[editingPopupIndexPath].a = hsbaList.alpha

                //add colorNum if not using a customColor
                if customColor.isHidden == true{
                    categoryRealm[editingPopupIndexPath].colorNum = colorNum
                }
            }
            
            //change tasks and routine names if name changed
            let plannerSelectedCategoryRealms = realm.objects(TaskSaved.self).filter("category == %@", editingPopupIndexPath)
            
            for task in plannerSelectedCategoryRealms{
                try! realm.write{
                    task.categoryName = categoryName.text ?? ""
                }
            }
            
            let routineSelectedCategoryRealms = realm.objects(Routine.self).filter("categoryNum == %@", editingPopupIndexPath)
            
            for routine in routineSelectedCategoryRealms{
                try! realm.write{
                    routine.categoryName = categoryName.text ?? ""
                }
            }
        }
        
        generatorExit = UIImpactFeedbackGenerator(style: .medium)
        generatorExit?.prepare()
        generatorExit?.impactOccurred()
        generatorExit = nil
        
        resetPopup()
        
        //dismiss popup
        delegate?.bringPopupUp()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        resetPopup()
        
        //haptic feedback
        generatorExit = UIImpactFeedbackGenerator(style: .medium)
        generatorExit?.prepare()
        generatorExit?.impactOccurred()
        generatorExit = nil
        
        //dismiss popup
        delegate?.bringPopupUp()
        
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        //if not editing - just cancel
        if isEditingPopup == false{
            resetPopup()
            
            //dismiss popup
            delegate?.bringPopupUp()
        }
        
        generatorExit = UIImpactFeedbackGenerator(style: .medium)
        generatorExit?.prepare()
        generatorExit?.impactOccurred()
        generatorExit = nil
    }
    
    //reset categoryview
    func resetPopup(){
        
        //deselect selected colors
        if (colorPicker.indexPathsForSelectedItems ?? []) != []{
            //deselect cell
            let colorCell = colorPicker.cellForItem(at: colorPicker.indexPathsForSelectedItems![0]) as! ColorCell
            colorCell.checkMarkAnimation.setOn(false, animated: false)
            
            
            colorPicker.deselectItem(at: colorPicker.indexPathsForSelectedItems![0], animated: false)
        }
        
        //reset text field + colors
        categoryName.text = ""
        customText.text = "CUSTOM"
        customColor.isHidden = true
        customColorView.isHidden = true
        colorPicker.isHidden = false
        isColorChosen = false
        customColor.color = UIColor(hue: 0, saturation: 1, brightness: 0.75, alpha: 1).cgColor
        
        //reset save button
        saveButton.isUserInteractionEnabled = false
        saveButton.backgroundColor = UIColor(hex: "C8C8C8")
        
        //no longer editing
        isEditingPopup = false
    }
    
    
    //see if the save button should be enabled or not
    func checkSave(){
        
        //enable save button
        if isNamed == true && isColorChosen == true{
            saveButton.isUserInteractionEnabled = true
            saveButton.backgroundColor = UIColor(hex: "5DD048")
        }
        
        //disable save button
        else{
            saveButton.isUserInteractionEnabled = false
            saveButton.backgroundColor = UIColor(hex: "C8C8C8")
        }
    }
    
    //check if empty
    @IBAction func textFieldChanged(_ sender: Any) {
        
        //if textfield not empty it is named
        if categoryName.text != ""{
            isNamed = true
        }
        else{
            isNamed = false
        }
        
        checkSave()
    }
    
    //textfield if touched or pressed enter end editing
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tempTouches = touches
        tempEvent = event
        //customColor.touchesBegan(touches, with: event)
        categoryName.endEditing(true)
    }
}

//textfield
extension CategoryPopup: UITextFieldDelegate{
    //end textfield if return pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
}

var colorModified: Bool = false

//if color changed
extension CategoryPopup: CircleColorPickerViewDelegate{
    
    func onColorChanged(newColor: CGColor) {
        
        if customColor.isHidden == false{
            categoryColor = UIColor(cgColor: newColor)
            isColorChosen = true
            
            let selectionGenerator = UISelectionFeedbackGenerator()
            selectionGenerator.selectionChanged()
        }
        
    }
}

//setup collection view
extension CategoryPopup: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
        //collectionview size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if screenWidth == 375 && screenHeight == 812{
            return CGSize(width: 40, height: 40)
        }
        else if screenWidth == 375 && screenHeight == 667{
            return CGSize(width: 40, height: 40)
        }
        else if screenWidth == 320 && screenHeight == 568{
            return CGSize(width: 35, height: 35)
        }
        else if screenWidth == 768 && screenHeight == 1024{
            return CGSize(width: 80, height: 80)
        }
        else if screenWidth == 834 && screenHeight == 1194{
            return CGSize(width: 80, height: 80)
        }
        else if screenWidth == 834 && screenHeight == 1112{
            return CGSize(width: 80, height: 80)
        }
        else if screenWidth == 810 && screenHeight == 1080{
            return CGSize(width: 80, height: 80)
        }
        else if screenWidth == 1024 && screenHeight == 1366{
            return CGSize(width: 90, height: 90)
        }
        return CGSize(width: 50, height: 50)
    }

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
        cell.checkMarkAnimation.onCheckColor = .white
        cell.checkMarkAnimation.onTintColor = .white
    
        if screenWidth == 375 && screenHeight == 812{
            cell.checkMarkAnimation.center = CGPoint(x: 20, y: 20)
        }
        else if screenWidth == 375 && screenHeight == 667{
            cell.checkMarkAnimation.center = CGPoint(x: 20, y: 20)
        }
        else if screenWidth == 320 && screenHeight == 568{
            cell.checkMarkAnimation.frame.size = CGSize(width: 20, height: 20)
            cell.checkMarkAnimation.center = CGPoint(x: 35/2, y: 35/2)
        }
        else if screenWidth == 768 && screenHeight == 1024{
            cell.checkMarkAnimation.frame.size = CGSize(width: 60, height: 60)
            cell.checkMarkAnimation.center = CGPoint(x: 40, y: 40)
        }
        else if screenWidth == 834 && screenHeight == 1194{
            cell.checkMarkAnimation.frame.size = CGSize(width: 60, height: 60)
            cell.checkMarkAnimation.center = CGPoint(x: 40, y: 40)
        }
        else if screenWidth == 834 && screenHeight == 1112{
            cell.checkMarkAnimation.frame.size = CGSize(width: 60, height: 60)
            cell.checkMarkAnimation.center = CGPoint(x: 40, y: 40)
        }
        else if screenWidth == 810 && screenHeight == 1080{
            cell.checkMarkAnimation.frame.size = CGSize(width: 60, height: 60)
            cell.checkMarkAnimation.center = CGPoint(x: 40, y: 40)
        }
        else if screenWidth == 1024 && screenHeight == 1366{
            cell.checkMarkAnimation.frame.size = CGSize(width: 60, height: 60)
            cell.checkMarkAnimation.center = CGPoint(x: 45, y: 45)
        }
    
        return cell
   }

    //selection animation
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ColorCell
        
        //color is chosen
        isColorChosen = true
        
        //new color
        categoryColor = colorArray[indexPath.item]
        customColor.color = colorArray[indexPath.item].cgColor
        
        generator.selectionChanged()
        
        //select animation
        cell.checkMarkAnimation.setOn(true, animated: true)

        checkSave()
        
        colorNum = indexPath.item
    }
   
    //if tapped twice deselect
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let cell = collectionView.cellForItem(at: indexPath) as! ColorCell
        if cell.isSelected == true{
            //select animation
            cell.checkMarkAnimation.setOn(false, animated: true)

            //reset
            isColorChosen = false
            checkSave()
            
            //deselect cell
            collectionView.deselectItem(at: indexPath, animated: false)

            return false
        }
        return true
    }
   
   func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
       
       let cell = collectionView.cellForItem(at: indexPath) as! ColorCell
    
       //select animation
       cell.checkMarkAnimation.setOn(false, animated: true)
    }
}
