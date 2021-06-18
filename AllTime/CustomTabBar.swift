//
//  CustomTabBar.swift
//  Calendar
//
//  Created by Mi Yan on 12/26/19.
//  Copyright © 2019 Darren Key. All rights reserved.
//

import UIKit

class CustomTabBar: UIViewController {

    var Categories: UIViewController!
    var Timer: UIViewController!
    var Statistics: UIViewController!
    
    var viewControllers: [UIViewController]!
    var selectedIndex: Int = 0
    
    
    @IBOutlet var buttons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // Do any additional setup after loading the view.
        
        Categories = storyboard.instantiateViewController(identifier: "Categories")
        Timer = storyboard.instantiateViewController(identifier: "Timer")
        Statistics = storyboard.instantiateViewController(identifier: "Chart")
        
        viewControllers = [Categories,Timer,Statistics]
        
        buttons[selectedIndex].isSelected = true
        didPressTab(buttons[selectedIndex])
    }
    
    @IBAction func didPressTab(_ sender: UIButton) {
    
        let previousIndex = selectedIndex
        selectedIndex = sender.tag
        
        buttons[previousIndex].isSelected = false
        
        let previousVC = viewControllers[previousIndex]
        previousVC.willMove(toParent: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParent()
        
        sender.isSelected = true
        
        let vc = viewControllers[selectedIndex]
        present(vc, animated: false, completion: nil)
    }
    /*
    // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
