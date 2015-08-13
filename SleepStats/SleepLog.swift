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
    var wakeUpDate: NSDate? = nil           // time at which user has actually woken up
    var duration: NSTimeInterval? = nil     // duration in seconds of sleep
    
    init(startDate: NSDate, alarmDate: NSDate) {
        self.startDate = startDate
        self.alarmDate = alarmDate
    }
    
    required init(coder aDecoder: NSCoder) {
        self.startDate = (aDecoder.decodeObjectForKey("startDate") as? NSDate)!
        self.alarmDate = (aDecoder.decodeObjectForKey("alarmDate") as? NSDate)!
        self.wakeUpDate = aDecoder.decodeObjectForKey("wakeUpDate") as? NSDate
        self.duration = aDecoder.decodeObjectForKey("duration") as? NSTimeInterval
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.startDate, forKey: "startDate")
        aCoder.encodeObject(self.alarmDate, forKey: "alarmDate")
        
        if let wakeUpDate = self.wakeUpDate {
            aCoder.encodeObject(wakeUpDate, forKey: "wakeUpDate")
        }
        
        if let duration = self.duration {
            aCoder.encodeObject(duration, forKey: "wakeUpDate")
        }
    }
    
    func userWokeUp() {
        // saving actual wake up time and duration
        self.wakeUpDate = NSDate()
        self.duration = self.startDate.timeIntervalSinceDate(self.wakeUpDate!)
    }
    
}