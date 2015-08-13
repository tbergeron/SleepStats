//
//  UIColorExtension.swift
//  SleepStats
//
//  Created by Tommy Bergeron on 2015-08-12.
//  Copyright © 2015 Brainpad Solutions. All rights reserved.
//

import Foundation

extension NSDate
{

    func flatSeconds() -> NSDate {
        var updatedDate = self
        let timeInterval = floor(updatedDate .timeIntervalSinceReferenceDate / 60.0) * 60.0
        updatedDate = NSDate(timeIntervalSinceReferenceDate: timeInterval)
        
        return updatedDate
    }
    
}