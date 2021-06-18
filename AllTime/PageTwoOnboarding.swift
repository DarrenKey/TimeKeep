//
//  PageTwoOnboarding.swift
//  TimeKeep
//
//  Created by Mi Yan on 7/21/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//

import UIKit

protocol pageTwoOnboard{
    func enableNotifications()
    
    func endTutorial()
}


class PageTwoOnboarding: UICollectionViewCell {
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var labelTwo: UILabel!
    
    @IBOutlet weak var enableNotificationsButton: UIButton!
    @IBOutlet weak var noThankYouButton: UIButton!
    var delegate: pageTwoOnboard?
    
    var mediumGenerator: UIImpactFeedbackGenerator? = nil
    
    @IBAction func enableNotifications(_ sender: Any) {
        delegate?.enableNotifications()
        
        //haptic feedback
        mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
        mediumGenerator?.prepare()
        mediumGenerator?.impactOccurred()
        mediumGenerator = nil
    }
    @IBAction func endTutorial(_ sender: Any) {
        delegate?.endTutorial()
        
        //haptic feedback
        mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
        mediumGenerator?.prepare()
        mediumGenerator?.impactOccurred()
        mediumGenerator = nil
    }
}
