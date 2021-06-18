//
//  CalendarPopup.swift
//  TimeKeep
//
//  Created by Mi Yan on 4/27/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//

import UIKit

protocol registerPress{
    func registerPress(day: Int, monthsSince: Int)
}

class CalendarPopup: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //haptic feedback
    var mediumGenerator: UIImpactFeedbackGenerator? = nil
    
    //arrays of years
    var yearArray = [2020, 2020, 2020, 2020, 2020, 2020, 2020, 2020, 2020, 2020, 2020,2020, 2021, 2021, 2021, 2021, 2021, 2021, 2021, 2021, 2021, 2021, 2021, 2021, 2022, 2022, 2022, 2022, 2022, 2022, 2022, 2022, 2022, 2022, 2022, 2022, 2023, 2023, 2023, 2023, 2023, 2023, 2023, 2023, 2023, 2023, 2023, 2023, 2024, 2024, 2024, 2024, 2024, 2024, 2024, 2024, 2024, 2024, 2024, 2024, 2025, 2025, 2025, 2025, 2025, 2025, 2025, 2025, 2025, 2025, 2025, 2025, 2026, 2026, 2026, 2026, 2026, 2026,2026, 2026, 2026, 2026, 2026, 2026, 2027, 2027, 2027, 2027, 2027, 2027, 2027, 2027, 2027, 2027, 2027, 2027, 2028, 2028, 2028, 2028, 2028, 2028, 2028, 2028, 2028, 2028, 2028, 2028, 2029, 2029, 2029, 2029, 2029, 2029, 2029, 2029, 2029, 2029, 2029, 2029, 2030, 2030, 2030, 2030, 2030, 2030, 2030, 2030, 2030, 2030, 2030, 2030, 2031, 2031, 2031, 2031, 2031, 2031, 2031, 2031, 2031, 2031, 2031, 2031, 2032,2032, 2032, 2032, 2032, 2032, 2032, 2032, 2032, 2032, 2032, 2032, 2033, 2033, 2033, 2033, 2033, 2033, 2033, 2033, 2033, 2033, 2033, 2033, 2034, 2034, 2034, 2034, 2034, 2034, 2034, 2034, 2034, 2034, 2034, 2034, 2035, 2035, 2035, 2035, 2035, 2035, 2035, 2035, 2035, 2035, 2035, 2035, 2036, 2036, 2036, 2036, 2036, 2036, 2036, 2036, 2036, 2036, 2036, 2036, 2037, 2037, 2037, 2037, 2037, 2037, 2037, 2037,2037, 2037, 2037, 2037, 2038, 2038, 2038, 2038, 2038, 2038, 2038, 2038, 2038, 2038, 2038, 2038, 2039, 2039, 2039, 2039, 2039, 2039, 2039, 2039, 2039, 2039, 2039, 2039]
    
    //bool for is year or not
    var isYearEnabled: Bool = false
    
    //names of the months
    var monthArray = ["JANUARY",
    "FEBRUARY",
    "MARCH",
    "APRIL",
    "MAY",
    "JUNE",
    "JULY",
    "AUGUST",
    "SEPTEMBER",
    "OCTOBER",
    "NOVEMBER",
    "DECEMBER"]
    
    //protocol to main VC
    var delegate: registerPress?
    
    //how many days per month
    var daysPerMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    
    //delegates for inner collectionview
    var innerDelegate = CalendarPopupDelegate()
    
    //delegate for month collectionview
    var monthCellInnerDelegate = CalenderMonthDelegate()
    
    //Jan 1 2020
    var firstDate = Date()
    
    //for morph from date into month
    var selectedYear = 0
    var selectedMonth = 0
    
    //highlighted date
    var highlightedMonth = 0
    var highlightedDay = 0
    
    //resize info
    var screenHeight: CGFloat = 0
    var screenWidth: CGFloat = 0
    
    //month from first month
    @IBOutlet weak var tutorialBlurView: UIView!
    
    var monthFromFirstMonth = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        //basic collectionview setup
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //Jan 1 2020
        var dateComponents = DateComponents()
        dateComponents.year = 2020
        dateComponents.month = 1
        dateComponents.day = 1
        
        firstDate = Calendar.current.date(from: dateComponents)!
        
        //get current date month since Jan 1 2020
        monthFromFirstMonth = Calendar.current.dateComponents([.month], from: firstDate, to: Date()).month ?? 0
        
        //set highlighted month + day
        highlightedMonth = Calendar.current.dateComponents([.month], from: firstDate, to: Date()).month ?? 0
        highlightedDay = Calendar.current.dateComponents([.day], from: Date()).day ?? 0
        
        //scroll to current date
        collectionView.scrollToItem(at: [0,monthFromFirstMonth], at: .centeredHorizontally, animated: false)
        
        let screen = UIScreen.main.bounds
        screenWidth = screen.size.width
        screenHeight = screen.size.height
        
        resizeDevice()
    }
    
    func resizeDevice(){
        if screenWidth == 375 && screenHeight == 812{
            collectionView.frame = CGRect(x: 0, y: 0, width: 332, height: 495)
            tutorialBlurView.frame = CGRect(x: 0, y: 0, width: 332, height: 76)
        }
        else if screenWidth == 375 && screenHeight == 667{
            collectionView.frame = CGRect(x: 0, y: 0, width: 332, height: 495)
            tutorialBlurView.frame = CGRect(x: 0, y: 0, width: 332, height: 76)
        }
        else if screenWidth == 320 && screenHeight == 568{
            collectionView.frame = CGRect(x: 0, y: 0, width: 280, height: 450)
            tutorialBlurView.frame = CGRect(x: 0, y: 0, width: 280, height: 76)
        }
        else if screenWidth == 768 && screenHeight == 1024{
            collectionView.frame = CGRect(x: 0, y: 0, width: 600, height: 700)
            tutorialBlurView.frame = CGRect(x: 0, y: 0, width: 600, height: 148)
        }
        else if screenWidth == 834 && screenHeight == 1194{
            collectionView.frame = CGRect(x: 0, y: 0, width: 600, height: 700)
            tutorialBlurView.frame = CGRect(x: 0, y: 0, width: 600, height: 148)
        }
        else if screenWidth == 834 && screenHeight == 1112{
            collectionView.frame = CGRect(x: 0, y: 0, width: 600, height: 700)
            tutorialBlurView.frame = CGRect(x: 0, y: 0, width: 600, height: 148)
        }
        else if screenWidth == 810 && screenHeight == 1080{
            collectionView.frame = CGRect(x: 0, y: 0, width: 600, height: 700)
            tutorialBlurView.frame = CGRect(x: 0, y: 0, width: 600, height: 148)
        }
        else if screenWidth == 1024 && screenHeight == 1366{
            collectionView.frame = CGRect(x: 0, y: 0, width: 800, height: 1000)
            tutorialBlurView.frame = CGRect(x: 0, y: 0, width: 800, height: 200)
        }
    }
    
}

extension CalendarPopup: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isYearEnabled == true{
            return 20
        }
        else{
            return 240
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isYearEnabled == true{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthChangeCell", for: indexPath) as! MonthCell
            
            cell.yearLabel.text = String(2020 + indexPath.item)
            
            //set delegate of button presses
            cell.delegate = self
            
            //set tag to year
            cell.collectionViewMonths.tag = indexPath.item
            
            //resize cell
            if screenWidth == 375 && screenHeight == 812{
                cell.collectionViewMonths.frame = CGRect(x: 0, y: 76, width: 332, height: 411)
                
                cell.yearLabel.font = cell.yearLabel.font.withSize(35)
                cell.yearLabel.frame = CGRect(x: 122, y: 15, width: 87, height: 46)
                
                cell.rightButton.frame = CGRect(x: 223, y: 27, width: 50, height: 22)
                
                cell.leftButton.frame = CGRect(x: 58, y: 27, width: 50, height: 22)
                
                cell.labelView.frame = CGRect(x: 0, y: 0, width: 332, height: 76)
            }
            else if screenWidth == 375 && screenHeight == 667{
                cell.collectionViewMonths.frame = CGRect(x: 0, y: 76, width: 332, height: 411)
                
                cell.yearLabel.font = cell.yearLabel.font.withSize(35)
                cell.yearLabel.frame = CGRect(x: 122, y: 15, width: 87, height: 46)
                
                cell.rightButton.frame = CGRect(x: 223, y: 27, width: 50, height: 22)
                
                cell.leftButton.frame = CGRect(x: 58, y: 27, width: 50, height: 22)
                
                cell.labelView.frame = CGRect(x: 0, y: 0, width: 332, height: 76)
            }
            else if screenWidth == 320 && screenHeight == 568{
                cell.collectionViewMonths.frame = CGRect(x: 0, y: 76, width: 280, height: 374)
                
                cell.yearLabel.font = cell.yearLabel.font.withSize(35)
                cell.yearLabel.frame = CGRect(x: 96, y: 15, width: 88, height: 46)
                
                cell.rightButton.frame = CGRect(x: 198, y: 27, width: 50, height: 22)
                
                cell.leftButton.frame = CGRect(x: 32, y: 27, width: 50, height: 22)
                
                cell.labelView.frame = CGRect(x: 0, y: 0, width: 280, height: 76)
            }
            else if screenWidth == 768 && screenHeight == 1024{
                cell.collectionViewMonths.frame = CGRect(x: 0, y: 148, width: 600, height: 552)
                
                cell.yearButton.frame = CGRect(x: 128, y: 0, width: 362, height: 148)
                
                cell.yearLabel.font = cell.yearLabel.font.withSize(75)
                cell.yearLabel.frame = CGRect(x: 128, y: 25, width: 362, height: 98)
                
                cell.rightButton.frame = CGRect(x: 490, y: 54.5, width: 50, height: 39)
                
                cell.leftButton.frame = CGRect(x: 79, y: 54.5, width: 50, height: 39)
                
                cell.rightButton.contentHorizontalAlignment = .fill
                cell.rightButton.contentVerticalAlignment = .fill
                
                cell.leftButton.contentHorizontalAlignment = .fill
                cell.leftButton.contentVerticalAlignment = .fill
                
                cell.labelView.frame = CGRect(x: 0, y: 0, width: 600, height: 148)
            }
            else if screenWidth == 834 && screenHeight == 1194{
                cell.collectionViewMonths.frame = CGRect(x: 0, y: 148, width: 600, height: 552)
                
                cell.yearButton.frame = CGRect(x: 128, y: 0, width: 362, height: 148)
                
                cell.yearLabel.font = cell.yearLabel.font.withSize(75)
                cell.yearLabel.frame = CGRect(x: 128, y: 25, width: 362, height: 98)
                
                cell.rightButton.frame = CGRect(x: 490, y: 54.5, width: 50, height: 39)
                
                cell.leftButton.frame = CGRect(x: 79, y: 54.5, width: 50, height: 39)
                
                cell.rightButton.contentHorizontalAlignment = .fill
                cell.rightButton.contentVerticalAlignment = .fill
                
                cell.leftButton.contentHorizontalAlignment = .fill
                cell.leftButton.contentVerticalAlignment = .fill
                
                cell.labelView.frame = CGRect(x: 0, y: 0, width: 600, height: 148)
            }
            else if screenWidth == 834 && screenHeight == 1112{
                cell.collectionViewMonths.frame = CGRect(x: 0, y: 148, width: 600, height: 552)
                
                cell.yearButton.frame = CGRect(x: 128, y: 0, width: 362, height: 148)
                
                cell.yearLabel.font = cell.yearLabel.font.withSize(75)
                cell.yearLabel.frame = CGRect(x: 128, y: 25, width: 362, height: 98)
                
                cell.rightButton.frame = CGRect(x: 490, y: 54.5, width: 50, height: 39)
                
                cell.leftButton.frame = CGRect(x: 79, y: 54.5, width: 50, height: 39)
                
                cell.rightButton.contentHorizontalAlignment = .fill
                cell.rightButton.contentVerticalAlignment = .fill
                
                cell.leftButton.contentHorizontalAlignment = .fill
                cell.leftButton.contentVerticalAlignment = .fill
                
                cell.labelView.frame = CGRect(x: 0, y: 0, width: 600, height: 148)
            }
            else if screenWidth == 810 && screenHeight == 1080{
                cell.collectionViewMonths.frame = CGRect(x: 0, y: 148, width: 600, height: 552)
                
                cell.yearButton.frame = CGRect(x: 128, y: 0, width: 362, height: 148)
                
                cell.yearLabel.font = cell.yearLabel.font.withSize(75)
                cell.yearLabel.frame = CGRect(x: 128, y: 25, width: 362, height: 98)
                
                cell.rightButton.frame = CGRect(x: 490, y: 54.5, width: 50, height: 39)
                
                cell.leftButton.frame = CGRect(x: 79, y: 54.5, width: 50, height: 39)
                
                cell.rightButton.contentHorizontalAlignment = .fill
                cell.rightButton.contentVerticalAlignment = .fill
                
                cell.leftButton.contentHorizontalAlignment = .fill
                cell.leftButton.contentVerticalAlignment = .fill
                
                cell.labelView.frame = CGRect(x: 0, y: 0, width: 600, height: 148)
            }
            else if screenWidth == 1024 && screenHeight == 1366{
                cell.collectionViewMonths.frame = CGRect(x: 0, y: 200, width: 800, height: 800)
                
                cell.yearButton.frame = CGRect(x: 164, y: 0, width: 472, height: 200)
                
                cell.yearLabel.font = cell.yearLabel.font.withSize(90)
                cell.yearLabel.frame = CGRect(x: 164, y: 50, width: 472, height: 98)
                
                cell.rightButton.frame = CGRect(x: 636, y: 75, width: 64, height: 50)
                
                cell.leftButton.frame = CGRect(x: 100, y: 75, width: 64, height: 50)
                
                cell.rightButton.contentHorizontalAlignment = .fill
                cell.rightButton.contentVerticalAlignment = .fill
                
                cell.leftButton.contentHorizontalAlignment = .fill
                cell.leftButton.contentVerticalAlignment = .fill
                
                cell.labelView.frame = CGRect(x: 0, y: 0, width: 800, height: 200)
            }
            
            return cell

        }
            
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarPopupCard", for: indexPath) as! CalendarPopupCard
            
            //set year and month
            cell.month.text = monthArray[indexPath.item % 12]
            cell.yearLabel.text = String(yearArray[indexPath.item])
            
            //set tag to month since Jan 1 2020
            cell.collectionViewCalendar.tag = indexPath.item
            
            //set delegate of button presses
            cell.delegate = self
            
            //resize cell
            if screenWidth == 375 && screenHeight == 812{
                cell.month.font = cell.month.font.withSize(20)
                cell.month.frame = CGRect(x: 87, y: 8, width: 159, height: 26)
                
                cell.yearLabel.font = cell.yearLabel.font.withSize(20)
                cell.yearLabel.frame = CGRect(x: 141, y: 40, width: 50, height: 26)
                
                cell.monthButton.frame = CGRect(x: 87, y: 0, width: 159, height: 74)
                
                cell.rightButton.frame = CGRect(x: 246, y: 10, width: 50, height: 22)
                cell.leftButton.frame = CGRect(x: 37, y: 10, width: 50, height: 22)
                
                cell.secondMasterView.frame = CGRect(x: 0, y: 0, width: 332, height: 495)
                cell.labelView.frame = CGRect(x: 0, y: 0, width: 332, height: 74)
                
                cell.collectionViewCalendar.frame = CGRect(x: 0, y: 74, width: 332, height: 421)
            }
            else if screenWidth == 375 && screenHeight == 667{
                cell.month.font = cell.month.font.withSize(20)
                cell.month.frame = CGRect(x: 87, y: 8, width: 159, height: 26)
                
                cell.yearLabel.font = cell.yearLabel.font.withSize(20)
                cell.yearLabel.frame = CGRect(x: 141, y: 40, width: 50, height: 26)
                
                cell.monthButton.frame = CGRect(x: 87, y: 0, width: 159, height: 74)
                
                cell.rightButton.frame = CGRect(x: 246, y: 10, width: 50, height: 22)
                cell.leftButton.frame = CGRect(x: 37, y: 10, width: 50, height: 22)
                
                cell.secondMasterView.frame = CGRect(x: 0, y: 0, width: 332, height: 495)
                cell.labelView.frame = CGRect(x: 0, y: 0, width: 332, height: 74)
                
                cell.collectionViewCalendar.frame = CGRect(x: 0, y: 74, width: 332, height: 421)
            }
            else if screenWidth == 320 && screenHeight == 568{
                cell.month.font = cell.month.font.withSize(20)
                cell.month.frame = CGRect(x: 60, y: 8, width: 160, height: 26)
                
                cell.yearLabel.font = cell.yearLabel.font.withSize(20)
                cell.yearLabel.frame = CGRect(x: 115, y: 40, width: 50, height: 26)
                
                cell.monthButton.frame = CGRect(x: 60, y: 0, width: 160, height: 74)
                
                cell.rightButton.frame = CGRect(x: 220, y: 10, width: 50, height: 22)
                cell.leftButton.frame = CGRect(x: 10, y: 10, width: 50, height: 22)
                
                cell.secondMasterView.frame = CGRect(x: 0, y: 0, width: 280, height: 450)
                cell.labelView.frame = CGRect(x: 0, y: 0, width: 280, height: 74)
                
                cell.collectionViewCalendar.frame = CGRect(x: 0, y: 74, width: 280, height: 376)
            }
            else if screenWidth == 768 && screenHeight == 1024{
                cell.month.font = cell.month.font.withSize(45)
                cell.month.frame = CGRect(x: 111, y: 10, width: 380, height: 59)
                
                cell.yearLabel.font = cell.yearLabel.font.withSize(45)
                cell.yearLabel.frame = CGRect(x: 111, y: 79, width: 380, height: 59)
                
                cell.monthButton.frame = CGRect(x: 111, y: 0, width: 380, height: 148)
                
                cell.rightButton.frame = CGRect(x: 491, y: 20, width: 50, height: 39)
                cell.leftButton.frame = CGRect(x: 60, y: 20, width: 50, height: 39)
                
                cell.secondMasterView.frame = CGRect(x: 0, y: 0, width: 600, height: 700)
                cell.labelView.frame = CGRect(x: 0, y: 0, width: 600, height: 148)
                
                cell.rightButton.contentHorizontalAlignment = .fill
                cell.rightButton.contentVerticalAlignment = .fill
                
                cell.leftButton.contentHorizontalAlignment = .fill
                cell.leftButton.contentVerticalAlignment = .fill
                
                cell.collectionViewCalendar.frame = CGRect(x: 0, y: 148, width: 600, height: 552)
            }
            else if screenWidth == 834 && screenHeight == 1194{
                cell.month.font = cell.month.font.withSize(45)
                cell.month.frame = CGRect(x: 111, y: 10, width: 380, height: 59)
                
                cell.yearLabel.font = cell.yearLabel.font.withSize(45)
                cell.yearLabel.frame = CGRect(x: 111, y: 79, width: 380, height: 59)
                
                cell.monthButton.frame = CGRect(x: 111, y: 0, width: 380, height: 148)
                
                cell.rightButton.frame = CGRect(x: 491, y: 20, width: 50, height: 39)
                cell.leftButton.frame = CGRect(x: 60, y: 20, width: 50, height: 39)
                
                cell.secondMasterView.frame = CGRect(x: 0, y: 0, width: 600, height: 700)
                cell.labelView.frame = CGRect(x: 0, y: 0, width: 600, height: 148)
                
                cell.rightButton.contentHorizontalAlignment = .fill
                cell.rightButton.contentVerticalAlignment = .fill
                
                cell.leftButton.contentHorizontalAlignment = .fill
                cell.leftButton.contentVerticalAlignment = .fill
                
                cell.collectionViewCalendar.frame = CGRect(x: 0, y: 148, width: 600, height: 552)
            }
            else if screenWidth == 834 && screenHeight == 1112{
                cell.month.font = cell.month.font.withSize(45)
                cell.month.frame = CGRect(x: 111, y: 10, width: 380, height: 59)
                
                cell.yearLabel.font = cell.yearLabel.font.withSize(45)
                cell.yearLabel.frame = CGRect(x: 111, y: 79, width: 380, height: 59)
                
                cell.monthButton.frame = CGRect(x: 111, y: 0, width: 380, height: 148)
                
                cell.rightButton.frame = CGRect(x: 491, y: 20, width: 50, height: 39)
                cell.leftButton.frame = CGRect(x: 60, y: 20, width: 50, height: 39)
                
                cell.secondMasterView.frame = CGRect(x: 0, y: 0, width: 600, height: 700)
                cell.labelView.frame = CGRect(x: 0, y: 0, width: 600, height: 148)
                
                cell.rightButton.contentHorizontalAlignment = .fill
                cell.rightButton.contentVerticalAlignment = .fill
                
                cell.leftButton.contentHorizontalAlignment = .fill
                cell.leftButton.contentVerticalAlignment = .fill
                
                cell.collectionViewCalendar.frame = CGRect(x: 0, y: 148, width: 600, height: 552)
            }
            else if screenWidth == 810 && screenHeight == 1080{
                cell.month.font = cell.month.font.withSize(45)
                cell.month.frame = CGRect(x: 111, y: 10, width: 380, height: 59)
                
                cell.yearLabel.font = cell.yearLabel.font.withSize(45)
                cell.yearLabel.frame = CGRect(x: 111, y: 79, width: 380, height: 59)
                
                cell.monthButton.frame = CGRect(x: 111, y: 0, width: 380, height: 148)
                
                cell.rightButton.frame = CGRect(x: 491, y: 20, width: 50, height: 39)
                cell.leftButton.frame = CGRect(x: 60, y: 20, width: 50, height: 39)
                
                cell.secondMasterView.frame = CGRect(x: 0, y: 0, width: 600, height: 700)
                cell.labelView.frame = CGRect(x: 0, y: 0, width: 600, height: 148)
                
                cell.rightButton.contentHorizontalAlignment = .fill
                cell.rightButton.contentVerticalAlignment = .fill
                
                cell.leftButton.contentHorizontalAlignment = .fill
                cell.leftButton.contentVerticalAlignment = .fill
                
                cell.collectionViewCalendar.frame = CGRect(x: 0, y: 148, width: 600, height: 552)
            }
            else if screenWidth == 1024 && screenHeight == 1366{
                cell.month.font = cell.month.font.withSize(60)
                cell.month.frame = CGRect(x: 164, y: 10, width: 472, height: 78)
                
                cell.yearLabel.font = cell.yearLabel.font.withSize(60)
                cell.yearLabel.frame = CGRect(x: 164, y: 112, width: 472, height: 78)
                
                cell.monthButton.frame = CGRect(x: 164, y: 0, width: 472, height: 200)
                
                cell.rightButton.frame = CGRect(x: 636, y: 24, width: 64, height: 50)
                cell.leftButton.frame = CGRect(x: 100, y: 24, width: 64, height: 50)
                
                cell.secondMasterView.frame = CGRect(x: 0, y: 0, width: 800, height: 1000)
                cell.labelView.frame = CGRect(x: 0, y: 0, width: 800, height: 200)
                
                cell.rightButton.contentHorizontalAlignment = .fill
                cell.rightButton.contentVerticalAlignment = .fill
                
                cell.leftButton.contentHorizontalAlignment = .fill
                cell.leftButton.contentVerticalAlignment = .fill
                
                cell.collectionViewCalendar.frame = CGRect(x: 0, y: 200, width: 800, height: 800)
            }
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if isYearEnabled == true{
            let cell = cell as! MonthCell
            
            //set inner collectionview delegate
            cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: monthCellInnerDelegate)
            
            //set screenheight and width
            (cell.collectionViewMonths.delegate as! CalenderMonthDelegate).screenHeight = screenHeight
            (cell.collectionViewMonths.delegate as! CalenderMonthDelegate).screenWidth = screenWidth
            
            //set delegate's delegate to vc script
            (cell.collectionViewMonths.delegate as! CalenderMonthDelegate).delegate = self
            
            //highlight selected month
            (cell.collectionViewMonths.delegate as! CalenderMonthDelegate).selectedYear = selectedYear
            (cell.collectionViewMonths.delegate as! CalenderMonthDelegate).selectedMonth = selectedMonth
            
        }
        else{
            let cell = cell as! CalendarPopupCard
            
            //set inner collectionview delegate
            cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: innerDelegate)
            
            //set screenheight and width
            (cell.collectionViewCalendar.delegate as! CalendarPopupDelegate).screenHeight = screenHeight
            (cell.collectionViewCalendar.delegate as! CalendarPopupDelegate).screenWidth = screenWidth
            
            //give delegate current month and day since jan 1 2020
            (cell.collectionViewCalendar.delegate as! CalendarPopupDelegate).currentMonth = highlightedMonth
            
            (cell.collectionViewCalendar.delegate as! CalendarPopupDelegate).dayNumber = highlightedDay
            
            //register presses by setting delegate's delegate as self
            (cell.collectionViewCalendar.delegate as! CalendarPopupDelegate).delegate = self
            
        }
    }
    
}

extension CalendarPopup: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if screenWidth == 375 && screenHeight == 812{
            return CGSize(width: 332, height: 495)
        }
        else if screenWidth == 375 && screenHeight == 667{
            return CGSize(width: 332, height: 495)
        }
        else if screenWidth == 320 && screenHeight == 568{
            return CGSize(width: 280, height: 450)
        }
        else if screenWidth == 768 && screenHeight == 1024{
            return CGSize(width: 600, height: 700)
        }
        else if screenWidth == 834 && screenHeight == 1194{
            return CGSize(width: 600, height: 700)
        }
        else if screenWidth == 834 && screenHeight == 1112{
            return CGSize(width: 600, height: 700)
        }
        else if screenWidth == 810 && screenHeight == 1080{
            return CGSize(width: 600, height: 700)
        }
        else if screenWidth == 1024 && screenHeight == 1366{
            return CGSize(width: 800, height: 1000)
        }
        return CGSize(width: 371, height: 547)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension CalendarPopup: changeMonth{
    
    //scroll left
    func goLeft(index: Int) {
        
        //haptic feedback
        mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
        mediumGenerator?.prepare()
        mediumGenerator?.impactOccurred()
        mediumGenerator = nil
        
        //if not leftmost
        if index - 1 >= 0{
            //scroll to current date
            collectionView.scrollToItem(at: [0,index - 1], at: .centeredHorizontally, animated: true)
        }
    }
    
    //scroll right
    func goRight(index: Int) {
        
        //haptic feedback
        mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
        mediumGenerator?.prepare()
        mediumGenerator?.impactOccurred()
        mediumGenerator = nil
        
        //if not leftmost
        if index + 1 <= 239{
            //scroll to current date
            collectionView.scrollToItem(at: [0,index + 1], at: .centeredHorizontally, animated: true)
        }
    }
    
    //change back to date if nothing selected
    func changeBackDate() {
        isYearEnabled = false

        //haptic feedback
        mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
        mediumGenerator?.prepare()
        mediumGenerator?.impactOccurred()
        mediumGenerator = nil
        
        UIView.transition(with: collectionView, duration: 0.5, options: .transitionFlipFromTop, animations: {
            self.collectionView.reloadData()
        }, completion: nil)

        self.collectionView.showsHorizontalScrollIndicator = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.collectionView.scrollToItem(at: [0,self.selectedYear * 12 + self.selectedMonth], at: .centeredHorizontally, animated: false)
        }
        
    }
    
    //change back to date if nothing selected - swipe up
    func changeBackDateUp() {
        isYearEnabled = false

        //haptic feedback
        mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
        mediumGenerator?.prepare()
        mediumGenerator?.impactOccurred()
        mediumGenerator = nil
        
        UIView.transition(with: collectionView, duration: 0.5, options: .transitionFlipFromBottom, animations: {
            self.collectionView.reloadData()
        }, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.collectionView.scrollToItem(at: [0,self.selectedYear * 12 + self.selectedMonth], at: .centeredHorizontally, animated: false)
        }
    }
}

extension CalendarPopup: changeYear{
    //scroll left
    func goLeftYear(index: Int) {

        //haptic feedback
        mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
        mediumGenerator?.prepare()
        mediumGenerator?.impactOccurred()
        mediumGenerator = nil
        
        //if not leftmost
        if index - 1 >= 0{
            //scroll to current date
            collectionView.scrollToItem(at: [0,index - 1], at: .centeredHorizontally, animated: true)
        }
    }
    
    //scroll right
    func goRightYear(index: Int) {

        //haptic feedback
        mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
        mediumGenerator?.prepare()
        mediumGenerator?.impactOccurred()
        mediumGenerator = nil
        
        //if not leftmost
        if index + 1 <= 19{
            //scroll to current date
            collectionView.scrollToItem(at: [0,index + 1], at: .centeredHorizontally, animated: true)
        }
    }
    
    func changeToYear(year: Int, month: Int) {
        //highlight selected month/year
        selectedYear = year
        selectedMonth = month

        isYearEnabled = true

        //haptic feedback
        mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
        mediumGenerator?.prepare()
        mediumGenerator?.impactOccurred()
        mediumGenerator = nil
        
        UIView.transition(with: collectionView, duration: 0.5, options: .transitionFlipFromBottom, animations: {
            self.collectionView.reloadData()
        }, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.collectionView.scrollToItem(at: [0,self.selectedYear], at: .centeredHorizontally, animated: false)
        }
    }
    
    func changeToYearDown(year: Int, month: Int) {
        //highlight selected month/year
        selectedYear = year
        selectedMonth = month
        
        isYearEnabled = true

        //haptic feedback
        mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
        mediumGenerator?.prepare()
        mediumGenerator?.impactOccurred()
        mediumGenerator = nil
        
        UIView.transition(with: collectionView, duration: 0.5, options: .transitionFlipFromTop, animations: {
            self.collectionView.reloadData()
        }, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.collectionView.scrollToItem(at: [0,self.selectedYear], at: .centeredHorizontally, animated: false)
        }
    }
    
}

extension CalendarPopup: MorphDate{
    func morphIntoDate(months: Int) {
        //haptic feedback
        mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
        mediumGenerator?.prepare()
        mediumGenerator?.impactOccurred()
        mediumGenerator = nil
        
        UIView.transition(with: collectionView, duration: 0.5, options: .transitionFlipFromTop, animations: {
            self.isYearEnabled = false
            self.collectionView.reloadData()
        }, completion: nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.collectionView.scrollToItem(at: [0,months], at: .centeredHorizontally, animated: false)
        }
    }
    
}

extension CalendarPopup: onDatePress{
    func handleDatePress(day: Int, monthsSince: Int) {
        delegate?.registerPress(day: day, monthsSince: monthsSince)
    }
}
