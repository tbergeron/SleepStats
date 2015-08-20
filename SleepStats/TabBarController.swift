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
        
        let frame = CGRectMake(0, 0, self.view.bounds.size.width, 48);
        let view = UIView(frame: frame)
        
        view.backgroundColor = UIColor(hex: 0x212B46)
        view.alpha = 0.8
        
        self.tabBar.insertSubview(view, atIndex: 0)
        
        
        self.tabBar.tintColor = UIColor(hex: 0xFFD724)
    }
    
}