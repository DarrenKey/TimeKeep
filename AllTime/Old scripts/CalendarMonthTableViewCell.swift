//
//  CalendarMonthTableViewCell.swift
//  Calendar
//
//  Created by Mi Yan on 12/31/19.
//  Copyright © 2019 Darren Key. All rights reserved.
//

import UIKit

class CalendarMonthTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource{
    
    var delegate: MyCellDelegate?
    
    //Calendar Collection View
    @IBOutlet weak var collectionView: UICollectionView!
    //label of the month
    @IBOutlet weak var monthL: UILabel!
    
    //label of the year
    @IBOutlet weak var yearL: UILabel!
    
    //when today is
    var todayDay = -1
    
    //when day selected is
    var whenDayIs = -1
    
    var days = ["S","M","T","W","T","F","S"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        //collectionView.register(calenderCell.self, forCellWithReuseIdentifier: "calendarC")
        // Initialization code
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 49
    }
    
    //cells are reused so the array has to be reset
    override func prepareForReuse() {
        days = ["S","M","T","W","T","F","S"]
        whenDayIs = -1
        todayDay = -1
    }
    
    
    //create cell of each
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarC", for: indexPath) as! calenderCell

        
        cell.labelT?.text = days[indexPath.row]
        
        if indexPath.row <= 6{
            cell.labelT.textColor = UIColor.white
            cell.labelT.font = UIFont(name: "Segoe UI", size: 16)!
        }
        else{
            cell.labelT.textColor = UIColor(red: 134/255, green: 134/255, blue: 134/255, alpha: 1)
            cell.labelT.font = UIFont(name: "Segoe UI", size: 20)!
        }
        
        cell.backgroundColor = .clear
        cell.layer.borderWidth = 0
        //if the cell is today's cell, select it
        if indexPath.row == todayDay{
            cell.backgroundColor = .white
            todayDay = -1
            
        }
        // if the cell is the selected date, select it
        else if indexPath.row == whenDayIs{
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.white.cgColor
            whenDayIs = -1
        }
        
        cell.labelT.textAlignment = .center
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! calenderCell
        
        if let tableViewcell = collectionView.superview?.superview as? CalendarMonthTableViewCell {
            let indexPathG = tableViewcell.tag
            
            if ["M", "T", "W", "F", "S", ""].contains(cell.labelT.text) == false{
                let day = cell.labelT.text!
                
                let month = Singleton.monthArray[indexPathG % 12]
                let year = 2020 + Int(indexPathG/12)
                if Singleton.isTimeline == true{
                    let date = Calendar.current.date(from: DateComponents(year: year, month: indexPathG % 12 + 1, day: Int(day)))!
                    Singleton.timelineDate = date
                    self.delegate?.transitionTimeline()
                }
                else{
                    let monthD = indexPathG % 12 + 1
                    Singleton.dateTracker = "\(month) \(day), \(year)"
                    Singleton.selectedDate = Calendar.current.date(from: DateComponents(year:year,month: monthD,day: Int(day)))!
                    self.delegate?.cellWasPressed()
                }
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension CalendarMonthTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/7, height: collectionView.frame.size.width/7)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
