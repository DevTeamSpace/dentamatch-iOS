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
    func getMyAvailabilityFromServer(month _: Int, year _: Int, completionHandler: @escaping (JSON?, NSError?) -> Void) {
        var param = [String: AnyObject]()
        let firstDate = Date.getMonthBasedOnThis(date1: Date(), duration: -6)
        let lastDate = Date.getMonthBasedOnThis(date1: Date(), duration: 6)

        let date5 = gregorian?.fs_firstDay(ofMonth: firstDate)
        let date2 = gregorian?.fs_lastDay(ofMonth: lastDate)
        let strStartDate = Date.dateToString(date: date5!)
        let strEndDate = Date.dateToString(date: date2!)
        param["calendarStartDate"] = strStartDate as AnyObject?
        param["calendarEndDate"] = strEndDate as AnyObject?


        // print("setMyAvailabilityOnServer Parameters\n\(param.description))")

        showLoader()
        APIManager.apiPost(serviceName: Constants.API.getAvailabality, parameters: param) { (response: JSON?, error: NSError?) in
            self.hideLoader()
            if error != nil {
                self.makeToast(toastString: (error?.localizedDescription)!)
                return
            }
            guard let _ = response else {
                self.makeToast(toastString: Constants.AlertMessage.somethingWentWrong)
                return
            }
            //            debugPrint(response!)

            if response![Constants.ServerKey.status].boolValue {
                let resultDic = response![Constants.ServerKey.result]
                self.availablitytModel = UserAvailability(dict: resultDic)
                if (self.availablitytModel?.isParttimeMonday)! || (self.availablitytModel?.isParttimeTuesday)! || (self.availablitytModel?.isParttimeWednesday)! || (self.availablitytModel?.isParttimeThursday)! || (self.availablitytModel?.isParttimeFriday)! || (self.availablitytModel?.isParttimeSaturday)! || (self.availablitytModel?.isParttimeSunday)! {
                    self.availablitytModel?.isParttime = true
                    self.isPartTimeDayShow = true
                    self.isJobTypePartTime = "1"

                } else {
                    self.availablitytModel?.isParttime = false
                    self.isPartTimeDayShow = false
                    self.isJobTypePartTime = "0"
                }
                if self.availablitytModel?.isFulltime == true {
                    self.isJobTypeFullTime = "1"

                } else {
                    self.isJobTypeFullTime = "0"
                }
                if (self.availablitytModel?.tempJobDates.count)! > 0 {
                    self.isTemporyAvail = true
                } else {
                    self.isTemporyAvail = false
                }

//                self.makeToast(toastString: response![Constants.ServerKey.message].stringValue)
                // do next
                completionHandler(response, error)

            } else {
                self.makeToast(toastString: response![Constants.ServerKey.message].stringValue)
                completionHandler(response, error)
            }
        }
    }

    func setMyAvailabilityOnServer(completionHandler: @escaping (JSON?, NSError?) -> Void) {
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

        // print("setMyAvailabilityOnServer Parameters\n\(param.description))")

        showLoader()
        APIManager.apiPostWithJSONEncode(serviceName: Constants.API.setAvailabality, parameters: param) { (response: JSON?, error: NSError?) in
            self.hideLoader()
            if error != nil {
                self.makeToast(toastString: (error?.localizedDescription)!)
                return
            }
            guard let _ = response else {
                self.makeToast(toastString: Constants.AlertMessage.somethingWentWrong)
                return
            }
//            debugPrint(response!)

            if response![Constants.ServerKey.status].boolValue {
                self.makeToast(toastString: response![Constants.ServerKey.message].stringValue)
                // do next
                completionHandler(response, error)

            } else {
                self.makeToast(toastString: response![Constants.ServerKey.message].stringValue)
                completionHandler(response, error)
            }
        }
    }
}
