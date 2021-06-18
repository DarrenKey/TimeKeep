//
//  trailAnimation.swift
//  Calendar
//
//  Created by Mi Yan on 12/28/19.
//  Copyright © 2019 Darren Key. All rights reserved.
//

import UIKit

class trailAnimation: UIView {
    

    override func draw(_ rect: CGRect) {
        
        trailAnimation.drawBP().stroke()
    }
    
    @IBAction func draggedColor(_ sender: Any) {
        
    }
    static func drawBP() -> UIBezierPath{
        
        let arcA = UIBezierPath(arcCenter: Singleton.sizeForAnimation, radius: Singleton.radiusBall, startAngle: -CGFloat.pi/2, endAngle: CGFloat.pi/1800 * CGFloat(Singleton.secondC)-CGFloat.pi/2, clockwise: true)
        
        arcA.lineWidth = Singleton.pathWidth
        
        UIColor(red: 37/255, green: 158/255, blue: 170/255, alpha: 1).setStroke()
        
        return arcA
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
