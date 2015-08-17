//
//  SleepLog.swift
//  SleepStats
//
//  Created by Tommy Bergeron on 2015-08-12.
//  Copyright © 2015 Brainpad Solutions. All rights reserved.
//

import Foundation
import RealmSwift

class SleepLog : Object, NSCoding {
    
    // MARK: Model Properties
    
    dynamic var startDate:  NSDate          // when the user goes to sleep
    dynamic var alarmDate:  NSDate          // original alarm
    dynamic var snoozeDate: NSDate          // original alarm + snoozes
    dynamic var duration:   NSInteger = 0   // duration in seconds of sleep
    dynamic var hasSnoozed: Bool = false    // has snoozed
    
    // MARK: Computed Properties
    
    var humanReadableAlarmTime : String {
        var nextTime = self.alarmDate
        
        if self.hasSnoozed {
            nextTime = self.snoozeDate
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        let formattedDate = dateFormatter.stringFromDate(nextTime)
        
        return formattedDate
    }
    
    // MARK: Initializers
    
    init(startDate: NSDate, alarmDate: NSDate) {
        self.startDate = startDate
        self.alarmDate = alarmDate.flatSeconds()
        self.snoozeDate = NSDate()
        
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        self.startDate = (aDecoder.decodeObjectForKey("startDate") as? NSDate)!
        self.alarmDate = (aDecoder.decodeObjectForKey("alarmDate") as? NSDate)!
        self.hasSnoozed = (aDecoder.decodeObjectForKey("hasSnoozed") as? Bool)!
        self.snoozeDate = aDecoder.decodeObjectForKey("snoozeDate") as! NSDate
        self.duration = aDecoder.decodeObjectForKey("duration") as! NSInteger
        
        super.init()
    }

    // todo: Realm makes this a realm fucking pain in the ass!!!
    required init() {
        self.startDate = NSDate()
        self.alarmDate = NSDate()
        self.snoozeDate = NSDate()
        
        super.init()
    }
    
    // MARK: NSCoding-related methods
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.startDate, forKey: "startDate")
        aCoder.encodeObject(self.alarmDate, forKey: "alarmDate")
        aCoder.encodeObject(self.hasSnoozed, forKey: "hasSnoozed")
        aCoder.encodeObject(self.snoozeDate, forKey: "snoozeDate")
        aCoder.encodeObject(self.duration, forKey: "duration")
    }

    // MARK: Model Methods
    
    func userWokeUp() {
        // saving duration based on snooze/alarm time
        if self.hasSnoozed {
            self.duration = NSInteger(self.snoozeDate.timeIntervalSinceDate(self.startDate))
            
        } else {
            self.duration = NSInteger(self.alarmDate.timeIntervalSinceDate(self.startDate))
            
        }
    }
    
    func userSnoozed(newDate: NSDate) {
        self.hasSnoozed = true
        self.snoozeDate = newDate.flatSeconds()
    }
    
    func save() {
        do {
            let realm = try Realm()
            
            realm.write {
                realm.add(self)
            }
        } catch {
            print(error)
        }
    }
    
}