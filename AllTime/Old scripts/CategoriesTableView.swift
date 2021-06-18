//
//  CategoriesTableView.swift
//  Calendar
//
//  Created by Mi Yan on 12/28/19.
//  Copyright © 2019 Darren Key. All rights reserved.
//

import UIKit

class CategoriesTableView: UITableView {

    override func numberOfRows(inSection section: Int) -> Int {
        return Singleton.categories.count
    }
    
    
    override func cellForRow(at indexPath: IndexPath) -> UITableViewCell? {
        let cell = UITableViewCell()
        
       // cell.textLabel?.text = Singleton.categories[indexPath.row]
        return cell
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
