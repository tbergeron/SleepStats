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

    let lastAlarmDateKey = "LastAlarmDate"
    let alarmStateKey = "IsAlarmActive"

    let defaults = NSUserDefaults.standardUserDefaults()
    
    func registerObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "alarmDidFire", name: "AlarmDidFire", object: nil)
    }
    
    func saveAlarmDate(date: NSDate) {
        var alarmDate = date
        
        // if time is before current time: use tomorrow
        // i.e. now: 2pm, alarm 5am (alarm is tomorrow)
//        if alarmDate.timeIntervalSinceNow < 0.0 {
//            // setting alarm same time, tomorrow
//            let components: NSDateComponents = NSDateComponents()
//            components.setValue(1, forComponent: NSCalendarUnit.Day);
//            alarmDate = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: date, options: NSCalendarOptions(rawValue: 0))!
//        }
        
        print(alarmDate)
        
        defaults.setObject(alarmDate, forKey: lastAlarmDateKey)
    }
    
    func getAlarmDate() -> NSDate? {
        if let date = defaults.objectForKey(lastAlarmDateKey) {
            return date as? NSDate
        }
        return nil
    }
    
    func isEnabled() -> Bool? {
        if let enabled : Bool = defaults.boolForKey(alarmStateKey) {
            return enabled
        }
        return nil
    }
    
    func startAlarm(date: NSDate) {
        // creating notifications for alarm
        // todo: build a subclass for notifications
        let notification: UILocalNotification = UILocalNotification()
        notification.alertAction = "SleepStats"
        notification.alertBody = "Wake up!"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.fireDate = NSDate(timeIntervalSinceNow: 30)
//            notification.fireDate = date
        UIApplication.sharedApplication().scheduleLocalNotification(notification)

        // save alarm state
        defaults.setBool(true, forKey: alarmStateKey)
        self.saveAlarmDate(notification.fireDate!)
    }
    
    func cancelAlarm() {
        // cancel all notifications
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        // save alarm state
        defaults.setBool(false, forKey: alarmStateKey)
    }
    
    func userDidSnooze() {
        print("snoozing")
        let currentAlarmDate = self.getAlarmDate()
        
        let components: NSDateComponents = NSDateComponents()
        components.setValue(10, forComponent: NSCalendarUnit.Second);

        let newAlarmDate = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: currentAlarmDate!, options: NSCalendarOptions(rawValue: 0))!

        // renewing alarm
        // todo: how to track time properly? 
        // todo: implementing sleeplog objects?
        self.cancelAlarm()
        self.startAlarm(newAlarmDate)
    }
    
    // getting fired when app is opened and notification is fired
    func alarmDidFire() {
        print("alarmDidFire called")

        // todo: play sound or something?
        let wakeUpAction = UIAlertAction(title: "Wake Up", style: .Cancel) { (action) in
            // shuts the alarm off
            self.cancelAlarm()
            // tells the SleepViewController that the user woke up
            NSNotificationCenter.defaultCenter().postNotificationName("UserDidWakeUp", object: self)
        }
        
        let snoozeAction = UIAlertAction(title: "Snooze", style: .Destructive) { (action) in
            self.userDidSnooze()
        }
        
        let alertController = UIAlertController(title: "Wow!", message: "TABARNAK ÇA MARCHE?!", preferredStyle: .Alert)
        alertController.addAction(wakeUpAction)
        alertController.addAction(snoozeAction)
        
        UIApplication.sharedApplication().keyWindow?.rootViewController!.presentViewController(alertController, animated: true) {

        }
    }
    
}