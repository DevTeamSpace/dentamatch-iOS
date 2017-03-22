//
//  Job.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 23/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import SwiftyJSON

class Job: NSObject {
    
    var isApplied = 0
    var jobId = 0
    var isSaved = 0
    var jobType = 0
    var isMonday = 0
    var isTuesday = 0
    var isWednesday = 0
    var isThursday = 0
    var isFriday = 0
    var isSaturday = 0
    var isSunday = 0
    var jobtitle = ""
    var officeName = ""
    var address = ""
    var zipcode = 0
    var latitude = ""
    var longitude = ""
    var distance = 0.0
    var postTime = ""
    var days = ""
    var officeDesc = ""

    var templateName = ""
    var templateDesc = ""
    var workEverydayStart = ""
    var workEverydayEnd = ""
    var mondayStart = ""
    var mondayEnd = ""
    var tuesdayStart = ""
    var tuesdayEnd = ""
    var wednesdayStart = ""
    var wednesdayEnd = ""
    var thursdayStart = ""
    var thursdayEnd = ""
    var fridayStart = ""
    var saturdayStart = ""
    var saturdayEnd = ""
    var sundayStart = ""
    var sundayEnd = ""
    var jobPostedTimeGap = ""
    var officeTypeName = ""
    var jobTypeDates = [String]()
    var jobTypeString = ""
    var jobCreatedAt = ""
    var jobAppliedOn = ""
    var jobDate = ""
    var tempjobDate = ""

//    var tempJobDates = [TempJobDate]()
    var noOfJobs = 0
    
    override init() {
        
    }
    
    init(job:JSON) {
        self.isApplied = job["isApplied"].intValue
        self.jobId = job["id"].intValue
        self.isSaved = job["isSaved"].intValue
        self.jobType = job["jobType"].intValue
        self.isMonday = job["isMonday"].intValue
        self.isTuesday = job["isTuesday"].intValue
        self.isWednesday = job["isWednesday"].intValue
        self.isThursday = job["isThursday"].intValue
        self.isFriday = job["isFriday"].intValue
        self.isSaturday = job["isSaturday"].intValue
        self.isSunday = job["isSunday"].intValue
        self.jobtitle = job["jobtitleName"].stringValue
        self.officeName = job["officeName"].stringValue
        self.address = job["address"].stringValue
        self.latitude = job["latitude"].stringValue
        self.longitude = job["longitude"].stringValue
        self.distance = Double(job["distance"].floatValue)
        self.zipcode = job["zipcode"].intValue
        self.postTime = job["createdAt"].stringValue
        self.days = job["days"].stringValue
        self.officeDesc = job["officeDesc"].stringValue
        self.templateName = job["templateName"].stringValue
        self.templateDesc = job["templateDesc"].stringValue
        self.workEverydayStart = job["workEverydayStart"].stringValue
        self.workEverydayEnd = job["workEverydayEnd"].stringValue
        self.mondayStart = job["mondayStart"].stringValue
        self.mondayEnd = job["mondayEnd"].stringValue
        self.tuesdayStart = job["tuesdayStart"].stringValue
        self.tuesdayEnd = job["tuesdayEnd"].stringValue
        self.wednesdayStart = job["wednesdayStart"].stringValue
        self.wednesdayEnd = job["wednesdayEnd"].stringValue
        self.thursdayStart = job["thursdayStart"].stringValue
        self.thursdayEnd = job["thursdayEnd"].stringValue
        self.fridayStart = job["fridayStart"].stringValue
        self.saturdayStart = job["saturdayStart"].stringValue
        self.saturdayEnd = job["saturdayEnd"].stringValue
        self.sundayStart = job["sundayStart"].stringValue
        self.sundayEnd = job["sundayEnd"].stringValue
        self.jobPostedTimeGap = job["jobPostedTimeGap"].stringValue
        self.officeTypeName = job["officeTypeName"].stringValue
        if let tempDates = job["jobTypeDates"].arrayObject as? [String] {
            self.jobTypeDates = tempDates
        }
        self.jobTypeString = job["jobTypeString"].stringValue
        self.jobCreatedAt = job["jobCreatedAt"].stringValue
        self.jobAppliedOn = job["jobAppliedOn"].stringValue
        self.jobDate = job["jobDate"].stringValue
        self.noOfJobs = job["noOfJobs"].intValue
    }
    
    init(forCalendarjob:JSON) {
        self.jobId = forCalendarjob["id"].intValue
        self.isSaved = forCalendarjob["isSaved"].intValue
        self.jobType = forCalendarjob["jobType"].intValue
        self.isMonday = forCalendarjob["isMonday"].intValue
        self.isTuesday = forCalendarjob["isTuesday"].intValue
        self.isWednesday = forCalendarjob["isWednesday"].intValue
        self.isThursday = forCalendarjob["isThursday"].intValue
        self.isFriday = forCalendarjob["isFriday"].intValue
        self.isSaturday = forCalendarjob["isSaturday"].intValue
        self.isSunday = forCalendarjob["isSunday"].intValue
        self.jobtitle = forCalendarjob["jobtitleName"].stringValue
        self.officeName = forCalendarjob["officeName"].stringValue
        self.address = forCalendarjob["address"].stringValue
        self.latitude = forCalendarjob["latitude"].stringValue
        self.longitude = forCalendarjob["longitude"].stringValue
        self.distance = Double(forCalendarjob["distance"].floatValue)
        self.zipcode = forCalendarjob["zipcode"].intValue
        self.postTime = forCalendarjob["createdAt"].stringValue
        self.days = forCalendarjob["days"].stringValue
        self.jobCreatedAt = forCalendarjob["jobCreatedAt"].stringValue
        self.jobAppliedOn = forCalendarjob["jobAppliedOn"].stringValue
        self.jobTypeString = forCalendarjob["jobTypeString"].stringValue
//        let tempDates = forCalendarjob["tempJobDates"].arrayValue
        self.noOfJobs = forCalendarjob["noOfJobs"].intValue
        self.jobDate = forCalendarjob["jobDate"].stringValue
        self.tempjobDate = forCalendarjob["tempDates"].stringValue
//        self.tempJobDates.removeAll()
//        for dateObj in tempDates {
//            let tempObj = TempJobDate(tempJobDate: dateObj)
//            self.tempJobDates.append(tempObj)
//        }
        
        
//        self.tempJobDates = tempJobDates
    }
}

class TempJobDate {
    
    var jobDate = ""
    var recruiterJobId = ""
    
    init(tempJobDate:JSON) {
        self.jobDate = tempJobDate["jobDate"].stringValue
        self.recruiterJobId = tempJobDate["recruiterJobId"].stringValue
    }
}
