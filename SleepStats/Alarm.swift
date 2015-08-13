//
//  Alarm.swift
//  SleepStats
//
//  Created by Tommy Bergeron on 2015-08-11.
//  Copyright © 2015 Brainpad Solutions. All rights reserved.
//

import Foundation
import UIKit

class Alarm : NSObject {

    let alarmStateKey = "IsAlarmActive"
    let currentSleepLogKey = "CurrentSleepLog"

    let defaults = NSUserDefaults.standardUserDefaults()
    let notificationHandler = NotificationHandler()
    let soundManager = SoundManager()
    
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

    func getAlarmDate() -> NSDate? {
        if let sleepLog = self.getCurrentSleepLog() {
            return sleepLog.alarmDate
        }
        return nil
    }
    
    func getHumanFormattedAlarmDate() -> String? {
        if let sleepLog = self.getCurrentSleepLog() {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
            dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle

            let formattedDate = dateFormatter.stringFromDate(sleepLog.alarmDate)
            
            return formattedDate
        }
        return nil
    }
    
    func isEnabled() -> Bool? {
        if let enabled : Bool = defaults.boolForKey(alarmStateKey) {
            return enabled
        }
        return nil
    }
    
    // todo: this method sure looks like shit
    func startAlarm(date: NSDate) {
        // save alarm state
        defaults.setBool(true, forKey: alarmStateKey)
        let alarmDate = self.saveAlarmDate(date)
        self.createNotification(alarmDate)
    }
    
    func cancelAlarm() {
        // cancel all notifications
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        // save alarm state
        defaults.setBool(false, forKey: alarmStateKey)
    }

    func createNotification(alarmDate: NSDate) {
        // creating notifications for alarm
        self.notificationHandler.scheduleNotification("SleepStats", body: "Wake Up!", date: alarmDate)
    }
    
    func saveAlarmDate(date: NSDate) -> NSDate {
        var alarmDate = date
        
        // if time is before current time: use tomorrow
        // i.e. now: 2pm, alarm 5am (alarm is tomorrow)
        if NSDate().compare(alarmDate) == NSComparisonResult.OrderedDescending {
            // setting alarm same time, tomorrow
            let components: NSDateComponents = NSDateComponents()
            components.setValue(1, forComponent: NSCalendarUnit.Day);
            alarmDate = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: date, options: NSCalendarOptions(rawValue: 0))!
        }
        
        // todo: flat seconds so it rings right on the minute
        
        print("Alarm SET: \(alarmDate)")
        
        let sleepLog = SleepLog(startDate: NSDate(), alarmDate: alarmDate)
        self.saveCurrentSleepLog(sleepLog)
        
        return alarmDate
    }
    
    func userDidSnooze() {
        if let sleepLog = self.getCurrentSleepLog() {
            let currentAlarmDate = sleepLog.alarmDate
            
            // adding 15 minutes to current alarm
            // todo: option for snooze delay? 15/30mins etc
            let components: NSDateComponents = NSDateComponents()
            components.setValue(15, forComponent: NSCalendarUnit.Second);
            
            let newAlarmDate = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: currentAlarmDate, options: NSCalendarOptions(rawValue: 0))!
            
            print("Alarm SNOOZED: \(newAlarmDate)")
            
            // renewing alarm
            // todo: keep track of original alarm time
            sleepLog.alarmDate = newAlarmDate
            self.saveCurrentSleepLog(sleepLog)

            // todo: make this clearer
            self.cancelAlarm()
            defaults.setBool(true, forKey: alarmStateKey)

            self.createNotification(newAlarmDate)
            
            NSNotificationCenter.defaultCenter().postNotificationName("NeedRefreshView", object: self)
        }
    }
    
    // getting fired when app is opened and notification is fired
    func alarmDidFire() {
        print("alarmDidFire called")

        // play sound or something
        // todo: preference for alarm sounds
        self.soundManager.play("alarm")
        
        let wakeUpAction = UIAlertAction(title: "Wake Up", style: .Cancel) { (action) in
            // shuts the alarm off
            self.cancelAlarm()
            // tells the SleepViewController that the user woke up
            NSNotificationCenter.defaultCenter().postNotificationName("UserDidWakeUp", object: self)
            // stop sound after prompt
            self.soundManager.stop()
        }
        
        let snoozeAction = UIAlertAction(title: "Snooze", style: .Destructive) { (action) in
            self.userDidSnooze()
            // stop sound after prompt
            self.soundManager.stop()
        }
        
        let alertController = UIAlertController(title: "Wow!", message: "Time to wake up!", preferredStyle: .Alert)
        alertController.addAction(wakeUpAction)
        alertController.addAction(snoozeAction)
        
        UIApplication.sharedApplication().keyWindow?.rootViewController!.presentViewController(alertController, animated: true) {
        }
    }
    
}