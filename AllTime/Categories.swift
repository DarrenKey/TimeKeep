//
//  Categories.swift
//  TimeKeep
//
//  Created by Mi Yan on 4/11/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//

import UIKit
import AVFoundation
import RealmSwift

//vibration whenever press button
extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}

protocol bringCategoryPopup{
    func bringPopup()
    func editPopup(path: Int)
}

class Categories: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var categoriesLabel: UILabel!
    
    //set categorylabel to label height
    var tempHeight: CGFloat! = 0
    
    //delegate to bring down popup
    var delegate: bringCategoryPopup?
    
    @IBOutlet weak var addNewCategoryButton: UIButton!
    
    //screenheight + screenwidth for resize
    var screenHeight: CGFloat = 0
    var screenWidth: CGFloat = 0
    
    //impact generator haptic
    var generator: UIImpactFeedbackGenerator? = nil
    
    @IBAction func addNewCategoryPressed(_ sender: Any) {
        delegate?.bringPopup()
        
        generator = UIImpactFeedbackGenerator(style: .medium)
        generator?.prepare()
        generator?.impactOccurred()
        generator = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableview setup
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true
        
        let screen = UIScreen.main.bounds
        screenWidth = screen.size.width
        screenHeight = screen.size.height
        
        resizeDevice()
    }
    
    //manually resize
    func resizeDevice(){
        if screenWidth == 375 && screenHeight == 812{
            tableView.frame = CGRect(x: 0, y: 156, width: 375, height: 474)
            categoriesLabel.font = categoriesLabel.font.withSize(35)
            categoriesLabel.frame = CGRect(x: 24, y: 77, width: 219, height: 46)
            
            addNewCategoryButton.frame = CGRect(x: 45, y: 653, width: 285, height: 46)
            addNewCategoryButton.titleLabel?.font = addNewCategoryButton.titleLabel?.font.withSize(25)
            
        }
        else if screenWidth == 375 && screenHeight == 667{
            categoriesLabel.font = categoriesLabel.font.withSize(35)
            categoriesLabel.frame = CGRect(x: 24, y: 50, width: 219, height: 46)
            
            tableView.frame.origin.y = 126
            tableView.frame.size.height = 408
            
            addNewCategoryButton.titleLabel?.font = addNewCategoryButton.titleLabel?.font.withSize(20)
            addNewCategoryButton.frame = CGRect(x: 74, y: 551, width: 227, height: 38)
        }
        else if screenWidth == 414 && screenHeight == 736{
            categoriesLabel.frame = CGRect(x: 24, y: 50, width: 250, height: 52)
            tableView.frame.origin.y = 132
            tableView.frame.size.height = 454
            
            addNewCategoryButton.frame = CGRect(x: 65, y: 606, width: 284, height: 40)
            addNewCategoryButton.titleLabel?.font = addNewCategoryButton.titleLabel?.font.withSize(20)
        }
        else if screenWidth == 320 && screenHeight == 568{
            categoriesLabel.font = categoriesLabel.font.withSize(30)
            categoriesLabel.frame = CGRect(x: 24, y: 40, width: 188, height: 39)
            
            tableView.frame = CGRect(x: 0, y: 99, width: 320, height: 355)
            
            addNewCategoryButton.titleLabel?.font = addNewCategoryButton.titleLabel?.font.withSize(18)
            
            addNewCategoryButton.frame = CGRect(x: 50, y: 465, width: 220, height: 31)
        }
        else if screenWidth == 768 && screenHeight == 1024{
            categoriesLabel.font = categoriesLabel.font.withSize(50)
            categoriesLabel.frame = CGRect(x: 24, y: 60, width: 313, height: 65)
            
            tableView.frame = CGRect(x: 0, y: 165, width: 768, height: 654)
            
            addNewCategoryButton.titleLabel?.font = addNewCategoryButton.titleLabel?.font.withSize(35)
            
            addNewCategoryButton.frame = CGRect(x: 171, y: 837, width: 426, height: 69)
        }
        else if screenWidth == 834 && screenHeight == 1194{
            categoriesLabel.font = categoriesLabel.font.withSize(65)
            categoriesLabel.frame = CGRect(x: 24, y: 50, width: 407, height: 85)
            
            tableView.frame = CGRect(x: 0, y: 165, width: 834, height: 746)
            
            addNewCategoryButton.titleLabel?.font = addNewCategoryButton.titleLabel?.font.withSize(45)
            
            addNewCategoryButton.frame = CGRect(x: 162, y: 945, width: 510, height: 85)
        }
        else if screenWidth == 834 && screenHeight == 1112{
            categoriesLabel.font = categoriesLabel.font.withSize(65)
            categoriesLabel.frame = CGRect(x: 24, y: 50, width: 407, height: 85)
            
            tableView.frame = CGRect(x: 0, y: 165, width: 834, height: 696)
            
            addNewCategoryButton.titleLabel?.font = addNewCategoryButton.titleLabel?.font.withSize(45)
            
            addNewCategoryButton.frame = CGRect(x: 162, y: 889, width: 510, height: 85)
        }
        else if screenWidth == 810 && screenHeight == 1080{
            categoriesLabel.font = categoriesLabel.font.withSize(65)
            categoriesLabel.frame = CGRect(x: 24, y: 50, width: 407, height: 85)
            
            tableView.frame = CGRect(x: 0, y: 165, width: 810, height: 696)
            
            addNewCategoryButton.titleLabel?.font = addNewCategoryButton.titleLabel?.font.withSize(35)
            
            addNewCategoryButton.frame = CGRect(x: 192, y: 881, width: 426, height: 69)
        }
        else if screenWidth == 1024 && screenHeight == 1366{
            categoriesLabel.font = categoriesLabel.font.withSize(75)
            categoriesLabel.frame = CGRect(x: 24, y: 60, width: 469, height: 98)
            
            tableView.frame = CGRect(x: 0, y: 198, width: 1024, height: 886)
            
            addNewCategoryButton.titleLabel?.font = addNewCategoryButton.titleLabel?.font.withSize(45)
            
            addNewCategoryButton.frame = CGRect(x: 251, y: 1116, width: 522, height: 80)
        }
    }
    
    //resize cell
    func resizeCell(cell: CategoryCell){
        if screenWidth == 375 && screenHeight == 812{
            cell.colorView.frame.size.width = 40
            cell.mainView.frame.size.width = screenWidth
            cell.categoryName.font = cell.categoryName.font.withSize(35)
            
            cell.wobbleView.frame = CGRect(x: 375, y: 0, width: 60, height: 58)
            cell.deleteButton.frame = CGRect(x: 0, y: 0, width: 60, height: 58)
            
            cell.trashCanIcon.frame.size = CGSize(width: 33, height: 40)
        }
        else if screenWidth == 414 && screenHeight == 736{
            cell.colorView.frame = CGRect(x: 0, y: 0, width: 40, height: 57)
            cell.mainView.frame.size.width = screenWidth
            cell.categoryName.font = cell.categoryName.font.withSize(34)
            
            cell.wobbleView.frame = CGRect(x: 414, y: 0, width: 70, height: 55)
            cell.deleteButton.frame = CGRect(x: 0, y: 0, width: 70, height: 55)
            
            cell.trashCanIcon.frame.size = CGSize(width: 40, height: 45)
        }
        else if screenWidth == 375 && screenHeight == 667{
            cell.categoryName.font = cell.categoryName.font.withSize(35)
            
            cell.mainView.frame = CGRect(x: 0, y: 0, width: 375, height: 58)
            
            cell.colorView.frame = CGRect(x: 0, y: 0, width: 40, height: 58)
            
            cell.seperator.frame = CGRect(x: 0, y: 57, width: 375, height: 1)
            
            cell.wobbleView.frame = CGRect(x: 375, y: 0, width: 60, height: 58)
            cell.deleteButton.frame = CGRect(x: 0, y: 0, width: 60, height: 58)
            
            cell.trashCanIcon.frame.size = CGSize(width: 33, height: 40)
        }
        else if screenWidth == 320 && screenHeight == 568{
            cell.categoryName.font = cell.categoryName.font.withSize(30)
            
            cell.mainView.frame = CGRect(x: 0, y: 0, width: 320, height: 51)
            
            cell.colorView.frame = CGRect(x: 0, y: 0, width: 30, height: 51)
            
            cell.seperator.frame = CGRect(x: 0, y: 50, width: 320, height: 1)
            
            cell.wobbleView.frame = CGRect(x: 320, y: 0, width: 50, height: 51)
            
            cell.deleteButton.frame = CGRect(x: 0, y: 0, width: 50, height: 51)
            
            cell.trashCanIcon.frame.size = CGSize(width: 34, height: 39)
        }
        else if screenWidth == 768 && screenHeight == 1024{
            cell.categoryName.font = cell.categoryName.font.withSize(52)
            
            cell.mainView.frame = CGRect(x: 0, y: 0, width: 768, height: 82)
            
            cell.colorView.frame = CGRect(x: 0, y: 0, width: 70, height: 82)
            
            cell.seperator.frame = CGRect(x: 0, y: 80, width: 768, height: 2)
            
            cell.wobbleView.frame = CGRect(x: 768, y: 0, width: 102, height: 82)
            cell.deleteButton.frame = CGRect(x: 0, y: 0, width: 102, height: 82)
            
            cell.trashCanIcon.frame.size = CGSize(width: 55, height: 63)
        }
        else if screenWidth == 834 && screenHeight == 1194{
            cell.categoryName.font = cell.categoryName.font.withSize(55)
            
            cell.mainView.frame = CGRect(x: 0, y: 0, width: 834, height: 94)
            
            cell.colorView.frame = CGRect(x: 0, y: 0, width: 70, height: 94)
            
            cell.seperator.frame = CGRect(x: 0, y: 92, width: 834, height: 2)
            
            cell.wobbleView.frame = CGRect(x: 834, y: 0, width: 102, height: 94)
            cell.deleteButton.frame = CGRect(x: 0, y: 0, width: 102, height: 94)
            
            cell.trashCanIcon.frame.size = CGSize(width: 60, height: 70)
        }
        else if screenWidth == 834 && screenHeight == 1112{
            cell.categoryName.font = cell.categoryName.font.withSize(50)
            
            cell.mainView.frame = CGRect(x: 0, y: 0, width: 834, height: 87)
            
            cell.colorView.frame = CGRect(x: 0, y: 0, width: 70, height: 87)
            
            cell.seperator.frame = CGRect(x: 0, y: 85, width: 834, height: 2)
            
            cell.wobbleView.frame = CGRect(x: 834, y: 0, width: 102, height: 87)
            cell.deleteButton.frame = CGRect(x: 0, y: 0, width: 102, height: 87)
            
            cell.trashCanIcon.frame.size = CGSize(width: 56, height: 66)
        }
        else if screenWidth == 810 && screenHeight == 1080{
            cell.categoryName.font = cell.categoryName.font.withSize(50)
            
            cell.mainView.frame = CGRect(x: 0, y: 0, width: 810, height: 87)
            
            cell.colorView.frame = CGRect(x: 0, y: 0, width: 70, height: 87)
            
            cell.seperator.frame = CGRect(x: 0, y: 85, width: 810, height: 2)
            
            cell.wobbleView.frame = CGRect(x: 834, y: 0, width: 102, height: 87)
            cell.deleteButton.frame = CGRect(x: 0, y: 0, width: 102, height: 87)
            
            cell.trashCanIcon.frame.size = CGSize(width: 56, height: 66)
        }
        else if screenWidth == 1024 && screenHeight == 1366{
            cell.categoryName.font = cell.categoryName.font.withSize(80)
            cell.categoryName.frame = CGRect(x: 100, y: 11, width: 914, height: 104)
            
            cell.mainView.frame = CGRect(x: 0, y: 0, width: 1024, height: 27)
            
            cell.colorView.frame = CGRect(x: 0, y: 0, width: 90, height: 127)
            
            cell.seperator.frame = CGRect(x: 0, y: 125, width: 10244, height: 2)
            
            cell.wobbleView.frame = CGRect(x: 1024, y: 0, width: 102, height: 127)
            cell.deleteButton.frame = CGRect(x: 0, y: 0, width: 102, height: 127)
            
            cell.trashCanIcon.frame.size = CGSize(width: 67, height: 77)
        }
    }
}

//conversion to hex
extension UIColor {
    func getHSBAComponents() -> (hue: Float, saturation: Float, brightness: Float, alpha: Float)
    {
        var (hue, saturation, brightness, alpha) = (CGFloat(0.0), CGFloat(0.0), CGFloat(0.0), CGFloat(0.0))
        self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return (Float(hue), Float(saturation), Float(brightness), Float(alpha))
    }
    
    class func colorToOpaque(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat, intendedAlpha: CGFloat) -> UIColor{
        return UIColor(
        red: 1 - alpha * (1 - red),
        green: 1 - alpha * (1 - green),
        blue: 1 - alpha * (1 - blue), alpha: intendedAlpha)
    }
}

//detect delete button of tableviewcell
extension Categories: CategoryCellDelegate{
    func deletePressed(tag: Int){
        let cell = tableView.cellForRow(at: [0,tag]) as! CategoryCell
        
        
        //reset view locations -- only for iPhone XR
        cell.mainView.frame.origin = CGPoint(x: 0, y: 0)
        cell.wobbleView.frame.origin = CGPoint(x: screenWidth, y: 0)
        
        tableView.reloadData()
        
        //start realm
        let realm = try! Realm()
        
        //call category from realms
        let categoryRealm = realm.objects(Category.self)
        
        //for routines and tasks that had the categoryName, change it to nothing
        
        let plannerSelectedCategoryRealms = realm.objects(TaskSaved.self).filter("category == %@", tag)
        
        for task in plannerSelectedCategoryRealms{
            try! realm.write{
                task.category = -1
                task.categoryName = ""
            }
        }
        
        let routineSelectedCategoryRealms = realm.objects(Routine.self).filter("categoryNum == %@", tag)
        
        for routine in routineSelectedCategoryRealms{
            try! realm.write{
                routine.categoryNum = -1
                routine.categoryName = ""
            }
        }
        
        try! realm.write{
            realm.delete(categoryRealm[tag])
        }
        
        tableView.reloadData()
    }
    
    func startScroll() {
        tableView.isScrollEnabled = true
    }
    
    func stopScroll() {
        tableView.isScrollEnabled = false
    }
}

//setup tableview
extension Categories: UITableViewDelegate, UITableViewDataSource{
    //Basic TableView Setup
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //start realm
        let realm = try! Realm()
        
        //call category from realms
        let categoryRealm = realm.objects(Category.self)
        
        return categoryRealm.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! CategoryCell
        //start realm
        let realm = try! Realm()
        
        let categoryRealm = realm.objects(Category.self)
        
        let categoryItem = categoryRealm[indexPath.item]
        
        //set name
        cell.categoryName.text = categoryItem.name
        
        //resize to increase size of cell
        resizeCell(cell: cell)
        
        if screenWidth == 375 && screenHeight == 812{
            cell.categoryName.frame = CGRect(x: 60, y: 10, width: 295, height: 46)
        }
        else if screenWidth == 414 && screenHeight == 896{
            cell.categoryName.frame = CGRect(x: 62, y: 11, width: 340, height: 55)
        }
        else if screenWidth == 414 && screenHeight == 736{
            cell.categoryName.frame = CGRect(x: 45, y: 5, width: 354, height: 45)
        }
        else if screenWidth == 375 && screenHeight == 667{
            cell.categoryName.frame = CGRect(x: 45, y: 5.5, width: 325, height: 46)
        }
        else if screenWidth == 320 && screenHeight == 568{
            cell.categoryName.frame = CGRect(x: 35, y: 5.5, width: 280, height: 39)
        }
        else if screenWidth == 768 && screenHeight == 1024{
            cell.categoryName.frame = CGRect(x: 80, y: 10, width: 678, height: 62)
        }
        else if screenWidth == 834 && screenHeight == 1194{
            cell.categoryName.frame = CGRect(x: 80, y: 10, width: 744, height: 72)
        }
        else if screenWidth == 834 && screenHeight == 1112{
            cell.categoryName.frame = CGRect(x: 80, y: 10, width: 744, height: 65)
        }
        else if screenWidth == 810 && screenHeight == 1080{
            cell.categoryName.frame = CGRect(x: 80, y: 10, width: 720, height: 65)
        }
        else if screenWidth == 1024 && screenHeight == 1366{
            cell.categoryName.frame = CGRect(x: 100, y: 11, width: 914, height: 104)
        }
        
        cell.categoryName.sizeToFit()
        
        tempHeight = cell.categoryName.frame.size.height
        
        var cellHeight: CGFloat = 0
        
        if screenWidth == 375 && screenHeight == 812{
            cellHeight = tempHeight + 20
        }
        else if screenWidth == 414 && screenHeight == 896{
            cellHeight = tempHeight + 24
        }
        else if screenWidth == 414 && screenHeight == 736{
            cellHeight = tempHeight + 12
        }
        else if screenWidth == 375 && screenHeight == 667{
            cellHeight = tempHeight + 11
        }
        else if screenWidth == 320 && screenHeight == 568{
            cellHeight = tempHeight + 12
        }
        else if screenWidth == 768 && screenHeight == 1024{
            cellHeight = tempHeight + 14
        }
        else if screenWidth == 834 && screenHeight == 1194{
            cellHeight = tempHeight + 22
        }
        else if screenWidth == 834 && screenHeight == 1112{
            cellHeight = tempHeight + 22
        }
        else if screenWidth == 810 && screenHeight == 1080{
            cellHeight = tempHeight + 22
        }
        else if screenWidth == 1024 && screenHeight == 1366{
            cellHeight = tempHeight + 23
        }
        
        //set view heights to accomadate spacing
        cell.colorView.frame.size.height = cellHeight
        cell.seperator.frame.origin.y = cellHeight - 2
        cell.mainView.frame.size.height = cellHeight
        cell.wobbleView.frame.size.height = cellHeight - 2
        cell.deleteButton.frame.size.height = cellHeight - 2
        
        //seperator and wobbleview resize
        if screenWidth == 320 && screenHeight == 568{
            cell.seperator.frame.origin.y = cellHeight - 1
            cell.wobbleView.frame.size.height = cellHeight - 1
            cell.deleteButton.frame.size.height = cellHeight - 1
        }
        else if screenWidth == 375 && screenHeight == 667{
            cell.seperator.frame.origin.y = cellHeight - 1
            cell.wobbleView.frame.size.height = cellHeight - 1
            cell.deleteButton.frame.size.height = cellHeight - 1
        }
        
        //center trashcanicon
        cell.trashCanIcon.frame.origin.y = cell.wobbleView.frame.size.height/2 - cell.trashCanIcon.frame.size.height/2
        
        cell.trashCanIcon.frame.origin.x = screenWidth + cell.wobbleView.frame.size.width/2 - cell.trashCanIcon.frame.size.width/2
        
        
        //set color
        cell.colorView.backgroundColor = UIColor(hue: CGFloat(categoryItem.h), saturation: CGFloat(categoryItem.s), brightness: CGFloat(categoryItem.b), alpha: CGFloat(categoryItem.a))
        
        //set tag of color to cell
        cell.tag = indexPath.item
        
        //set delegate of cell
        cell.delegate = self
        
        //reset view locations -- only for iPhone XR
        cell.mainView.frame.origin = CGPoint(x: 0, y: 0)
        cell.wobbleView.frame.origin = CGPoint(x: screenWidth, y: 0)
        
        cell.wobbleView.positionChanged()
        
        cell.wobbleView.reset()
        
        return cell
    }
    
    //set height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //start realm
        let realm = try! Realm()
        
        //call category from realms
        let categoryRealm = realm.objects(Category.self)
        
        //if last row - get rid of seperator
        if indexPath.row == categoryRealm.count - 1{
            if screenWidth == 375 && screenHeight == 812{
                return tempHeight + 20 - 2
            }
            else if screenWidth == 375 && screenHeight == 667{
                
                return tempHeight + 11 - 1
            }
            else if screenWidth == 414 && screenHeight == 736{
                
                return tempHeight + 12 - 2
            }
            else if screenWidth == 320 && screenHeight == 568{
                
                return tempHeight + 12 - 1
            }
            else if screenWidth == 768 && screenHeight == 1024{
                
                return tempHeight + 14 - 2
            }
            else if screenWidth == 834 && screenHeight == 1194{
                
                return tempHeight + 22 - 2
            }
            else if screenWidth == 834 && screenHeight == 1112{
                
                return tempHeight + 22 - 2
            }
            else if screenWidth == 810 && screenHeight == 1080{
                
                return tempHeight + 22 - 2
            }
            else if screenWidth == 1024 && screenHeight == 1366{
                
                return tempHeight + 23 - 2
            }
            return tempHeight + 24 - 2
        }
        
        if screenWidth == 375 && screenHeight == 812{
            return tempHeight + 20
        }
        else if screenWidth == 375 && screenHeight == 667{
            
            return tempHeight + 11
        }
        else if screenWidth == 414 && screenHeight == 736{
            
            return tempHeight + 12
        }
        else if screenWidth == 320 && screenHeight == 568{
            
            return tempHeight + 12
        }
        else if screenWidth == 768 && screenHeight == 1024{
            
            return tempHeight + 14
        }
        else if screenWidth == 834 && screenHeight == 1194{
            
            return tempHeight + 22
        }
        else if screenWidth == 834 && screenHeight == 1112{
            
            return tempHeight + 22
        }
        else if screenWidth == 810 && screenHeight == 1080{
            
            return tempHeight + 22
        }
        else if screenWidth == 1024 && screenHeight == 1366{
            
            return tempHeight + 23
        }
        return tempHeight + 24
    }
    
    //edit function
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        generator = UIImpactFeedbackGenerator(style: .medium)
        generator?.prepare()
        generator?.impactOccurred()
        generator = nil
        
        delegate?.editPopup(path: indexPath.row)
    }
}

extension UIColor {
    convenience init(hex: String, alpha: Float = 1.0){
        let scanner = Scanner(string:hex)
        var color:UInt32 = 0;
        scanner.scanHexInt32(&color)

        let mask = 0x000000FF
        let r = CGFloat(Float(Int(color >> 16) & mask)/255.0)
        let g = CGFloat(Float(Int(color >> 8) & mask)/255.0)
        let b = CGFloat(Float(Int(color) & mask)/255.0)

        self.init(red: r, green: g, blue: b, alpha: CGFloat(alpha))
    }
}
