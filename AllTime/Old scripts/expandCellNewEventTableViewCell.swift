//
//  expandCellNewEventTableViewCell.swift
//  Calendar
//
//  Created by Mi Yan on 1/1/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//

import UIKit

class expandCellNewEventTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override var isSelected: Bool{
        didSet{
            if isHighlighted{
                UIView.animate(withDuration: 1) {
                    self.transform = CGAffineTransform(scaleX: 1, y: 1.5)
                }
            }
            else{
                
                UIView.animate(withDuration: 1) {
                    self.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
            }
            
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
