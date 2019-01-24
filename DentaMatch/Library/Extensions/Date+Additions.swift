//
//  Date+Additions.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 12/10/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation
extension Date {
    public static func dateFormatCCCCDDMMMYYYY() -> String {
        return "cccc, dd MMM yyyy"
    }

    public static func dateFormatCCCCDDMMMMYYYY() -> String {
        return "cccc, dd MMMM yyyy"
    }

    public static func dateFormatMMMMYYYY() -> String {
        return "MMMM yyyy"
    }

    public static func dateFormatDDMMMYYYY() -> String {
        return "dd MMM yyyy"
    }

    public static func dateFormatDDMMMMYYYY() -> String {
        return "dd MMMM yyyy"
    }

    public static func dateFormatDDMMYYYYDashed() -> String {
        return "dd-MM-yyyy"
    }

    public static func dateFormatDDMMYYYYSlashed() -> String {
        return "dd/MM/yyyy"
    }

    public static func dateFormatDDMMMYYYYSlashed() -> String {
        return "dd/MMM/yyyy"
    }

    public static func dateFormatMMMDDYYYY() -> String {
        return "MMM dd, yyyy"
    }

    public static func dateFormatYYYYMMDDDashed() -> String {
        return "yyyy-MM-dd"
    }

    public static func dateFormatMMDDYYYYDashed() -> String {
        return "MM-dd-YYYY hh:mmaa"
    }

    public static func dateFormatMMDDYYYY() -> String {
        return "MM-dd-yyyy"
    }

    public static func dateFormatYYYY() -> String {
        return "yyyy"
    }

    public static func dateFormatYYYYMMDDHHMMSS() -> String {
        return "yyyy-MM-dd HH:mm:ss"
    }

    public static func dateFormatYYYYMMDDHHMMSSAA() -> String {
        return "yyyy-MM-dd hh:mm:ss aa"
    }

    public static func dateFormatHHMM() -> String {
        return "hh:mma"
    }

    static func shortDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: date)
    }

    static func getDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: date)
    }

    func hour() -> Int {
        // Get Hour
        let calendar = NSCalendar.current
        let hour = calendar.component(.hour, from: self)
        // Return Hour
        return hour
    }

    static func stringToDateForYear(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormatYYYY() // "dd MMMM yyyy"
        //        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.date(from: dateString)!
    }

    static func stringToDate(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormatYYYYMMDDDashed() // "dd MMMM yyyy"
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.date(from: dateString)!
    }

    static func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormatYYYYMMDDDashed() // "dd MMMM yyyy"
        //        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: date)
    }

    static func stringToDateWithUTC(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormatYYYYMMDDDashed() // "dd MMMM yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.date(from: dateString)!
    }

    static func dateToStringWithUTC(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormatYYYYMMDDDashed() // "dd MMMM yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: date)
    }

    static func dateToStringForFormatter(date: Date, dateFormate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormate // "dd MMMM yyyy"
        //        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: date)
    }

    static func stringToDateForFormatter(date: String, dateFormate: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormate // "dd MMMM yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.date(from: date)!
    }

    static func commonDateFormatEEMMDD(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "EEE MMM dd"
            return dateFormatter.string(from: date)
        }
        return dateString
    }
    
    static func commonDateFormatDDMM(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "dd MMM"
            return dateFormatter.string(from: date)
        }
        return dateString
    }

    static func commonDateFormatMMDDYYYY(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "MM-dd-yyyy"
            return dateFormatter.string(from: date)
        }
        return dateString
    }

    func minute() -> Int {
        // Get Minute
        let calendar = NSCalendar.current
        let minute = calendar.component(.minute, from: self)
        return minute
    }

    func toShortTimeString() -> String {
        // Get Short Time String
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let timeString = formatter.string(from: self)
        // Return Short Time String
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

    public static func getMonthAndYearForm(date: Date) -> (month: Int, year: Int) {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
//        let day = calendar.component(.day, from: date)
        return (month, year)
    }

    public static func startOfMonth(date: Date) -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: date)))!
    }

    public static func endOfMonth(date: Date) -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: 1), to: startOfMonth(date: date))!
    }

    public static func getAnotherDateBasedOnThis(date1: Date, duration: Int) -> Date {
        let currentDate = date1
        let dateComponents: NSDateComponents = NSDateComponents()
        dateComponents.day = duration

        let calculatedDated: Date = NSCalendar.current.date(byAdding: dateComponents as DateComponents, to: currentDate)!
        return calculatedDated
    }

    public static func getMonthBasedOnThis(date1: Date, duration: Int) -> Date {
        let currentDate = date1
        let dateComponents: NSDateComponents = NSDateComponents()
        dateComponents.month = duration

        let calculatedDated: Date = NSCalendar.current.date(byAdding: dateComponents as DateComponents, to: currentDate)!
        return calculatedDated
    }

    static func getDate(timestamp: String) -> Date {
        let doubleTime = Double(timestamp)
        let lastMessageDate = Date(timeIntervalSince1970: doubleTime! / 1000)
        return lastMessageDate
    }

    // MARK: - Current time in milliseconds

    static func currentTimeMillis() -> Int64 {
        let nowDouble = NSDate().timeIntervalSince1970
        return Int64(nowDouble * 1000)
    }

    static func getTodaysDateMMDDYYYY() -> Date {
        let todaysDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Date.dateFormatMMDDYYYY()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.date(from: dateFormatter.string(from: todaysDate))!
    }

    static func getDateMMDDYYYY(date: Date) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Date.dateFormatMMDDYYYY()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.date(from: dateFormatter.string(from: date))!
    }

    static func getDateDashedMMDDYYYY(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Date.dateFormatMMDDYYYY()
        return dateFormatter.string(from: date)
    }
}

public func == (lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs === rhs || lhs.compare(rhs as Date) == .orderedSame
}

public func < (lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs as Date) == .orderedAscending
}
