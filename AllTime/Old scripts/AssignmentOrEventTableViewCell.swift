//
//  AssignmentOrEventTableViewCell.swift
//  Calendar
//
//  Created by Mi Yan on 1/26/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//

import UIKit

class AssignmentOrEventTableViewCell: UITableViewCell {

    @IBOutlet weak var eventOrAssignment: UISegmentedControl!
    
    @IBOutlet weak var typeText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        let screenHeight = UIScreen.main.bounds.height
        if screenHeight == 568{
            typeText.font = typeText.font.withSize(15)
        }
        else{
            typeText.font = typeText.font.withSize(min(40,40 * screenHeight/842))
        }
        let fontS = UIFont(name: "Segoe UI", size: 20)
        
        eventOrAssignment.setTitleTextAttributes([NSAttributedString.Key.font: fontS!], for: .normal)

        eventOrAssignment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 134/255, green: 134/255, blue: 134/255, alpha: 1)], for: .normal)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
