//
//  SleepLogRepository.swift
//  SleepStats
//
//  Created by Tommy Bergeron on 2015-08-20.
//  Copyright © 2015 Brainpad Solutions. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class SleepLogRepository {
    
    static func getAvgHours(results: Results<SleepLog>) -> String {
        var totalSeconds = 0
        
        // adding all seconds
        // todo: is there a way to do this via db?
        for result: SleepLog in results {
            totalSeconds += result.duration
        }
        
        // avg
        totalSeconds = totalSeconds / results.count
        
        let (h,m,_) = totalSeconds.secondsToHoursMinutesSeconds()
        return String(format:"%dh %02d min", h, m)
   }
    
}