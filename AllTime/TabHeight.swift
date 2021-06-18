//
//  TabHeight.swift
//  Calendar
//
//  Created by Mi Yan on 12/26/19.
//  Copyright © 2019 Darren Key. All rights reserved.
//

import UIKit

class TabHeight: UITabBar {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func sizeThatFits(_ size: CGSize) -> CGSize{
        let newS = CGSize(width: size.width, height: 136)
        return newS
    }
}
