//
//  UserAvailability.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 02/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import SwiftyJSON
import UIKit

class UserAvailability: NSObject {
    var isFulltime = false
    var isParttime = false
    var isParttimeMonday = false
    var isParttimeTuesday = false
    var isParttimeWednesday = false
    var isParttimeThursday = false
    var isParttimeFriday = false
    var isParttimeSaturday = false
    var isParttimeSunday = false
    var tempJobDates = [String]()

    override init() {
        // for empty
    }

    init(dict: JSON) {
        let newDict = dict["calendarAvailability"].dictionaryValue
        isFulltime = (newDict["isFulltime"]?.boolValue)!
        isParttimeMonday = (newDict["isParttimeMonday"]?.boolValue)!
        isParttimeTuesday = (newDict["isParttimeTuesday"]?.boolValue)!
        isParttimeWednesday = (newDict["isParttimeWednesday"]?.boolValue)!
        isParttimeThursday = (newDict["isParttimeThursday"]?.boolValue)!
        isParttimeFriday = (newDict["isParttimeFriday"]?.boolValue)!
        isParttimeSaturday = (newDict["isParttimeSaturday"]?.boolValue)!
        isParttimeSunday = (newDict["isParttimeSunday"]?.boolValue)!
        tempJobDates = dict["tempDatesAvailability"].arrayObject as! [String]
//        if (self.isParttimeMonday == true) || (self.isParttimeTuesday == true) || self.isParttimeWednesday || self.isParttimeThursday || self.isParttimeFriday || self.isParttimeSaturday || self.isParttimeSunday {
//
//        }
    }
}
