//
//  SleepViewController.swift
//  SleepStats
//
//  Created by Tommy Bergeron on 2015-08-08.
//  Copyright © 2015 Brainpad Solutions. All rights reserved.
//

import UIKit

class SleepViewController: UIViewController {
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var alarmPicker: ColoredDatePicker!
    @IBOutlet weak var sleepButton: UIButton!
    
    let alarm : Alarm = Alarm()
    
    @IBAction func sleepButtonPressed(sender: AnyObject) {
        if let enabled = self.alarm.isEnabled() {
            if enabled {
                self.alarm.cancelAlarm()
            } else {
                self.alarm.startAlarm(alarmPicker.date)
            }
        }

        self.refreshView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register observers
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userDidWakeUp", name: "UserDidWakeUp", object: nil)
        alarm.registerObservers()
        
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
    
    func refreshView() {      
        if let enabled = self.alarm.isEnabled() {
            if enabled {
                sleepButton.setTitle("I'm up!", forState: UIControlState.Normal)
                
                // setting back last alarm
                if let date = alarm.getAlarmDate() {
                    alarmPicker.setDate(date, animated: false)
                }
                
            } else {
                sleepButton.setTitle("Go to sleep...", forState: UIControlState.Normal)
                alarmPicker.setDate(NSDate(), animated: false)
            }
        }
    }
    
    func userDidWakeUp() {
        print("userDidWakeUp called")
        self.refreshView()
        
        // todo: save sleep log
        // todo: show night summary / message
    }

}

