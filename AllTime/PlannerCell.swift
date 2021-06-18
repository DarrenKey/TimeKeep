//
//  PlannerCell.swift
//  TimeKeep
//
//  Created by Mi Yan on 4/30/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//

import UIKit

protocol changeDay{
    func goLeft()
    func goRight()
    func bringDownCalendar()
}


class PlannerCell: UICollectionViewCell {
    
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var leftPointer: UIButton!
    @IBOutlet weak var rightPointer: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var masterView: UIView!
    @IBOutlet weak var dateText: UILabel!
    
    //delegate for pointers if pressed
    var delegate: changeDay?
    
    @IBAction func leftPointerPressed(_ sender: Any) {
        delegate?.goLeft()
    }
    
    @IBAction func rightPointerPressed(_ sender: Any) {
        delegate?.goRight()
    }
    
    @IBAction func calendarPressed(_ sender: Any) {
        delegate?.bringDownCalendar()
    }
    //another script deals with delegation to prevent mvc violation
    func setTableViewDataSourceDelegate(dataSourceDelegate: UITableViewDataSource & UITableViewDelegate) {
            tableView.delegate = dataSourceDelegate
            tableView.dataSource = dataSourceDelegate
            tableView.reloadData()
    }
    
}
