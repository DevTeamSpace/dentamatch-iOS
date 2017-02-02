//
//  Date+Additions.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 12/10/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation
extension Date {
    
    public static func dateFormatCCCCDDMMMYYYY() ->String {
        return "cccc, dd MMM yyyy"
    }
    public static func dateFormatCCCCDDMMMMYYYY() ->String {
        return "cccc, dd MMMM yyyy"
    }
    public static func dateFormatMMMMYYYY() ->String {
        return "MMMM, yyyy"
    }
    public static func dateFormatDDMMMYYYY() ->String {
        return "dd MMM yyyy"
    }
    
    public static func dateFormatDDMMMMYYYY() ->String {
        return "dd MMMM yyyy"
    }
    
    public static func dateFormatDDMMYYYYDashed() ->String {
        return "dd-MM-yyyy"
    }
    
    public static func dateFormatDDMMYYYYSlashed() ->String {
        return "dd/MM/yyyy"
    }
    public static func dateFormatDDMMMYYYYSlashed() ->String {
        return "dd/MMM/yyyy"
    }
    public static func dateFormatMMMDDYYYY() ->String {
        return "MMM dd, yyyy"
    }
    public static func dateFormatYYYYMMDDDashed() ->String {
        return "yyyy-MM-dd"
    }
    
    public static func dateFormatYYYY()->String {
        return "yyyy"
    }
    
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
    
    static func stringToDateForYear(dateString:String)-> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormatYYYY()//"dd MMMM yyyy"
        //        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.date(from: dateString)!
    }
    
    
     static func stringToDate(dateString:String)-> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormatYYYYMMDDDashed()//"dd MMMM yyyy"
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.date(from: dateString)!
    }
    static func dateToString(date:Date)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormatYYYYMMDDDashed()//"dd MMMM yyyy"
        //        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: date)
    }

    static func dateToStringForFormatter(date:Date,dateFormate:String)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormate//"dd MMMM yyyy"
        //        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: date)
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
    
    public func formattedString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = Date.dateFormatDDMMYYYYDashed()
        return formatter.string(from: self)
    }
    
    public func formattedStringUsingFormat(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }

    
    
    //MARK:- Current time in milliseconds
    static func currentTimeMillis() -> Int64{
        let nowDouble = NSDate().timeIntervalSince1970
        return Int64(nowDouble*1000)
    }
    
}

public func == (lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs === rhs || lhs.compare(rhs as Date) == .orderedSame
}

public func < (lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs as Date) == .orderedAscending
}
