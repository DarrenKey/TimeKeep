//
//  NewCategoryVCViewController.swift
//  Calendar
//
//  Created by Mi Yan on 12/28/19.
//  Copyright © 2019 Darren Key. All rights reserved.
//

import UIKit

class NewCategoryVCViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var nameBoxView: UIView!
    @IBOutlet weak var nameBox: UIImageView!
    @IBOutlet weak var categoryN: UITextField!
    @IBOutlet weak var colorV: UIView!
    
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var newCategoryText: UILabel!
    @IBOutlet weak var circleBig: UIImageView!
    
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    var addNewCell = false
    
    //Color Wheel
    
    @IBOutlet var tableView: UITableView!
    var relativeN = 0
    
    @IBOutlet weak var colorLabel: UILabel!
    
    var y = 0
    
    var changeN = CGFloat(0)
    
    var selectedRows = [IndexPath]()
    
    var rowHeight = CGFloat()
    
    //if x is pressed
    @IBAction func exitButton(_ sender: Any) {
        if Singleton.isEditingEvent == true{
            performSegue(withIdentifier: "newEvent", sender: nil)
            Singleton.isEditingEvent = false
        }
        else if Singleton.isInOverride == true{
            performSegue(withIdentifier: "toOverride", sender: nil)
            Singleton.isInOverride = false
        }
        else{
            if Singleton.isEditing == true{
                Singleton.isEditing = false
            }
            performSegue(withIdentifier: "toCategories", sender: nil)
        }
    }
    
    @IBAction func newA(_ sender: Any) {
        addNewCell = true
        //tableView.frame = CGRect(x: 74, y: 511, width: 277, height: self.tableView.frame.size.height + 40)
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //remove view controllers
        
        
        let screenHeight = UIScreen.main.bounds.height
        newCategoryText.font = newCategoryText.font.withSize(50 * screenHeight/842)
        descriptionText.font = descriptionText.font.withSize(40 * screenHeight/842)
        nameText.font = nameText.font.withSize(min(40,40 * screenHeight/842))
        
        //if SE
        if screenHeight == 568{
            nameText.frame = CGRect(x: nameText.frame.origin.x, y: nameText.frame.origin.y - 35, width: nameText.frame.size.width, height: nameText.frame.size.height)
            categoryN.frame = CGRect(x: categoryN.frame.origin.x, y: categoryN.frame.origin.y - 40, width: categoryN.frame.size.width, height: categoryN.frame.size.height)
            nameBoxView.frame = CGRect(x: nameBoxView.frame.origin.x, y: nameBoxView.frame.origin.y - 40, width: nameBoxView.frame.size.width, height: nameBoxView.frame.size.height)
            colorLabel.frame = CGRect(x: colorLabel.frame.origin.x, y: colorLabel.frame.origin.y - 45, width: colorLabel.frame.size.width, height: colorLabel.frame.size.height)
        }
        
        var viewControllers = navigationController?.viewControllers
        viewControllers?.removeAll()
        
        
        let detectPan = UIPanGestureRecognizer(target: self, action: #selector(changeC(sender:)))
        
        colorV.addGestureRecognizer(detectPan)
        
        tableView.layer.borderColor = UIColor.white.cgColor
        tableView.layer.borderWidth = 1
        
        if tableView.frame.origin.y - circleBig.frame.origin.y > circleBig.frame.size.height + descriptionText.frame.size.height + 20{
            tableView.frame = CGRect(x: tableView.frame.origin.x, y: circleBig.frame.origin.y + circleBig.frame.size.height + 20 + descriptionText.frame.size.height, width: tableView.frame.size.width, height: tableView.frame.size.height + tableView.frame.origin.y - circleBig.frame.origin.y - (circleBig.frame.size.height + 20 + descriptionText.frame.size.height))
        }
        
        descriptionText.frame = CGRect(x: tableView.frame.origin.x + tableView.frame.size.width/2 - descriptionText.frame.width/2, y: tableView.frame.origin.y - descriptionText.frame.height, width: descriptionText.frame.size.width, height: descriptionText.frame.size.height)
        
        addButton.frame = CGRect(x: tableView.frame.origin.x + tableView.frame.size.width - addButton.frame.size.width/2, y: tableView.frame.origin.y - addButton.frame.size.height/2, width: addButton.frame.size.width, height: addButton.frame.size.height)
        
        if Singleton.isEditing == true{
            
            for i in 1...7{
                relativeN = Singleton.hue[Singleton.pathOfCell]
                y = (i - relativeN - 1)%10
                let opacity = -0.0833 * CGFloat((i - 4) * (i-4)) + CGFloat(1)
                if y < 0{
                    y = 10 + y
                }
                self.view.viewWithTag(i)?.tintColor = UIColor(hue: CGFloat(0.1 * Double(y)), saturation: 1, brightness: 1, alpha: CGFloat(opacity))
            }
            
            //if category getting edited
            categoryN.text = Singleton.categories[Singleton.pathOfCell]
            
        }
        else{
            for i in 1...7{
                
                let opacity = -0.0833 * CGFloat((i - 4) * (i-4)) + CGFloat(1)
                self.view.viewWithTag(i)?.tintColor = UIColor(hue: CGFloat(0.1 * Double(i-1)), saturation: 1, brightness: 1, alpha: opacity)
            }
        }
        
        nameBoxView.layer.borderColor = UIColor(red:134/255,green:134/255,blue:134/255,alpha:1).cgColor
        nameBoxView.layer.borderWidth = 3
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = true
      //  if Singleton.attributesN.count < 8{
      //      tableView.frame = CGRect(x: 74, y: 511, width: 277, height: Singleton.attributesN.count*40)
     //   }
      //  else{
      //  }
        tableView.tintColor = .clear
        tableView.backgroundColor = .clear
        tableView.rowHeight = tableView.frame.size.height/6
        rowHeight = tableView.frame.size.height/6
        
        categoryN.delegate = self
        //add done to the toolbar
     /*   let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton =  UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(doneClicked))

        toolBar.setItems([flexibleSpace,doneButton], animated:false)
        
        categoryN.inputAccessoryView = toolBar*/
        
        
        //change field of box to center with outsidebox
        //categoryN.frame = CGRect(x:nameBox.frame.origin.x + 10,y:nameBox.frame.origin.y + 3,width:nameBox.frame.size.width - 20,height:nameBox.frame.size.height - 6)
        
        if Singleton.isEditing == true{
            tableView.reloadData()
            for i in Singleton.colorPath[Singleton.pathOfCell]{
                tableView.selectRow(at: [0,i], animated: false, scrollPosition: UITableView.ScrollPosition.none)
                let currentCell = tableView.cellForRow(at: [0,i]) as! LabelCellNormalAttribute
                currentCell.imageCell.tintColor = .white
                selectedRows.append([0,i])
            }
        }
        
        let centerH = (descriptionText.frame.origin.y + colorLabel.frame.origin.y + colorLabel.frame.size.height)/2
        for i in 1...15{
            self.view.viewWithTag(i)!.frame = CGRect(x: self.view.viewWithTag(i)!.frame.origin.x,y: centerH - self.view.viewWithTag(i)!.frame.size.height/2 ,width: self.view.viewWithTag(i)!.frame.size.width, height: self.view.viewWithTag(i)!.frame.size.height)
        }
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if addNewCell == true{
            return Singleton.attributesN.count + 1
        }
        return Singleton.attributesN.count
        

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRows = tableView.indexPathsForSelectedRows!
        let currentCell = tableView.cellForRow(at: indexPath)
        if (currentCell?.isKind(of: LabelCellNormalAttribute.self))!{
            let cell = currentCell as! LabelCellNormalAttribute
            cell.imageCell.tintColor = .white
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedRows = tableView.indexPathsForSelectedRows ?? []
        let currentCell = tableView.cellForRow(at: indexPath)
        if (currentCell?.isKind(of: LabelCellNormalAttribute.self))!{
            let cell = currentCell as! LabelCellNormalAttribute
            cell.imageCell.tintColor = .black
        }
    }
    var lastT = ""
    @IBAction func changeText(_ sender: Any) {
        if categoryN.text!.count > 12{
            categoryN.text = lastT
        }
        lastT = categoryN.text!
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == UITableViewCell.EditingStyle.delete {
            if Singleton.attributesN.count >= indexPath.row + 1{
                Singleton.attributesN.remove(at: indexPath.row)
            }
            tableView.reloadData()
        }
        

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if addNewCell == true && indexPath.row == Singleton.attributesN.count{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddNewCell") as! AttributeCell
            addNewCell = false
            cell.textviewT.text = ""
            cell.backgroundColor = .white
            cell.textviewT.delegate = self
            cell.layer.borderWidth = 0
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellL") as! LabelCellNormalAttribute
      //  cell.backgroundView = UIImageView(image: UIImage(named: "dropDownMenu")!)
        cell.backgroundColor = .clear
        cell.cellL.text = Singleton.attributesN[indexPath.row]
        //cell.cellL.frame = CGRect(x: cell.imageCell.frame.origin.x + 29, y: cell.frame.origin.y, width: cell.frame.size.width, height: cell.frame.size.height)
        cell.layer.borderWidth = 0
        return cell
    }
    
    @objc func changeC(sender:UIPanGestureRecognizer){
        if sender.state == .began{
            changeN = CGFloat(0)
        }
        
        if sender.state == .changed{
            let translationA = sender.translation(in: view).x
            if (translationA - changeN) >= 10 || (translationA - changeN) <= -10{
                relativeN += Int((translationA - changeN)/CGFloat(10))
                changeColor()
                changeN = CGFloat(Int((translationA)/CGFloat(10)) * 10)
            }
        }
    }
    
    func changeColor (){
        for i in 1...7{
            y = (i - relativeN - 1)%10
            let opacity = -0.0833 * CGFloat((i - 4) * (i-4)) + CGFloat(1)
            if y < 0{
                y = 10 + y
            }
            self.view.viewWithTag(i)?.tintColor = UIColor(hue: CGFloat(0.1 * Double(y)), saturation: 1, brightness: 1, alpha: CGFloat(opacity))
            
        }
    }
    
    @IBAction func confirmPressed(_ sender: Any) {
        var attributesN = [String]()
        var colorsPath = [Int]()
        for i in selectedRows{
            if i.row < Singleton.attributesN.count{
                attributesN.append(Singleton.attributesN[i.row])
                colorsPath.append(i.row)
            }
        }
        
        //if categoryN is emnpty and not already used
        if categoryN.text != "" && Singleton.categories.contains(categoryN.text ?? "") == false {
            if Singleton.isEditing == false{
                Singleton.attributes.append(attributesN)
                Singleton.categories.append(categoryN.text!)
                Singleton.colorsC.append(self.view.viewWithTag(4)!.tintColor)
                Singleton.timeData.append([])
                Singleton.hue.append(relativeN)
                Singleton.colorPath.append(colorsPath)
                Singleton.displayTime.append(0)
            }
            else{
                Singleton.attributes[Singleton.pathOfCell] = attributesN
                Singleton.categories[Singleton.pathOfCell] = categoryN.text!
                Singleton.colorsC[Singleton.pathOfCell] = self.view.viewWithTag(4)!.tintColor
                Singleton.isEditing = false
                Singleton.hue[Singleton.pathOfCell] = relativeN
                Singleton.colorPath[Singleton.pathOfCell] = colorsPath
            }
        }
        else if categoryN.text != "" && Singleton.isEditing == true{
            Singleton.attributes[Singleton.pathOfCell] = attributesN
            Singleton.categories[Singleton.pathOfCell] = categoryN.text!
            Singleton.colorsC[Singleton.pathOfCell] = self.view.viewWithTag(4)!.tintColor
            Singleton.isEditing = false
            Singleton.hue[Singleton.pathOfCell] = relativeN
            Singleton.colorPath[Singleton.pathOfCell] = colorsPath
        }
        if Singleton.isEditingEvent == true{
            performSegue(withIdentifier: "newEvent", sender: nil)
            Singleton.isEditingEvent = false
        }
        else if Singleton.isInOverride == true{
            performSegue(withIdentifier: "toOverride", sender: nil)
            Singleton.isInOverride = false
        }
        else{
            performSegue(withIdentifier: "toCategories", sender: nil)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 0{
            self.view.frame = CGRect(x: 0, y: -260, width: self.view.frame.size.width, height: self.view.frame.size.height)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        //textField code

        textField.resignFirstResponder()  //if desired
        performAction(textField: textField)
        return true
    }

    func performAction(textField: UITextField) {
        textField.superview?.endEditing(true)
        tableView.reloadData()
        //action events
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        tableView.reloadData()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.tag == 1{
            self.view.endEditing(true)
        }
        else{
            if textField.tag != -1{
                if textField.text != ""{
                    Singleton.attributesN.append(textField.text!)
                }
                textField.superview?.endEditing(true)
                tableView.reloadData()
                self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        }
    }
    /*
    //end if done pressed
    @objc func doneClicked(){
        
        view.endEditing(true)
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
