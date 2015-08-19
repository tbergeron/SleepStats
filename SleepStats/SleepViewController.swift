//
//  SleepViewController.swift
//  SleepStats
//
//  Created by Tommy Bergeron on 2015-08-08.
//  Copyright © 2015 Brainpad Solutions. All rights reserved.
//

import UIKit
import AVFoundation

class SleepViewController: UIViewController {
    
    // MARK: Outlets & Actions
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var alarmPicker: ColoredDatePicker!
    @IBOutlet weak var sleepButton: UIButton!
    
    @IBAction func sleepButtonPressed(sender: AnyObject) {
        if let enabled = self.alarmHandler.isEnabled() {
            if enabled {
                self.alarmHandler.userDidWakeUp()
            } else {
//                 self.alarmHandler.startAlarm(NSDate(timeIntervalSinceNow: 15))
                self.alarmHandler.startAlarm(alarmPicker.date)
            }
        }
        
        self.refreshView()
    }
    
    // MARK: Properties
    
    let alarmHandler : AlarmHandler = AlarmHandler()

    // MARK: Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register observers
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userDidWakeUp", name: "UserDidWakeUp", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "needRefreshView", name: "NeedRefreshView", object: nil)
        self.alarmHandler.registerObservers()
        
        // rounded button
        sleepButton.layer.cornerRadius = 3
        
        self.refreshView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    // MARK: Controller methods
    
    func refreshView() {
        if let enabled = self.alarmHandler.isEnabled() {
            // switching labels
            if enabled {
                if let sleepLog = self.alarmHandler.getCurrentSleepLog() {
                    topLabel.text = "Good night!\nAlarm is set for \(sleepLog.nextAlarmTime)"
                }
                
                sleepButton.setTitle("I'm up!", forState: UIControlState.Normal)
                alarmPicker.hidden = true
                
                // todo: fade background?
                // self.view.backgroundColor = UIColor(red: 0, green: 64, blue: 128)
            } else {
                topLabel.text = "Don't forget to set your alarm!"
                sleepButton.setTitle("Go to sleep...", forState: UIControlState.Normal)
                alarmPicker.hidden = false
                
                // now + 5 mins
                let components: NSDateComponents = NSDateComponents()
                components.setValue(5, forComponent: NSCalendarUnit.Minute);
                let pickerDate = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: NSDate(), options: NSCalendarOptions(rawValue: 0))!
                alarmPicker.setDate(pickerDate, animated: false)
            }
        }
    }
    
    func userDidWakeUp() {
        print("userDidWakeUp called")
        self.refreshView()
        
        if let sleepLog = self.alarmHandler.getCurrentSleepLog() {
            print("startDate: \(sleepLog.startTime)")
            print("alarmDate: \(sleepLog.alarmTime)")
            print("snoozeDate: \(sleepLog.snoozeTime)")
            print("duration: \(sleepLog.duration)")
            
            sleepLog.save()
        }
    }
    
    func needRefreshView() {
        print("needRefreshView called")
        self.refreshView()
    }

}

