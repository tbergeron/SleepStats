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
    
    func humanReadableTime() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        let formattedDate = dateFormatter.stringFromDate(self)
        
        return formattedDate
    }
    
    func humanReadableDate() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        
        let formattedDate = dateFormatter.stringFromDate(self)
        
        return formattedDate
    }
    
}