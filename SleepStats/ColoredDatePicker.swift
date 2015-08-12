//
//  ColoredDatePicker.swift
//  SleepStats
//
//  Created by Tommy Bergeron on 2015-08-11.
//  Copyright © 2015 Brainpad Solutions. All rights reserved.
//

import UIKit

class ColoredDatePicker: UIDatePicker {
    var changed = false
    override func addSubview(view: UIView) {
        if !changed {
            changed = true
            self.setValue(UIColor.whiteColor(), forKey: "textColor")
        }
        super.addSubview(view)
    }
}