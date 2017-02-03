//
//  UserAvailability.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 02/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import SwiftyJSON

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
    
    init(dict:JSON) {
        let newDict = dict["calendarAvailability"].dictionaryValue
        self.isFulltime = (newDict["isFulltime"]?.boolValue)!
        self.isParttimeMonday = (newDict["isParttimeMonday"]?.boolValue)!
        self.isParttimeTuesday = (newDict["isParttimeTuesday"]?.boolValue)!
        self.isParttimeWednesday = (newDict["isParttimeWednesday"]?.boolValue)!
        self.isParttimeThursday = (newDict["isParttimeThursday"]?.boolValue)!
        self.isParttimeFriday = (newDict["isParttimeFriday"]?.boolValue)!
        self.isParttimeSaturday = (newDict["isParttimeSaturday"]?.boolValue)!
        self.isParttimeSunday = (newDict["isParttimeSunday"]?.boolValue)!
        self.tempJobDates = dict["tempDatesAvailability"].arrayObject as! [String]
//        if (self.isParttimeMonday == true) || (self.isParttimeTuesday == true) || self.isParttimeWednesday || self.isParttimeThursday || self.isParttimeFriday || self.isParttimeSaturday || self.isParttimeSunday {
//            
//        }
       
        
    }
}
