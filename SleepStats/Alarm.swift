//
//  Alarm.swift
//  SleepStats
//
//  Created by Tommy Bergeron on 2015-08-11.
//  Copyright © 2015 Brainpad Solutions. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class Alarm : NSObject {

    let lastAlarmDateKey = "LastAlarmDate"
    let alarmStateKey = "IsAlarmActive"

    let defaults = NSUserDefaults.standardUserDefaults()
    let notificationHandler = NotificationHandler()
    var player: AVAudioPlayer?

    func registerObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "alarmDidFire", name: "AlarmDidFire", object: nil)
    }
    
    func getAlarmDate() -> NSDate? {
        if let date = defaults.objectForKey(lastAlarmDateKey) {
            return date as? NSDate
        }
        return nil
    }
    
    func getHumanFormattedAlarmDate() -> String? {
        if let date = defaults.objectForKey(lastAlarmDateKey) {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
            dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
            let formattedDate = dateFormatter.stringFromDate(date as! NSDate)
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
    
    func startAlarm(date: NSDate) {
        // save alarm state
        defaults.setBool(true, forKey: alarmStateKey)
        let alarmDate = self.saveAlarmDate(date)

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
        
        defaults.setObject(alarmDate, forKey: lastAlarmDateKey)
        
        return alarmDate
    }
    
    func cancelAlarm() {
        // cancel all notifications
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        // save alarm state
        defaults.setBool(false, forKey: alarmStateKey)
    }
    
    func userDidSnooze() {
        let currentAlarmDate = self.getAlarmDate()
        
        // adding 15 minutes to current alarm
        // todo: option for snooze delay? 15/30mins etc
        let components: NSDateComponents = NSDateComponents()
        components.setValue(15, forComponent: NSCalendarUnit.Second);

        let newAlarmDate = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: currentAlarmDate!, options: NSCalendarOptions(rawValue: 0))!

        print("Alarm SNOOZED: \(newAlarmDate)")

        // todo: how to track time properly?
        // todo: implementing sleeplog objects?

        // renewing alarm
        self.cancelAlarm()
        self.startAlarm(newAlarmDate)
    }
    
    // getting fired when app is opened and notification is fired
    func alarmDidFire() {
        print("alarmDidFire called")

        // play sound or something
        // todo: put that somewhere else (soundmanager class?)
        let soundUrl = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("alarm", ofType: "caf")!)
        do {
            self.player = try AVAudioPlayer(contentsOfURL: soundUrl)
            self.player?.prepareToPlay()
        } catch {
            print(error)
        }
        self.player?.play()
        
        let wakeUpAction = UIAlertAction(title: "Wake Up", style: .Cancel) { (action) in
            // shuts the alarm off
            self.cancelAlarm()
            // tells the SleepViewController that the user woke up
            NSNotificationCenter.defaultCenter().postNotificationName("UserDidWakeUp", object: self)
            // stop sound after prompt
            self.player?.stop()
        }
        
        let snoozeAction = UIAlertAction(title: "Snooze", style: .Destructive) { (action) in
            self.userDidSnooze()
            // stop sound after prompt
            self.player?.stop()
        }
        
        let alertController = UIAlertController(title: "Wow!", message: "Time to wake up!", preferredStyle: .Alert)
        alertController.addAction(wakeUpAction)
        alertController.addAction(snoozeAction)
        
        UIApplication.sharedApplication().keyWindow?.rootViewController!.presentViewController(alertController, animated: true) {
        }
    }
    
}