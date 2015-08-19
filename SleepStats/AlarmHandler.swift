//
//  Alarm.swift
//  SleepStats
//
//  Created by Tommy Bergeron on 2015-08-11.
//  Copyright © 2015 Brainpad Solutions. All rights reserved.
//

import Foundation
import UIKit

class AlarmHandler : NSObject {

    // MARK: Properties
    
    let alarmStateKey = "IsAlarmActive"
    let currentSleepLogKey = "CurrentSleepLog"

    let defaults = NSUserDefaults.standardUserDefaults()
    let notificationHandler = NotificationHandler()
    let soundHandler = SoundHandler()
    
    // MARK: Class Methods
    func registerObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "alarmDidFire", name: "AlarmDidFire", object: nil)
    }
    
    func getCurrentSleepLog() -> SleepLog? {
        if let archivedObject = defaults.objectForKey(currentSleepLogKey) {
            let sleepLog = NSKeyedUnarchiver.unarchiveObjectWithData(archivedObject as! NSData) as? SleepLog
            return sleepLog
        }
        
        return nil
    }
    
    func saveCurrentSleepLog(sleepLog: SleepLog) {
        let archivedObject = NSKeyedArchiver.archivedDataWithRootObject(sleepLog)
        defaults.setObject(archivedObject, forKey: currentSleepLogKey)
    }
    
    func isEnabled() -> Bool? {
        if let enabled : Bool = defaults.boolForKey(alarmStateKey) {
            return enabled
        }
        return nil
    }
    
    func createNotification(alarmDate: NSDate) {
        // creating notifications for alarm
        self.notificationHandler.scheduleNotification("SleepStats", body: "Wake Up!", date: alarmDate)
    }
    
    func startAlarm(date: NSDate) {
        var alarmDate = date
        // if time is before current time: use tomorrow
        // i.e. now: 2pm, alarm 5am (alarm is tomorrow)
        if NSDate().compare(alarmDate) == NSComparisonResult.OrderedDescending {
            // setting alarm same time, tomorrow
            let components: NSDateComponents = NSDateComponents()
            components.setValue(1, forComponent: NSCalendarUnit.Day);
            alarmDate = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: date, options: NSCalendarOptions(rawValue: 0))!
        }
        
        let sleepLog = SleepLog()
        sleepLog.startTime = NSDate()
        sleepLog.alarmTime = alarmDate
        self.saveCurrentSleepLog(sleepLog)
        
        print("Alarm SET: \(sleepLog.alarmTime)")

        // create local notification
        self.createNotification(sleepLog.alarmTime)
        // enable alarm
        defaults.setBool(true, forKey: alarmStateKey)
    }
    
    func stopAlarm() {
        // stop sound
        self.soundHandler.stop()
        // cancel all notifications
        self.notificationHandler.cancelNotifications()
        // save alarm state
        defaults.setBool(false, forKey: alarmStateKey)
    }
    
    // MARK: Events called by observers or elsewhere
    
    func alarmDidFire() {
        print("alarmDidFire called")
        
        // play sound or something
        // todo: preference for alarm sounds
        self.soundHandler.play("alarm")
        
        let wakeUpAction = UIAlertAction(title: "Wake Up", style: .Cancel) { (action) in
            self.userDidWakeUp()
        }
        
        let snoozeAction = UIAlertAction(title: "Snooze", style: .Destructive) { (action) in
            self.userDidSnooze()
        }
        
        let alertController = UIAlertController(title: "Wow!", message: "Time to wake up!", preferredStyle: .Alert)
        alertController.addAction(wakeUpAction)
        alertController.addAction(snoozeAction)
        
        UIApplication.sharedApplication().keyWindow?.rootViewController!.presentViewController(alertController, animated: true) {
        }
    }
    
    func userDidWakeUp() {
        if let sleepLog = self.getCurrentSleepLog() {
            sleepLog.userWokeUp()
            self.saveCurrentSleepLog(sleepLog)
        }
        // shuts the alarm off
        self.stopAlarm()
        // tells the SleepViewController that the user woke up
        NSNotificationCenter.defaultCenter().postNotificationName("UserDidWakeUp", object: self)
    }

    func userDidSnooze() {
        // stop sound
        self.soundHandler.stop()

        if let sleepLog = self.getCurrentSleepLog() {
            var currentAlarmDate = sleepLog.alarmTime
            
            // if already snoozed, use snoozeDate to add onto
            if sleepLog.snoozed {
                currentAlarmDate = sleepLog.snoozeTime
            }
            
            // adding 15 minutes to current alarm
            // todo: option for snooze delay? 15/30mins etc
            let components: NSDateComponents = NSDateComponents()
            components.setValue(15, forComponent: NSCalendarUnit.Minute);
            
            let newAlarmDate = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: currentAlarmDate, options: NSCalendarOptions(rawValue: 0))!
            
            // updating sleeplog
            sleepLog.userSnoozed(newAlarmDate)
            self.saveCurrentSleepLog(sleepLog)

            print("Alarm SNOOZED: \(sleepLog.snoozeTime)")
            
            // recreating updated local notification
            self.notificationHandler.cancelNotifications()
            self.createNotification(newAlarmDate)
            
            NSNotificationCenter.defaultCenter().postNotificationName("NeedRefreshView", object: self)
        }
    }
    
}