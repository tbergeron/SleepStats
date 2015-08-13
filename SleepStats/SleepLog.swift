//
//  SleepLog.swift
//  SleepStats
//
//  Created by Tommy Bergeron on 2015-08-12.
//  Copyright © 2015 Brainpad Solutions. All rights reserved.
//

import Foundation

class SleepLog : NSObject, NSCoding {
    
    var startDate: NSDate                   // when the user goes to sleep
    var alarmDate: NSDate                   // original alarm
    var snoozeDate: NSDate? = nil           // original alarm + snoozes
    var duration: NSTimeInterval? = nil     // duration in seconds of sleep
    
    init(startDate: NSDate, alarmDate: NSDate) {
        self.startDate = startDate
        self.alarmDate = alarmDate
        self.alarmDate = self.alarmDate.flatSeconds()
    }
    
    required init(coder aDecoder: NSCoder) {
        self.startDate = (aDecoder.decodeObjectForKey("startDate") as? NSDate)!
        self.alarmDate = (aDecoder.decodeObjectForKey("alarmDate") as? NSDate)!
        self.snoozeDate = aDecoder.decodeObjectForKey("snoozeDate") as? NSDate
        self.duration = aDecoder.decodeObjectForKey("duration") as? NSTimeInterval
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.startDate, forKey: "startDate")
        aCoder.encodeObject(self.alarmDate, forKey: "alarmDate")
        
        if let snoozeDate = self.snoozeDate {
            aCoder.encodeObject(snoozeDate, forKey: "snoozeDate")
        }
        
        if let duration = self.duration {
            aCoder.encodeObject(duration, forKey: "wakeUpDate")
        }
    }
    
    func userWokeUp() {
        // saving duration based on snooze/alarm time
        if let _ = self.snoozeDate {
            self.duration = self.snoozeDate!.timeIntervalSinceDate(self.startDate)
            
        } else {
            self.duration = self.alarmDate.timeIntervalSinceDate(self.startDate)
            
        }
    }
    
    func userSnoozed(newDate: NSDate) {
        self.snoozeDate = newDate
        self.snoozeDate = self.snoozeDate?.flatSeconds()
    }
    
    // gets a human readable version of the next time the alarm will fire
    func getNextHumanFormattedAlarmTime() -> String {
        var nextTime = self.alarmDate
        
        if let _ = self.snoozeDate {
            nextTime = self.snoozeDate!
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        let formattedDate = dateFormatter.stringFromDate(nextTime)
        
        return formattedDate
    }
    
}