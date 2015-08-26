//: Playground - noun: a place where people can play

import UIKit

extension NSDate
{
    
    func flatSeconds() -> NSDate {
        var updatedDate = self
        let timeInterval = floor(updatedDate .timeIntervalSinceReferenceDate / 60.0) * 60.0
        updatedDate = NSDate(timeIntervalSinceReferenceDate: timeInterval)
        
        return updatedDate
    }
    
}

let laDate = NSDate()

print(String(laDate))

print(String(laDate.flatSeconds()))

