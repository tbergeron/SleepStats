//
//  NotificationHandler.swift
//  SleepStats
//
//  Created by Tommy Bergeron on 2015-08-11.
//  Copyright © 2015 Brainpad Solutions. All rights reserved.
//

import Foundation
import UIKit

class NotificationHandler {

    func scheduleNotification(action: String, body: String, date: NSDate) -> UILocalNotification {
        let notification: UILocalNotification = UILocalNotification()
        notification.alertAction = action
        notification.alertBody = body
        notification.soundName = "alarm.caf"
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.fireDate = date
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
        return notification
    }
    
}