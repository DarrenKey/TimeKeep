//
//  PageOneOnboarding.swift
//  TimeKeep
//
//  Created by Mi Yan on 7/20/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//

import UIKit

protocol pageOneOnboard{
    func continueToSecond()
    func turnOffTutorial()
}

class PageOneOnboarding: UICollectionViewCell {
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var labelTwo: UILabel!
    @IBOutlet weak var labelThree: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var noThankYouButton: UIButton!
    
    var delegate: pageOneOnboard?
    
    var mediumGenerator: UIImpactFeedbackGenerator? = nil
    
    @IBAction func continueToSecond(_ sender: Any) {
        delegate?.continueToSecond()
        
        //haptic feedback
        mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
        mediumGenerator?.prepare()
        mediumGenerator?.impactOccurred()
        mediumGenerator = nil
    }
    
    @IBAction func turnOffTutorial(_ sender: Any) {
        delegate?.turnOffTutorial()
        
        //haptic feedback
        mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
        mediumGenerator?.prepare()
        mediumGenerator?.impactOccurred()
        mediumGenerator = nil
    }
}
