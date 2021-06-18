//
//  TabBar.swift
//  TimeKeep
//
//  Created by Mi Yan on 4/25/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//

import UIKit


protocol SwitchTabs{
    
    func switchTab(index: Int)
    
}

class TabBar: UIViewController {
    
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var tabBar: UICollectionView!

    var generator = UISelectionFeedbackGenerator()
    
    var previousCellLocation: IndexPath = [0,2]
    var ifPreviousCell = true
    
    var isAnimationOngoing = false
    
    //to move tab bar
    var moveTabBarConstant: CGFloat = 12
    
    var delegate: SwitchTabs?
    
    //array should be ["CategoryIcon", "PlannerIcon", "RoutinesIcon", "StopwatchIcon", "ChartIcon", "TimelineIcon"]
    var iconArray = ["CategoryIcon", "PlannerIcon", "RoutinesIcon", "StopwatchIcon", "ChartIcon", "TimelineIcon"]
    
    var iconName = ["Categories", "Planner", "Routines", "Stopwatch", "Charts", "Timeline"]

    //resize
    var screenHeight: CGFloat = 0
    var screenWidth: CGFloat = 0
    
    var spacingConstant: CGFloat = 12
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tabBar.delegate = self
        tabBar.dataSource = self
        
        let screen = UIScreen.main.bounds
        screenWidth = screen.size.width
        screenHeight = screen.size.height
        
        resizeDevice()
        
        generator.prepare()
    }

    func resizeDevice(){
        if screenWidth == 375 && screenHeight == 812{
            spacingConstant = 10.71
            
            tabBarView.frame.size.width = 50
            tabBar.frame = CGRect(x: spacingConstant, y: 0, width: 375 - 2 * spacingConstant, height: 55)
            
            moveTabBarConstant = spacingConstant
            
            
            
        }
        else if screenWidth == 414 && screenHeight == 736{
            tabBar.frame = CGRect(x: 12, y: 3, width: 390, height: 62)
        }
        else if screenWidth == 375 && screenHeight == 667{
            spacingConstant = 14.14
            
            tabBarView.frame.size.width = 46
            tabBar.frame = CGRect(x: spacingConstant, y: 0, width: 375 - 2 * spacingConstant, height: 55)
            moveTabBarConstant = spacingConstant
            
            
            
        }
        else if screenWidth == 320 && screenHeight == 568{
            spacingConstant = 6.28
            
            tabBarView.frame.size.width = 46
            tabBar.frame = CGRect(x: spacingConstant, y: 0, width: 320 - 2 * spacingConstant, height: 55)
            moveTabBarConstant = spacingConstant
            
            
            
        }
        else if screenWidth == 768 && screenHeight == 1024{
            spacingConstant = 6
            
            tabBarView.frame.size.width = 121
            tabBar.frame = CGRect(x: spacingConstant, y: 0, width: 768 - 2 * spacingConstant, height: 100)
            moveTabBarConstant = spacingConstant
            
            
            
        }
        else if screenWidth == 1024 && screenHeight == 1366{
            spacingConstant = 10
            
            tabBarView.frame.size.width = 159
            tabBar.frame = CGRect(x: spacingConstant, y: 0, width: 1024 - 2 * spacingConstant, height: 120)
            moveTabBarConstant = spacingConstant
            
            
            
        }
        else if screenWidth == 834 && screenHeight == 1194{
            spacingConstant = 12
            
            tabBarView.frame.size.width = 125
            tabBar.frame = CGRect(x: spacingConstant, y: 0, width: 834 - 2 * spacingConstant, height: 110)
            moveTabBarConstant = spacingConstant
            
            
            
        }
        else if screenWidth == 834 && screenHeight == 1112{
            spacingConstant = 12
            
            tabBarView.frame.size.width = 125
            tabBar.frame = CGRect(x: spacingConstant, y: 0, width: 834 - 2 * spacingConstant, height: 110)
            moveTabBarConstant = spacingConstant
            
            
            
        }
        else if screenWidth == 810 && screenHeight == 1080{
            spacingConstant = 6
            
            tabBarView.frame.size.width = 128
            tabBar.frame = CGRect(x: spacingConstant, y: 0, width: 810 - 2 * spacingConstant, height: 110)
            moveTabBarConstant = spacingConstant
            
            
            
        }

    }
}

//collectionview
extension TabBar: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryTabButton", for: indexPath) as! TabBarCell

        
        
        //set images of cell
        cell.selectedIcon.image = UIImage(named: iconArray[indexPath.item])
        cell.iconImage.image = UIImage(named: iconArray[indexPath.item])
        
        //set name of icons
        cell.iconText.text = iconName[indexPath.item]
        
        if screenWidth == 375{
            
            if screenHeight == 812{
                cell.selectedIcon.frame = CGRect(x: 9, y: 6, width: 32, height: 32)
                cell.iconImage.frame = CGRect(x: 9, y: 6, width: 32, height: 32)
                cell.iconText.frame = CGRect(x: 0, y: 41, width: 50, height: 13)
                cell.iconText.font = cell.iconText.font.withSize(10)
            }
            else{
                cell.selectedIcon.frame = CGRect(x: 7, y: 6, width: 32, height: 32)
                cell.iconImage.frame = CGRect(x: 7, y: 6, width: 32, height: 32)
                cell.iconText.frame = CGRect(x: 3, y: 41, width: 40, height: 11)
                cell.iconText.font = cell.iconText.font.withSize(8)
            }
        }
        else if screenWidth == 320 && screenHeight == 568{
            cell.selectedIcon.frame = CGRect(x: 7, y: 6, width: 32, height: 32)
            cell.iconImage.frame = CGRect(x: 7, y: 6, width: 32, height: 32)
            cell.iconText.font = cell.iconText.font.withSize(8)
            cell.iconText.frame = CGRect(x: 3, y: 41, width: 40, height: 11)
        }
        else if screenWidth == 768 && screenHeight == 1024{
            cell.selectedIcon.frame = CGRect(x: 29.5, y: 8, width: 62, height: 62)
            cell.iconImage.frame = CGRect(x: 29.5, y: 8, width: 62, height: 62)
            cell.iconText.font = cell.iconText.font.withSize(15)
            cell.iconText.frame = CGRect(x: 0, y: 75, width: 121, height: 20)
        }
        else if screenWidth == 1024 && screenHeight == 1366{
            cell.selectedIcon.frame = CGRect(x: 42.5, y: 12, width: 74, height: 74)
            cell.iconImage.frame = CGRect(x: 42.5, y: 12, width: 74, height: 74)
            cell.iconText.font = cell.iconText.font.withSize(20)
            cell.iconText.frame = CGRect(x: 0, y: 91, width: 159, height: 26)
        }
        else if screenWidth == 834 && screenHeight == 1194{
            cell.selectedIcon.frame = CGRect(x: 28, y: 8, width: 69, height: 69)
            cell.iconImage.frame = CGRect(x: 28, y: 8, width: 69, height: 69)
            cell.iconText.font = cell.iconText.font.withSize(17)
            cell.iconText.frame = CGRect(x: 0, y: 82, width: 125, height: 23)
        }
        else if screenWidth == 834 && screenHeight == 1112{
            cell.selectedIcon.frame = CGRect(x: 28, y: 8, width: 69, height: 69)
            cell.iconImage.frame = CGRect(x: 28, y: 8, width: 69, height: 69)
            cell.iconText.font = cell.iconText.font.withSize(17)
            cell.iconText.frame = CGRect(x: 0, y: 82, width: 125, height: 23)
        }
        else if screenWidth == 810 && screenHeight == 1080{
            cell.selectedIcon.frame = CGRect(x: 30, y: 8, width: 68, height: 68)
            cell.iconImage.frame = CGRect(x: 30, y: 8, width: 68, height: 68)
            cell.iconText.font = cell.iconText.font.withSize(18)
            cell.iconText.frame = CGRect(x: 0, y: 81, width: 128, height: 24)
        }
        
        if indexPath.item == 2{
            
            //filling in animation
            let gradient = CAGradientLayer()
            gradient.frame = cell.selectedIcon.bounds
            gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
            gradient.locations = [0,0]
            
            cell.selectedIcon.layer.mask = gradient
            
            //change tabbarview
            tabBarView.frame.origin = CGPoint(x: cell.frame.origin.x + moveTabBarConstant, y: cell.frame.origin.y)
        }
        else{
            //filling in animation
            let gradient = CAGradientLayer()
            gradient.frame = cell.selectedIcon.bounds
            gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
            
            gradient.locations = [1,1]
            
            cell.selectedIcon.layer.mask = gradient
        }
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacingConstant
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if screenWidth == 375{
            if screenHeight == 812{
                return CGSize(width: 50, height: 55)
            }
            return CGSize(width: 46, height: 55)
        }
        else if screenWidth == 320 && screenHeight == 568{
            return CGSize(width: 46, height: 55)
        }
        else if screenWidth == 768 && screenHeight == 1024{
            return CGSize(width: 121, height: 100)
        }
        else if screenWidth == 1024 && screenHeight == 1366{
            return CGSize(width: 159, height: 120)
        }
        else if screenWidth == 834 && screenHeight == 1194{
            return CGSize(width: 125, height: 110)
        }
        else if screenWidth == 834 && screenHeight == 1112{
            return CGSize(width: 125, height: 110)
        }
        else if screenWidth == 810 && screenHeight == 1080{
            return CGSize(width: 128, height: 110)
        }
        return CGSize(width: 55, height: 60)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //if no selection animation is ongoing
        if isAnimationOngoing == false{
            
            //if previous cell != new cell selected
            if ifPreviousCell == true{
                if previousCellLocation == indexPath{
                    return
                }
            }
            
            //segue to given cells
            self.delegate?.switchTab(index: indexPath.item)
            
            
            isAnimationOngoing = true
            
            //set isAnimationOngoing to false after animations completed
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.31){
                self.isAnimationOngoing = false
            }
            
            //get selected cell
            let cell = collectionView.cellForItem(at: indexPath) as! TabBarCell
            
            //new cell location
            let cellLocation = CGPoint(x: cell.frame.origin.x + moveTabBarConstant, y: cell.frame.origin.y)
            
            //haptic feedback
            generator.selectionChanged()
            
            generator.prepare()
            
            //deselect previous cell
            if ifPreviousCell == true{
                //deselect cell
                
                let previousCell = collectionView.cellForItem(at: previousCellLocation) as! TabBarCell
                
                let animationDuration = abs(tabBarView.frame.size.width/(cellLocation.x - tabBarView.frame.origin.x) * 0.3)
                
                //if view is left of chosen cell
                if tabBarView.frame.origin.x > cellLocation.x{
                    
                    //deselecting animation
                    let gradient = CAGradientLayer()
                    gradient.frame = previousCell.selectedIcon.bounds
                    gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
                    gradient.locations = [1,1]
                    gradient.startPoint = CGPoint(x: 1, y: 0)
                    
                    gradient.endPoint = CGPoint(x: 0, y: 0)
                    
                    previousCell.selectedIcon.layer.mask = gradient
                    
                    let animation = CABasicAnimation(keyPath: "locations")
                    animation.fromValue = [0,0]
                    animation.toValue = [1,1]
                    animation.autoreverses = false
                    animation.duration = CFTimeInterval(animationDuration)
                    gradient.add(animation, forKey: nil)
                    
                }

                //if view is right of chosen cell
                else if tabBarView.frame.origin.x < cellLocation.x{
                    //deselecting animation
                    let gradient = CAGradientLayer()
                    gradient.frame = previousCell.selectedIcon.bounds
                    gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
                    gradient.locations = [1,1]
                    gradient.startPoint = CGPoint(x: 0, y: 0)
                    
                    gradient.endPoint = CGPoint(x: 1, y: 0)
                    
                    previousCell.selectedIcon.layer.mask = gradient
                    
                    let animation = CABasicAnimation(keyPath: "locations")
                    animation.fromValue = [0,0]
                    animation.toValue = [1,1]
                    animation.autoreverses = false
                    animation.duration = CFTimeInterval(animationDuration)
                    gradient.add(animation, forKey: nil)
                }
            }
            
            previousCellLocation = indexPath
            
            ifPreviousCell = true
            
            let durationTime = abs(0.3 * tabBarView.frame.size.width/(cellLocation.x - tabBarView.frame.origin.x))
            let delayTime = 0.3 - durationTime
            
            
            //if view is left of chosen cell
            if tabBarView.frame.origin.x > cellLocation.x{
                
                let timeBeforeGradient = Double((tabBarView.frame.origin.x - (cellLocation.x + tabBarView.frame.size.width))/(tabBarView.frame.origin.x - cellLocation.x))
                
                self.tabBarView.layer.removeAllAnimations()
                //animate view movement
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
                    self.tabBarView.frame.origin = cellLocation
                }, completion: nil)
                
                
                //delay
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(delayTime)){
                    //filling in animation
                    let gradient = CAGradientLayer()
                    gradient.frame = cell.selectedIcon.bounds
                    gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
                    gradient.locations = [0,0]
                    gradient.startPoint = CGPoint(x: 0, y: 0)
                    
                    gradient.endPoint = CGPoint(x: 1, y: 0)
                    
                    cell.selectedIcon.layer.mask = gradient
                    
                    let animation = CABasicAnimation(keyPath: "locations")
                    animation.fromValue = [1,1]
                    animation.toValue = [0,0]
                    animation.autoreverses = false
                    animation.duration = CFTimeInterval(durationTime)
                    
                    gradient.add(animation, forKey: nil)
                }
                
            }
            //if view is right of chosen cell
            else if tabBarView.frame.origin.x < cellLocation.x{
                let timeBeforeGradient = Double((cellLocation.x - (tabBarView.frame.origin.x + tabBarView.frame.size.width))/(cellLocation.x - tabBarView.frame.origin.x))
                
                
                self.tabBarView.layer.removeAllAnimations()
                
                //animate view movement
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
                    self.tabBarView.frame.origin = cellLocation
                }, completion:nil)
                
                
                //delay
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(delayTime)){
                    //filling in animation
                    let gradient = CAGradientLayer()
                    gradient.frame = cell.selectedIcon.bounds
                    gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
                    gradient.locations = [0,0]
                    gradient.startPoint = CGPoint(x: 1, y: 0)
                    
                    gradient.endPoint = CGPoint(x: 0, y: 0)
                    
                    cell.selectedIcon.layer.mask = gradient
                    
                    let animation = CABasicAnimation(keyPath: "locations")
                    animation.fromValue = [1,1]
                    animation.toValue = [0,0]
                    animation.autoreverses = false
                    animation.duration = CFTimeInterval(durationTime)
                    gradient.add(animation, forKey: nil)
                }
            }
        }
    }
}
