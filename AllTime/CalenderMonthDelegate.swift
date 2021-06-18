//
//  CalenderMonthDelegate.swift
//  TimeKeep
//
//  Created by Mi Yan on 4/28/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//

import UIKit
import Foundation


protocol MorphDate{
    func morphIntoDate(months: Int)
}

class CalenderMonthDelegate: NSObject, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var months: [String] = ["JAN","FEB","MAR","APR","MAY","JUNE","JULY","AUG","SEPT","OCT","NOV","DEC"]
    
    var delegate: MorphDate?
    
    var selectedYear = 0
    
    var selectedMonth = 0
    
    //resize
    var screenHeight: CGFloat = 0
    var screenWidth: CGFloat = 0
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == selectedMonth && collectionView.tag == selectedYear{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedMonth", for: indexPath) as! SelectedDateCell
            cell.label.text = months[indexPath.item]
            cell.layer.borderColor = UIColor(hex: "C3C3C3").cgColor
            cell.layer.borderWidth = 2
            
            cell.label.frame.size = cell.frame.size
            cell.label.frame.origin = CGPoint(x: 0, y: 0)
            
            if screenWidth == 320 && screenHeight == 568{
                cell.label.font = cell.label.font.withSize(30)
            }
            else if screenWidth == 768 && screenHeight == 1024{
                cell.label.font = cell.label.font.withSize(55)
            }
            else if screenWidth == 834 && screenHeight == 1194{
                cell.label.font = cell.label.font.withSize(55)
            }
            else if screenWidth == 834 && screenHeight == 1112{
                cell.label.font = cell.label.font.withSize(55)
            }
            else if screenWidth == 810 && screenHeight == 1080{
                cell.label.font = cell.label.font.withSize(55)
            }
            else if screenWidth == 1024 && screenHeight == 1366{
                cell.label.font = cell.label.font.withSize(70)
            }
            else{
                cell.label.font = cell.label.font.withSize(35)
            }
            
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Month", for: indexPath) as! CalendarPopupCell
        cell.label.text = months[indexPath.item]

        cell.label.frame.size = cell.frame.size
        cell.label.frame.origin = CGPoint(x: 0, y: 0)
        
        if screenWidth == 320 && screenHeight == 568{
            cell.label.font = cell.label.font.withSize(30)
        }
        else if screenWidth == 768 && screenHeight == 1024{
            cell.label.font = cell.label.font.withSize(55)
        }
        else if screenWidth == 834 && screenHeight == 1194{
            cell.label.font = cell.label.font.withSize(55)
        }
        else if screenWidth == 834 && screenHeight == 1112{
            cell.label.font = cell.label.font.withSize(55)
        }
        else if screenWidth == 810 && screenHeight == 1080{
            cell.label.font = cell.label.font.withSize(55)
        }
        else if screenWidth == 1024 && screenHeight == 1366{
            cell.label.font = cell.label.font.withSize(70)
        }
        else{
            cell.label.font = cell.label.font.withSize(35)
        }
        
        
        return cell
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
        CGSize(width: (collectionView.frame.size.width/3).rounded(to: 1, roundingRule: .down), height: (collectionView.frame.size.height/4).rounded(to: 1, roundingRule: .down))
    }
    
    //get when cell pressed
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let monthsFromStart = indexPath.item + collectionView.tag * 12
        delegate?.morphIntoDate(months: monthsFromStart)
    }
}

extension FloatingPoint {
    func rounded(to value: Self, roundingRule: FloatingPointRoundingRule = .toNearestOrAwayFromZero) -> Self {
       (self / value).rounded(roundingRule) * value
    }
}
