//
//  CustomUITabBarController.swift
//  SleepStats
//
//  Created by Tommy Bergeron on 2015-08-20.
//  Copyright © 2015 Brainpad Solutions. All rights reserved.
//

import UIKit

class TabBarController : UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // bright tint
        self.tabBar.tintColor = UIColor(hex: 0xFFFFFF)
    }

}