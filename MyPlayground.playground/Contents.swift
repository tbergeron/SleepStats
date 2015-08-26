import UIKit

let dateFormatter = NSDateFormatter()
dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"

var arrayOfDates : Array<NSDate> = []
var date1 = dateFormatter.dateFromString("2015-08-26 10:30:00")
var date2 = dateFormatter.dateFromString("2015-08-26 9:00:00")
var date3 = dateFormatter.dateFromString("2015-08-26 11:30:00")
var date4 = dateFormatter.dateFromString("2015-08-26 11:15:00")
var date5 = dateFormatter.dateFromString("2015-08-26 9:15:00")
arrayOfDates.append(date1!)
arrayOfDates.append(date2!)
arrayOfDates.append(date3!)
arrayOfDates.append(date4!)
arrayOfDates.append(date5!)

func getAvgTime(results: Array<NSDate>) -> String {
    var totalHours = 0.0
    var totalMinutes = 0.0
    var avgTime = ""

    // sum all hours & minutes together
    for result in results {
        let hours = Double(NSCalendar.currentCalendar().component(NSCalendarUnit.Hour, fromDate: result))
        let minutes = Double(NSCalendar.currentCalendar().component(NSCalendarUnit.Minute, fromDate: result))
        
        totalHours = totalHours + hours
        totalMinutes = totalMinutes + minutes
    }
    
    // calculate avg hours
    let avgHourH : Int = Int(round(totalHours / Double(results.count)))
    
    // calculate avg minutes based on decimals
    let avgHourM : Int = Int(round(totalMinutes / Double(results.count)))
    
    // formating output hh:mm:00
    avgTime = String(format:"%d:%d:00", avgHourH, avgHourM)

    return avgTime
}

let avgTime = getAvgTime(arrayOfDates)
