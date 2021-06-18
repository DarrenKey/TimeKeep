//
//  LaunchScreenVC.swift
//  TimeKeep
//
//  Created by Mi Yan on 8/21/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//

import UIKit

protocol hideLaunchScreen{
    func hideLaunchScreen()
}

class LaunchScreenVC: UIViewController {
    
    //resize
    var screenWidth: CGFloat = 0
    var screenHeight: CGFloat = 0
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var appIconImageView: UIImageView!
    @IBOutlet weak var timeKeepLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomTextView: UILabel!
    
    var delegate: hideLaunchScreen?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //resize launchscreen
        let screen = UIScreen.main.bounds
        screenWidth = screen.size.width
        screenHeight = screen.size.height
    }
/*
    func resizeDevice(){
        if screenWidth == 375 && screenHeight == 812{
            topView.frame = CGRect(x: 0, y: 0, width: 375, height: 310)
            appIconImageView.frame = CGRect(x: 102, y: 80, width: 171, height: 170)
            
            timeKeepLabel.font = timeKeepLabel.font.withSize(70)
            timeKeepLabel.frame = CGRect(x: 32, y: 360, width: 311, height: 92)
            
            bottomView.frame = CGRect(x: 0, y: 502, width: 375, height: 310)
            bottomTextView.font = bottomTextView.font?.withSize(35)
            bottomTextView.frame = CGRect(x: 49, y: 30, width: 275, height: 128)
        }
        else if screenWidth == 414 && screenHeight == 736{
            topView.frame = CGRect(x: 0, y: 0, width: 414, height: 268)
            appIconImageView.frame = CGRect(x: 122, y: 49, width: 170, height: 170)
            
            timeKeepLabel.font = timeKeepLabel.font.withSize(76)
            timeKeepLabel.frame = CGRect(x: 38, y: 318, width: 338, height: 100)
            
            bottomView.frame = CGRect(x: 0, y: 468, width: 414, height: 268)
            bottomTextView.font = bottomTextView.font?.withSize(35)
            bottomTextView.frame = CGRect(x: 69, y: 30, width: 276, height: 128)
        }
        else if screenWidth == 375 && screenHeight == 667{
            topView.frame = CGRect(x: 0, y: 0, width: 375, height: 251)
            appIconImageView.frame = CGRect(x: 113, y: 51, width: 149, height: 149)
            
            timeKeepLabel.font = timeKeepLabel.font.withSize(65)
            timeKeepLabel.frame = CGRect(x: 43, y: 291, width: 289, height: 85)
            
            bottomView.frame = CGRect(x: 0, y: 416, width: 375, height: 251)
            bottomTextView.font = bottomTextView.font?.withSize(35)
            bottomTextView.frame = CGRect(x: 49, y: 30, width: 276, height: 128)
        }
        else if screenWidth == 320 && screenHeight == 568{
            topView.frame = CGRect(x: 0, y: 0, width: 320, height: 205)
            appIconImageView.frame = CGRect(x: 92, y: 35, width: 136, height: 135)
            
            timeKeepLabel.font = timeKeepLabel.font.withSize(60)
            timeKeepLabel.frame = CGRect(x: 27, y: 245, width: 266, height: 78)
            
            bottomView.frame = CGRect(x: 0, y: 363, width: 320, height: 205)
            bottomTextView.font = bottomTextView.font?.withSize(30)
            bottomTextView.frame = CGRect(x: 22, y: 30, width: 276, height: 128)
        }
        else if screenWidth == 768 && screenHeight == 1024{
            topView.frame = CGRect(x: 0, y: 0, width: 768, height: 387)
            appIconImageView.frame = CGRect(x: 260, y: 70, width: 248, height: 247)
            
            timeKeepLabel.font = timeKeepLabel.font.withSize(100)
            timeKeepLabel.frame = CGRect(x: 162, y: 447, width: 444, height: 130)
            
            bottomView.frame = CGRect(x: 0, y: 637, width: 768, height: 387)
            bottomTextView.font = bottomTextView.font?.withSize(60)
            bottomTextView.frame = CGRect(x: 80, y: 30, width: 608, height: 194)
        }
        else if screenWidth == 834 && screenHeight == 1194{
            topView.frame = CGRect(x: 0, y: 0, width: 834, height: 459)
            appIconImageView.frame = CGRect(x: 267, y: 80, width: 300, height: 300)
            
            timeKeepLabel.font = timeKeepLabel.font.withSize(120)
            timeKeepLabel.frame = CGRect(x: 151, y: 519, width: 532, height: 156)
            
            bottomView.frame = CGRect(x: 0, y: 735, width: 834, height: 459)
            bottomTextView.font = bottomTextView.font?.withSize(80)
            bottomTextView.frame = CGRect(x: 80, y: 30, width: 674, height: 274)
        }
        else if screenWidth == 834 && screenHeight == 1112{
            topView.frame = CGRect(x: 0, y: 0, width: 834, height: 418)
            appIconImageView.frame = CGRect(x: 282, y: 74, width: 270, height: 270)
            
            timeKeepLabel.font = timeKeepLabel.font.withSize(120)
            timeKeepLabel.frame = CGRect(x: 151, y: 478, width: 532, height: 156)
            
            bottomView.frame = CGRect(x: 0, y: 694, width: 834, height: 418)
            bottomTextView.font = bottomTextView.font?.withSize(70)
            bottomTextView.frame = CGRect(x: 80, y: 30, width: 674, height: 274)
        }
        else if screenWidth == 1024 && screenHeight == 1366{
            topView.frame = CGRect(x: 0, y: 0, width: 1024, height: 522)
            appIconImageView.frame = CGRect(x: 327, y: 76, width: 370, height: 370)
            
            timeKeepLabel.font = timeKeepLabel.font.withSize(140)
            timeKeepLabel.frame = CGRect(x: 201, y: 592, width: 622, height: 182)
            
            bottomView.frame = CGRect(x: 0, y: 844, width: 1024, height: 522)
            bottomTextView.font = bottomTextView.font?.withSize(90)
            bottomTextView.frame = CGRect(x: 80, y: 30, width: 864, height: 323)
        }
        else if screenWidth == 810 && screenHeight == 1080{
            topView.frame = CGRect(x: 0, y: 0, width: 810, height: 405)
            appIconImageView.frame = CGRect(x: 275, y: 72, width: 260, height: 261)
            
            timeKeepLabel.font = timeKeepLabel.font.withSize(115)
            timeKeepLabel.frame = CGRect(x: 150, y: 465, width: 510, height: 150)
            
            bottomView.frame = CGRect(x: 0, y: 675, width: 810, height: 405)
            bottomTextView.font = bottomTextView.font?.withSize(70)
            bottomTextView.frame = CGRect(x: 80, y: 30, width: 650, height: 274)
        }
    }
    */
    override func viewDidAppear(_ animated: Bool) {
        //animate opening
        
        UIView.animate(withDuration: 0.3, animations: {
            self.topView.frame.origin.y = -self.topView.frame.size.height
            
            self.bottomView.frame.origin.y = self.screenHeight
        }, completion: {_ in
            self.delegate?.hideLaunchScreen()
        })
        
    }
}
