//
//  CalendarPopupDelegate.swift
//  TimeKeep
//
//  Created by Mi Yan on 4/28/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//

import UIKit

protocol onDatePress{
    func handleDatePress(day: Int, monthsSince: Int)
}

class CalendarPopupDelegate: NSObject, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //how many days per month
    var daysPerMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    
    //the placement to start the calendar
    var dayEnded = [4, 7, 1, 4, 6, 2, 4, 7, 3, 5, 1, 3, 6, 2, 2, 5, 7, 3, 5, 1, 4, 6,2, 4, 7, 3, 3, 6, 1, 4, 6, 2, 5, 7, 3, 5, 1, 4, 4, 7, 2, 5, 7, 3, 6, 1, 4, 6, 2, 5, 6, 2, 4, 7, 2, 5, 1, 3, 6, 1, 4, 7, 7, 3, 5, 1, 3, 6, 2, 4, 7, 2, 5, 1, 1, 4, 6, 2, 4, 7, 3, 5, 1, 3, 6, 2, 2, 5, 7,3, 5, 1, 4, 6, 2, 4, 7, 3, 4, 7, 2, 5, 7, 3, 6, 1, 4, 6, 2, 5, 5, 1, 3, 6, 1, 4, 7, 2, 5, 7, 3, 6, 6, 2, 4, 7, 2, 5, 1, 3, 6, 1, 4, 7, 7, 3, 5, 1, 3, 6, 2, 4, 7, 2, 5, 1, 2, 5, 7, 3, 5, 1, 4, 6, 2, 4,7, 3, 3, 6, 1, 4, 6, 2, 5, 7, 3, 5, 1, 4, 4, 7, 2, 5, 7, 3, 6, 1, 4, 6, 2, 5, 5, 1, 3, 6, 1, 4, 7, 2, 5, 7, 3, 6, 7, 3, 5, 1, 3, 6, 2, 4, 7, 2, 5, 1, 1, 4, 6, 2, 4, 7, 3, 5, 1, 3, 6, 2, 2, 5, 7, 3, 5,1, 4, 6, 2, 4, 7, 3, 3, 6, 1, 4, 6, 2, 5, 7, 3, 5, 1, 4, 5, 1, 3, 6, 1, 4, 7, 2, 5, 7, 3, 6, 6, 2, 4, 7, 2, 5, 1, 3, 6, 1, 4, 7, 7, 3, 5, 1, 3, 6, 2, 4, 7, 2, 5, 1, 1, 4, 6, 2, 4, 7, 3, 5, 1, 3, 6, 2,3, 6, 1, 4, 6, 2, 5, 7, 3, 5, 1, 4, 4, 7, 2, 5, 7, 3, 6, 1, 4, 6, 2, 5, 5, 1, 3, 6, 1, 4, 7, 2, 5, 7, 3, 6, 6, 2, 4, 7, 2, 5, 1, 3, 6, 1, 4, 7, 1, 4, 6, 2, 4, 7, 3, 5, 1, 3, 6, 2, 2, 5, 7, 3, 5, 1, 4, 6, 2, 4, 7]
    
    //creation of dayArray
    var dayArray:[String] = []
    
    //the label of collectionviewcells
    var labelA = ["SUN","MON","TUE","WED","THU","FRI","SAT"]
    
    //current day number
    var dayNumber = 0
    
    //protocol to handle press on a date
    var delegate: onDatePress?
    
    //curent month number
    var currentMonth = 0
    
    //resize
    var screenHeight: CGFloat = 0
    var screenWidth: CGFloat = 0
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 49
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //month
        let monthFromFirstMonth = collectionView.tag
        
        //if todays month and day
        if monthFromFirstMonth == currentMonth && indexPath.item - dayEnded[monthFromFirstMonth] - 5 == dayNumber{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodayCell", for: indexPath) as! SelectedDateCell
            cell.layer.borderColor = UIColor(hex: "C3C3C3").cgColor
            cell.layer.borderWidth = 2
            
         
           //headers
           if indexPath.item <= 6{
               cell.label.text = labelA[indexPath.item]
           }

           //date between headers and actual dates
           else if indexPath.item >= 7 && indexPath.item <= 5 + dayEnded[monthFromFirstMonth] {
               cell.label.text = ""
           }
               
           //actual dates
           else if indexPath.item >= 6 + dayEnded[monthFromFirstMonth] && indexPath.item <= dayEnded[monthFromFirstMonth] + 5 + daysPerMonth[monthFromFirstMonth % 12]{
               cell.label.text = String(indexPath.item - dayEnded[monthFromFirstMonth] - 5)
           }
               
           //leap year
           else if monthFromFirstMonth % 48 == 1 && indexPath.item == 34 + dayEnded[monthFromFirstMonth]{
           cell.label.text = String(indexPath.item - dayEnded[monthFromFirstMonth] - 5)
           }
           
           //dates between actual dates and end
           else{
               cell.label.text = ""
           }
            
            if screenWidth == 320 && screenHeight == 568{
                cell.label.font = cell.label.font.withSize(12)
            }
            else if screenWidth == 768 && screenHeight == 1024{
                cell.label.font = cell.label.font.withSize(26)
            }
            else if screenWidth == 834 && screenHeight == 1194{
                cell.label.font = cell.label.font.withSize(26)
            }
            else if screenWidth == 834 && screenHeight == 1112{
                cell.label.font = cell.label.font.withSize(26)
            }
            else if screenWidth == 810 && screenHeight == 1080{
                cell.label.font = cell.label.font.withSize(26)
            }
            else if screenWidth == 1024 && screenHeight == 1366{
                cell.label.font = cell.label.font.withSize(35)
            }
            
            cell.label.frame.size = cell.frame.size
            cell.label.frame.origin = CGPoint(x: 0, y: 0)
           
           return cell
            
        }
            
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarPopupCell

            //headers
            if indexPath.item <= 6{
                cell.label.text = labelA[indexPath.item]
            }

            //date between headers and actual dates
            else if indexPath.item >= 7 && indexPath.item <= 5 + dayEnded[monthFromFirstMonth] {
                cell.label.text = ""
            }
                
            //actual dates
            else if indexPath.item >= 6 + dayEnded[monthFromFirstMonth] && indexPath.item <= dayEnded[monthFromFirstMonth] + 5 + daysPerMonth[monthFromFirstMonth % 12]{
                cell.label.text = String(indexPath.item - dayEnded[monthFromFirstMonth] - 5)
            }
                
            //leap year
            else if monthFromFirstMonth % 48 == 1 && indexPath.item == 34 + dayEnded[monthFromFirstMonth]{
            cell.label.text = String(indexPath.item - dayEnded[monthFromFirstMonth] - 5)
            }
            
            //dates between actual dates and end
            else{
                cell.label.text = ""
            }
            
            if screenWidth == 320 && screenHeight == 568{
                cell.label.font = cell.label.font.withSize(12)
            }
            else if screenWidth == 768 && screenHeight == 1024{
                cell.label.font = cell.label.font.withSize(26)
            }
            else if screenWidth == 834 && screenHeight == 1194{
                cell.label.font = cell.label.font.withSize(26)
            }
            else if screenWidth == 834 && screenHeight == 1112{
                cell.label.font = cell.label.font.withSize(26)
            }
            else if screenWidth == 810 && screenHeight == 1080{
                cell.label.font = cell.label.font.withSize(26)
            }
            else if screenWidth == 1024 && screenHeight == 1366{
                cell.label.font = cell.label.font.withSize(35)
            }
            
            cell.label.frame.size = cell.frame.size
            cell.label.frame.origin = CGPoint(x: 0, y: 0)
            
            return cell

        }
    }
    
    
    //0 spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    //size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width/7).rounded(to: 1, roundingRule: .down), height: (collectionView.frame.size.height/7).rounded(to: 1, roundingRule: .down))
    }
    
    //on press
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let monthFromFirstMonth = collectionView.tag
        
        //calculation of what the label is
        
        //actual dates
        if indexPath.item >= 6 + dayEnded[monthFromFirstMonth] && indexPath.item <= dayEnded[monthFromFirstMonth] + 5 + daysPerMonth[monthFromFirstMonth % 12]{
            delegate?.handleDatePress(day: indexPath.item - dayEnded[monthFromFirstMonth] - 5, monthsSince: collectionView.tag)
        }
            
        //leap year
        else if monthFromFirstMonth % 48 == 1 && indexPath.item == 34 + dayEnded[monthFromFirstMonth]{
        delegate?.handleDatePress(day: indexPath.item - dayEnded[monthFromFirstMonth] - 5, monthsSince: collectionView.tag)
        }
    }
}
