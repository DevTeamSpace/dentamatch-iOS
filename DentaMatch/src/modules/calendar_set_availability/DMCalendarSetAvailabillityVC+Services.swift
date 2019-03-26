//
//  DMCalendarSetAvailabillityVC+Services.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 28/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import SwiftyJSON
extension DMCalendarSetAvailabillityVC {
    
    func setMyAvailabilityOnServer() {
        var partTimeJobDays = [String]()

        if availablitytModel?.isParttime == true {
            if (availablitytModel?.isParttimeMonday)! {
                partTimeJobDays.append("monday")
            }
            if (availablitytModel?.isParttimeTuesday)! {
                partTimeJobDays.append("tuesday")
            }
            if (availablitytModel?.isParttimeWednesday)! {
                partTimeJobDays.append("wednesday")
            }
            if (availablitytModel?.isParttimeThursday)! {
                partTimeJobDays.append("thursday")
            }
            if (availablitytModel?.isParttimeFriday)! {
                partTimeJobDays.append("friday")
            }
            if (availablitytModel?.isParttimeSaturday)! {
                partTimeJobDays.append("saturday")
            }
            if (availablitytModel?.isParttimeSunday)! {
                partTimeJobDays.append("sunday")
            }
        }

        var param = [String: AnyObject]()
        param["isFulltime"] = isJobTypeFullTime! as AnyObject?
        param["partTimeDays"] = partTimeJobDays as AnyObject?
        if isTemporyAvail {
            param["tempdDates"] = availablitytModel?.tempJobDates as AnyObject?
        } else {
            param["tempdDates"] = [String]() as AnyObject?
        }

        viewOutput?.setAvailability(params: param)
    }
}
