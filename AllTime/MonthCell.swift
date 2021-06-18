//
//  MonthCell.swift
//  TimeKeep
//
//  Created by Mi Yan on 4/28/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//

import UIKit


protocol changeYear{
    
    //pointer clicked left
    func goLeftYear(index: Int)
    
    //pointer clicked right
    func goRightYear(index:Int)
    
    //change back to month
    func changeBackDate()
    
    //change back to month - swipe up
    func changeBackDateUp()
}

class MonthCell: UICollectionViewCell {
    
    //delegate to viewcontroller
    var delegate: changeYear?
    
    //inner collectionview
    @IBOutlet weak var collectionViewMonths: UICollectionView!
    
    @IBOutlet weak var labelView: UIView!
    //year
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var leftButton: UIButton!
    
    @IBOutlet weak var rightButton: UIButton!
    
    @IBOutlet weak var yearButton: UIButton!
    
    //another script deals with delegation to prevent mvc violation
    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate) {
            collectionViewMonths.delegate = dataSourceDelegate
            collectionViewMonths.dataSource = dataSourceDelegate
            collectionViewMonths.reloadData()
    }
    
    @IBAction func leftPointerTouched(_ sender: Any) {
        self.delegate?.goLeftYear(index: collectionViewMonths.tag)
    }
    
    @IBAction func rightPointerTouched(_ sender: Any) {
        self.delegate?.goRightYear(index: collectionViewMonths.tag)
    }
    
    @IBAction func middleButtonPressed(_ sender: Any) {
        self.delegate?.changeBackDate()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //swipe up - change to year
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))

        swipeUp.direction = .up

        self.addGestureRecognizer(swipeUp)
        
        
        //swipe down - change to year
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))

        swipeDown.direction = .down

        self.addGestureRecognizer(swipeDown)
    }

    //swipe down - change to year
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer){
        if (sender.direction == .up)
        {
            self.delegate?.changeBackDate()
        }
        if (sender.direction == .down)
        {
            self.delegate?.changeBackDateUp()
        }
    }
}
