//
//  Date+Additions.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 12/10/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation
extension Date {
    
    static func shortDate(date:Date)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: date)
    }
    
    static func getDate(date:Date)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: date)
    }
    
    func hour() -> Int {
        //Get Hour
        let calendar = NSCalendar.current
        let hour = calendar.component(.hour, from: self)
        //Return Hour
        return hour
    }
    
    
    func minute() -> Int {
        //Get Minute
        let calendar = NSCalendar.current
        let minute = calendar.component(.minute, from: self)
        return minute
    }
    
    func toShortTimeString() -> String {
        //Get Short Time String
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let timeString = formatter.string(from: self)
        //Return Short Time String
        return timeString
    }
    
//    static func getCurrentDate() -> NSDate {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        dateFormatter.timeZone = NSTimeZone.local
//        let todaysDate = NSDate()
//        let dateString = dateFormatter.stringFromDate(todaysDate as Date)
//        dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT")
//        return dateFormatter.dateFromString(dateString)!
//    }
    
//    static func getDayOfWeek(date:NSDate)->String?
//    {
//        let myCalendar = NSCalendar.currentCalendar()
//        myCalendar.timeZone = NSTimeZone(abbreviation: "GMT")!
//        let myComponents = myCalendar.components(.Weekday, fromDate: date)
//        let weekDay = myComponents.weekday
//        let weekdayString:String?
//        switch weekDay {
//        case 1:
//            weekdayString = "SUNDAY"
//        case 2:
//            weekdayString = "MONDAY"
//        case 3:
//            weekdayString = "TUESDAY"
//        case 4:
//            weekdayString = "WEDNESDAY"
//        case 5:
//            weekdayString = "THURSDAY"
//        case 6:
//            weekdayString = "FRIDAY"
//        case 7:
//            weekdayString = "SATURDAY"
//            
//        default:
//            weekdayString = "INVALID DAY"
//        }
//        return weekdayString
//    }
    
    //MARK:- Current time in milliseconds
    static func currentTimeMillis() -> Int64{
        let nowDouble = NSDate().timeIntervalSince1970
        return Int64(nowDouble*1000)
    }
    
}

public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs === rhs || lhs.compare(rhs as Date) == .orderedSame
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs as Date) == .orderedAscending
}
