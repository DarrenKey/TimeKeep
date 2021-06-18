//
//  ViewController-Categories.swift
//  Calendar
//
//  Created by Mi Yan on 10/31/19.
//  Copyright © 2019 Darren Key. All rights reserved.
//

import UIKit
class ViewController_Categories: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: CategoriesTableView!

    //indexPath of editing cell
    var editPath: IndexPath = []
    var editPathNum:Int = 0
    
    @IBOutlet weak var endView: UIView!
    
    var rowHeight = CGFloat()
    
    
    @IBOutlet weak var categoryLabel: UILabel!
    var categories = Singleton.categories
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        let screenHeight = UIScreen.main.bounds.height
        categoryLabel.font = categoryLabel.font.withSize(min(45 * screenHeight/842,45))
        /*
        // Do any additional setup after loading the view.
        
        */
        //remove view controllers
        
        var viewControllers = navigationController?.viewControllers
        viewControllers?.removeAll()
        
        tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: endView.frame.origin.y - tableView.frame.origin.y - 5)
        tableView.rowHeight = tableView.frame.size.height/11
        rowHeight = tableView.frame.size.height/11
        /*
        if Singleton.categories.count < 10{
            tableView.frame = CGRect(x:45, y:220 , width: 324, height: Singleton.categories.count*48)
        }
        else{
            
        }
        */
        tableView.tintColor = .clear
        tableView.layer.borderColor = UIColor.white.cgColor
        tableView.layer.borderWidth = 1
        tableView.separatorColor = .clear
        tableView.backgroundColor = .clear
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Singleton.categories.count

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        editPathNum = indexPath.row
        if editPathNum < Singleton.categories.count ?? -1{
            Singleton.pathOfCell = editPathNum
            Singleton.isEditing = true
            performSegue(withIdentifier: "toPopup", sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == UITableViewCell.EditingStyle.delete {
            //Remove the data for that category
            let i = indexPath.row
            
            Singleton.attributes.remove(at: i)
            Singleton.categories.remove(at: i)
            Singleton.colorsC.remove(at: i)
            Singleton.timeData.remove(at: i)
            Singleton.hue.remove(at: i)
            Singleton.colorPath.remove(at: i)
            Singleton.displayTime.remove(at: i)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellC") as! ColorCellinCategoryVC
        
        cell.insideCircle.tintColor = Singleton.colorsC[indexPath.row]
        cell.backgroundColor = UIColor.clear
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 1
        cell.labelT.text = Singleton.categories[indexPath.row]
        return cell
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
