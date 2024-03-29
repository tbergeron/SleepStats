//
//  SleepLog.swift
//  SleepStats
//
//  Created by Tommy Bergeron on 2015-08-12.
//  Copyright © 2015 Brainpad Solutions. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class SleepLog : Object, NSCoding {
    
    // MARK: Model Properties
    
    dynamic private var startDate:  NSDate = NSDate() // when the user goes to sleep
    dynamic private var alarmDate:  NSDate = NSDate() // original alarm
    dynamic private var snoozeDate: NSDate = NSDate() // original alarm + snoozes
    dynamic private var durationInt:NSInteger = 0     // duration in seconds of sleep
    dynamic private var hasSnoozed: Bool = false      // has snoozed
    dynamic private var wokeUpDate: NSDate = NSDate() // date user ultimately woke up (woke up before alarm)
    
    // properties being ignored when Realm is saving
    override static func ignoredProperties() -> [String] {
        return ["startTime", "alarmTime", "snoozeTime", "snoozed", "duration", "wokeUpTime"]
    }
    
    // MARK: Computed Properties
    
    var startTime : NSDate {
        get {
            // from: flat it out to startDate 12:00:00
            let dateWithMidnight = self.startDate.setTimeToMidnight()
            
            // to: use from + 5 hours
            let components: NSDateComponents = NSDateComponents()
            components.setValue(5, forComponent: NSCalendarUnit.Hour);

            let datePlusFiveHours = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: dateWithMidnight, options: NSCalendarOptions(rawValue: 0))!
            
            // If startDate <=> (from)00:00-(to)05:00; startDate = -1 day
            if dateWithMidnight.compare(self.startDate) == .OrderedAscending && datePlusFiveHours.compare(self.startDate) == .OrderedDescending {
                let components: NSDateComponents = NSDateComponents()
                components.setValue(-1, forComponent: NSCalendarUnit.Day);
                return NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: self.startDate, options: NSCalendarOptions(rawValue: 0))!
            }
            
            return self.startDate
        }
        set(date) {
            self.startDate = date
        }
    }
    
    var alarmTime : NSDate {
        get {
            return self.alarmDate
        }
        set(date) {
            self.alarmDate = date
        }
    }
    
    var snoozeTime : NSDate {
        get {
            return self.snoozeDate
        }
        set(date) {
            self.snoozeDate = date
        }
    }
    
    var snoozed : Bool {
        get {
            return self.hasSnoozed
        }
        set(yesOrNo) {
            self.hasSnoozed = yesOrNo
        }
    }
    
    var duration : Int {
        get {
            return self.durationInt
        }
        set(seconds) {
            self.durationInt = seconds
        }
    }
    
    var humanReadableDuration : String {
        get {
            let (h,m,_) = self.durationInt.secondsToHoursMinutesSeconds()
            return String(format:"%dh %02d min", h, m)
        }
    }
    
    var wokeUpTime : NSDate {
        get {
            return self.wokeUpDate
        }
        set(date) {
            self.wokeUpDate = date
        }
    }
    
    var nextAlarmTime : String {
        var nextTime = self.alarmDate
        
        if self.hasSnoozed {
            nextTime = self.snoozeDate
        }
        
        return nextTime.humanReadableTime()
    }
    
    // MARK: Initializers
    
    required init(coder aDecoder: NSCoder) {
        self.startDate = (aDecoder.decodeObjectForKey("startDate") as? NSDate)!
        self.alarmDate = (aDecoder.decodeObjectForKey("alarmDate") as? NSDate)!
        self.hasSnoozed = (aDecoder.decodeObjectForKey("hasSnoozed") as? Bool)!
        self.snoozeDate = aDecoder.decodeObjectForKey("snoozeDate") as! NSDate
        self.durationInt = aDecoder.decodeObjectForKey("duration") as! NSInteger
        
        super.init()
    }


    required init() {
        super.init()
    }

    override init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
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
        self.wokeUpTime = NSDate()
        
        // saving duration based on snooze/alarm time
        if self.hasSnoozed {
            self.duration = NSInteger(self.snoozeDate.timeIntervalSinceDate(self.startDate))
        } else {
            self.duration = NSInteger(self.wokeUpTime.timeIntervalSinceDate(self.startDate))
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