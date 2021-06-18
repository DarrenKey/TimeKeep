//
//  alarmSegmentedControl.swift
//  TimeKeep
//
//  Created by Mi Yan on 4/27/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//

import UIKit

class alarmSegmentedControl: UISegmentedControl {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        for selectView in subviews{
            selectView.layer.cornerRadius = 0
        }
    }
}
