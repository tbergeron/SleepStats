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
    
    func setTimeToMidnight() -> NSDate {
        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        return cal!.dateBySettingHour(0, minute: 0, second: 0, ofDate: self, options: NSCalendarOptions())!
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
        
        // i.e. Tue, Aug 18
        dateFormatter.dateFormat = "E, MMM dd"
        
        let formattedDate = dateFormatter.stringFromDate(self)
        
        return formattedDate
    }
    
}