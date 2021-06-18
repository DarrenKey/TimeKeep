//
//  categoryTVC.swift
//  Calendar
//
//  Created by Mi Yan on 1/1/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//

import UIKit

class categoryTVC: UITableViewCell, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    var selectedCategory = ""
    var colorCategory = UIColor()
    var categoryPath = IndexPath()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Singleton.categories.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
        cell.labelT.text = Singleton.categories[indexPath.row]
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.white.cgColor
        return cell
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tintColor = .clear
        tableView.backgroundColor = .clear
        
        if Singleton.isEditingEvent == true{
            let arrayOfEverything = Singleton.dayDict[Singleton.dateTracker]?[Singleton.pathOfCellEvent] as! [Any]
            let categoryP = arrayOfEverything[2] as! IndexPath
            if categoryP != []{
                tableView.selectRow(at: categoryP, animated: true, scrollPosition: .none)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategory = Singleton.categories[indexPath.row]
        colorCategory = Singleton.colorsC[indexPath.row]
        categoryPath = indexPath
        
        let cell = tableView.cellForRow(at: indexPath) as! ColorCellinCategoryVC
        cell.backgroundColor = .white
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! ColorCellinCategoryVC
        cell.backgroundColor = .clear
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
