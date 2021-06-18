//
//  UITabBar.swift
//  Calendar
//
//  Created by Mi Yan on 12/7/19.
//  Copyright © 2019 Darren Key. All rights reserved.
//

import UIKit

class UITabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        tabBar.layer.borderWidth = 0
        
        tabBar.clipsToBounds = true
        
        
        self.selectedIndex = Singleton.tabVC
        // Do any additional setup after loading the view.
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
