//
//  TabBarController.swift
//  TimeKeep
//
//  Created by Mi Yan on 4/26/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.isHidden = true
        self.moreNavigationController.navigationBar.isHidden = true
        
        self.selectedIndex = 2

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func 2(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
