//
//  TimeAgo.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 10/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//
import Foundation

public func timeAgoSince(_ date: Date) -> String {
    let calendar = Calendar.current
    let now = Date()
    let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
    let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now, options: [])

    if let year = components.year, year >= 2 {
        return "\(year) years ago"
    }else if let year = components.year, year >= 1 {
        return "Last year"
    }else if let month = components.month, month >= 2 {
        return "\(month) months ago"
    }else if let month = components.month, month >= 1 {
        return "Last month"
    }else if let week = components.weekOfYear, week >= 2 {
        return "\(week) weeks ago"
    }else if let week = components.weekOfYear, week >= 1 {
        return "Last week"
    }else if let day = components.day, day >= 2 {
        return "\(day) days ago"
    }else if let day = components.day, day >= 1 {
        return "Yesterday"
    }else if let hour = components.hour, hour >= 2 {
        return "\(hour) hours ago"
    }else if let hour = components.hour, hour >= 1 {
        return "1 hour ago"
    }else if let minute = components.minute, minute >= 2 {
        return "\(minute) minutes ago"
    }else if let minute = components.minute, minute >= 1 {
        return "1 minute ago"
    }else if let second = components.second, second >= 3 {
        return "\(second) seconds ago"
    }
    return "Just now"
}

func timeAgoSinceDate(date: NSDate, numericDates: Bool) -> String {
    let calendar = Calendar.current
    let now = NSDate()
    let earliest = now.earlierDate(date as Date)
    let latest = (earliest == now as Date) ? date : now
//    let components:NSDateComponents = calendar.components([Calendar.Unit.minute , Calendar.Unit.hour , Calendar.Unit.day , Calendar.Unit.weekOfYear , Calendar.Unit.month , Calendar.Unit.year , Calendar.Unit.second], from: earliest, to: latest as Date, options: Calendar.Options())
    let components = calendar.dateComponents([.year, .weekOfYear, .month, .day, .hour, .minute, .second], from: earliest, to: latest as Date)

    if components.year! >= 2 {
        return "\(components.year ?? 0) years ago"
    } else if components.year! >= 1 {
        return numericDates ? "1 year ago" : "Last year"
    } else if components.month! >= 2 {
        return "\(components.month ?? 0) months ago"
    } else if components.month! >= 1 {
        return numericDates ? "1 month ago" : "Last month"
    } else if components.weekOfYear! >= 2 {
        return "\(components.weekOfYear ?? 0) weeks ago"
    } else if components.weekOfYear! >= 1 {
        return numericDates ? "1 week ago" : "Last week"
    } else if components.day! >= 2 {
        return "\(components.day ?? 0) days ago"
    } else if components.day! >= 1 {
        return numericDates ? "1 day ago" : "Yesterday"
    } else if components.hour! >= 2 {
        return "\(components.hour ?? 0) hours ago"
    } else if components.hour! >= 1 {
        return numericDates ? "1 hour ago" : "An hour ago"
    } else if components.minute! >= 2 {
        return "\(components.minute ?? 0) minutes ago"
    } else if components.minute! >= 1 {
        return numericDates ? "1 minute ago" : "A minute ago"
    } else if components.second! >= 3 {
        return "\(components.second ?? 0) seconds ago"
    } else {
        return "Just now"
    }
}
