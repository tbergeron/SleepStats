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

    let alarmStateKey = "IsAlarmActive"
    let currentSleepLogKey = "CurrentSleepLog"

    let defaults = NSUserDefaults.standardUserDefaults()
    let notificationHandler = NotificationHandler()
    let soundHandler = SoundHandler()
    
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
        
        let sleepLog = SleepLog(startDate: NSDate(), alarmDate: alarmDate)
        self.saveCurrentSleepLog(sleepLog)
        
        print("Alarm SET: \(sleepLog.alarmDate)")

        // create local notification
        self.createNotification(sleepLog.alarmDate)
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
    
    // getting fired when app is opened and notification is fired
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
            var currentAlarmDate = sleepLog.alarmDate
            
            // if already snoozed, use snoozeDate to add onto
            if let _ = sleepLog.snoozeDate {
                currentAlarmDate = sleepLog.snoozeDate!
            }
            
            // adding 15 minutes to current alarm
            // todo: option for snooze delay? 15/30mins etc
            let components: NSDateComponents = NSDateComponents()
            components.setValue(1, forComponent: NSCalendarUnit.Minute);
            
            let newAlarmDate = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: currentAlarmDate, options: NSCalendarOptions(rawValue: 0))!
            
            // updating sleeplog
            sleepLog.userSnoozed(newAlarmDate)
            self.saveCurrentSleepLog(sleepLog)

            print("Alarm SNOOZED: \(sleepLog.snoozeDate!)")
            
            // recreating updated local notification
            self.notificationHandler.cancelNotifications()
            self.createNotification(newAlarmDate)
            
            NSNotificationCenter.defaultCenter().postNotificationName("NeedRefreshView", object: self)
        }
    }
    
}