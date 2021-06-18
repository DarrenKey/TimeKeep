//
//  CalendarPopup.swift
//  TimeKeep
//
//  Created by Mi Yan on 4/27/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//

import UIKit

protocol changeMonth{
    
    //pointer clicked left
    func goLeft(index: Int)
    
    //pointer clicked right
    func goRight(index:Int)
    
    //change to year - swipe from bottom to up
    func changeToYear(year: Int, month: Int)
    
    //change to year - swipe from up to bottom
    func changeToYearDown(year: Int, month: Int)
}

class CalendarPopupCard: UICollectionViewCell {
    @IBOutlet weak var masterView: UIView!
    
    @IBOutlet weak var secondMasterView: UIView!
    
    @IBOutlet weak var labelView: UIView!
    
    @IBOutlet weak var month: UILabel!
    
    @IBOutlet weak var monthButton: UIButton!
    
    @IBOutlet weak var collectionViewCalendar: UICollectionView!
    
    @IBOutlet weak var rightButton: UIButton!
    
    @IBOutlet weak var leftButton: UIButton!
    
    @IBOutlet weak var yearLabel: UILabel!
    
    //another script deals with delegation to prevent mvc violation
    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate) {
            collectionViewCalendar.delegate = dataSourceDelegate
            collectionViewCalendar.dataSource = dataSourceDelegate
            collectionViewCalendar.reloadData()
    }
    
    //delegate to viewcontroller
    var delegate: changeMonth?
    
    @IBAction func leftPointerTouched(_ sender: Any) {
        self.delegate?.goLeft(index: collectionViewCalendar.tag)
    }
    
    @IBAction func rightPointerTouched(_ sender: Any) {
        self.delegate?.goRight(index: collectionViewCalendar.tag)
    }
    
    @IBAction func changeMonth(_ sender: Any) {
        self.delegate?.changeToYear(year: (Int(yearLabel.text ?? "2020") ?? 2020) - 2020, month: collectionViewCalendar.tag % 12)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //swipe down - change to year
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        
        swipeDown.direction = .down

        self.addGestureRecognizer(swipeDown)
        
        //swipe down - change to year
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
    
        
        swipeUp.direction = .up

        self.addGestureRecognizer(swipeUp)
    }

    //swipe down - change to year
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer){
        if (sender.state == .began){
            
        }
        if (sender.direction == .down)
        {
            self.delegate?.changeToYear(year: (Int(yearLabel.text ?? "2020") ?? 2020) - 2020, month: collectionViewCalendar.tag % 12)
        }
        if (sender.direction == .up)
        {
            self.delegate?.changeToYearDown(year: (Int(yearLabel.text ?? "2020") ?? 2020) - 2020, month: collectionViewCalendar.tag % 12)
        }
    }
}
