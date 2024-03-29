//
//  AppDelegate.swift
//  SleepStats
//
//  Created by Tommy Bergeron on 2015-08-08.
//  Copyright © 2015 Brainpad Solutions. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        if(UIApplication.instancesRespondToSelector(Selector("registerUserNotificationSettings:"))) {
            application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Sound, .Alert, .Badge], categories: nil))
        }
        
        return true
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        application.applicationIconBadgeNumber = 0
        
        print("didReceiveLocalNotification called")

        // calling observer from Alarm class
        NSNotificationCenter.defaultCenter().postNotificationName("AlarmDidFire", object: self)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        // firing alarm event on start if due (usually coming from local notification)
        let alarmHandler = AlarmHandler()
        if let enabled = alarmHandler.isEnabled() {
            print("IsEnabled? \(String(enabled))")
            print("  Now: \(NSDate())")

            if enabled {
                if let sleepLog = alarmHandler.getCurrentSleepLog() {
                    print("Alarm: \(sleepLog.alarmTime)")

                    if NSDate().compare(sleepLog.alarmTime) == NSComparisonResult.OrderedDescending {
                        print("applicationDidBecomeActive called AlarmDidFire")
                        NSNotificationCenter.defaultCenter().postNotificationName("AlarmDidFire", object: self)
                    }
                    
                }
            }
        }
        
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

