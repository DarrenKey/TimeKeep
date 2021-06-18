//
//  repeatCell.swift
//  Calendar
//
//  Created by Mi Yan on 1/4/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//

import UIKit

class repeatCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    
    var dateArray = ["None","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    //path of dateArray
    var selectedRepeats = [IndexPath]()
    @IBOutlet weak var tableView: UITableView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //standard tableview initialization
        tableView.delegate = self
        tableView.dataSource = self
        
        //automatically select none option
        tableView.selectRow(at: [0,0], animated: true, scrollPosition: .none)
        
        let cell = tableView.cellForRow(at: [0,0])
        cell?.backgroundColor = .white
        
        selectedRepeats.append([0,0])
        tableView.allowsMultipleSelection = true
        
        tableView.backgroundColor = .clear
              
        tableView.rowHeight = 30
        
        
        if Singleton.isEditingEvent == true{
            let arrayOfEverything = Singleton.dayDict[Singleton.dateTracker]?[Singleton.pathOfCellEvent] as! [Any]
            if arrayOfEverything[6] as? Date != nil{
                let repeatT = arrayOfEverything[7] as! [IndexPath]
                for i in repeatT{
                    tableView.selectRow(at: i, animated: true, scrollPosition: .none)
                }
            }
        }
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func numberOfSections(in tableView: UITableView) -> Int {
          return 1
      }
    //table view setup
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 8
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        cell.backgroundColor = .clear
        cell.textLabel?.text = dateArray[indexPath.row]
        cell.textLabel?.textColor = UIColor(red: 134/255, green: 134/255, blue: 134/255, alpha: 1)
        cell.textLabel?.font = UIFont(name: "Segoe-UI", size: 20)
        cell.selectionStyle = .none
        
        return cell
    }
      
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == [0,0]{
            for i in selectedRepeats{
                tableView.deselectRow(at: i, animated: true)
                let cell = tableView.cellForRow(at: i)
                cell?.backgroundColor = .clear
            }
            
            let cell = tableView.cellForRow(at: [0,0])
            cell?.backgroundColor = .white
            
            selectedRepeats = [[0,0]]
        }
        else if selectedRepeats.contains([0,0]){
            
            //deselection of none option
            tableView.deselectRow(at: [0,0], animated: true)
            selectedRepeats.remove(at: 0)
            let cell = tableView.cellForRow(at: [0,0])
            cell?.backgroundColor = .clear
            
            
            selectedRepeats = tableView.indexPathsForSelectedRows ?? []
            
            let cellT = tableView.cellForRow(at: indexPath)
            cellT?.backgroundColor = .white
        }
        else{
            selectedRepeats = tableView.indexPathsForSelectedRows ?? []
            
            let cell = tableView.cellForRow(at: indexPath)
            cell?.backgroundColor = .white
        }
        
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedRepeats = tableView.indexPathsForSelectedRows ?? []


        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = .clear
        
        if selectedRepeats.count == 0{
            tableView.selectRow(at: [0,0], animated: true, scrollPosition: .none)
            selectedRepeats.append([0,0])
            let cell = tableView.cellForRow(at: [0,0])
            cell?.backgroundColor = .white
        }
          
    }

}
