//
//  Job.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 23/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import SwiftyJSON
import UIKit

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
    var fridayEnd = ""
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
    var currentDate = ""
    var noOfJobs = 0
    var matchedSkills = 0
    var percentSkillsMatch = 0.0
    var wageOffered = 0.0
    
    init(job: JSON) {
        isApplied = job["isApplied"].intValue
        jobId = job["id"].intValue
        isSaved = job["isSaved"].intValue
        jobType = job["jobType"].intValue
        isMonday = job["isMonday"].intValue
        isTuesday = job["isTuesday"].intValue
        isWednesday = job["isWednesday"].intValue
        isThursday = job["isThursday"].intValue
        isFriday = job["isFriday"].intValue
        isSaturday = job["isSaturday"].intValue
        isSunday = job["isSunday"].intValue
        jobtitle = job["jobtitleName"].stringValue
        officeName = job["officeName"].stringValue
        address = job["address"].stringValue
        latitude = job["latitude"].stringValue
        longitude = job["longitude"].stringValue
        distance = Double(job["distance"].floatValue)
        zipcode = job["zipcode"].intValue
        postTime = job["createdAt"].stringValue
        days = job["days"].stringValue
        officeDesc = job["officeDesc"].stringValue
        templateName = job["templateName"].stringValue
        templateDesc = job["templateDesc"].stringValue
        workEverydayStart = job["workEverydayStart"].stringValue
        workEverydayEnd = job["workEverydayEnd"].stringValue
        mondayStart = job["mondayStart"].stringValue
        mondayEnd = job["mondayEnd"].stringValue
        tuesdayStart = job["tuesdayStart"].stringValue
        tuesdayEnd = job["tuesdayEnd"].stringValue
        wednesdayStart = job["wednesdayStart"].stringValue
        wednesdayEnd = job["wednesdayEnd"].stringValue
        thursdayStart = job["thursdayStart"].stringValue
        thursdayEnd = job["thursdayEnd"].stringValue
        fridayStart = job["fridayStart"].stringValue
        fridayEnd = job["fridayEnd"].stringValue
        saturdayStart = job["saturdayStart"].stringValue
        saturdayEnd = job["saturdayEnd"].stringValue
        sundayStart = job["sundayStart"].stringValue
        sundayEnd = job["sundayEnd"].stringValue
        jobPostedTimeGap = job["jobPostedTimeGap"].stringValue
        officeTypeName = job["officeTypeName"].stringValue
        if let tempDates = job["jobTypeDates"].arrayObject as? [String] {
            jobTypeDates = tempDates
        }
        jobTypeString = job["jobTypeString"].stringValue
        jobCreatedAt = job["jobCreatedAt"].stringValue
        jobAppliedOn = job["jobAppliedOn"].stringValue
        jobDate = job["jobDate"].stringValue
        noOfJobs = job["noOfJobs"].intValue
        matchedSkills = job["matchedSkills"].intValue
        percentSkillsMatch = job["percentaSkillsMatch"].doubleValue
        wageOffered = job["wageOffered"].doubleValue
    }

    init(forCalendarjob: JSON) {
        jobId = forCalendarjob["id"].intValue
        isSaved = forCalendarjob["isSaved"].intValue
        jobType = forCalendarjob["jobType"].intValue
        isMonday = forCalendarjob["isMonday"].intValue
        isTuesday = forCalendarjob["isTuesday"].intValue
        isWednesday = forCalendarjob["isWednesday"].intValue
        isThursday = forCalendarjob["isThursday"].intValue
        isFriday = forCalendarjob["isFriday"].intValue
        isSaturday = forCalendarjob["isSaturday"].intValue
        isSunday = forCalendarjob["isSunday"].intValue
        jobtitle = forCalendarjob["jobtitleName"].stringValue
        officeName = forCalendarjob["officeName"].stringValue
        address = forCalendarjob["address"].stringValue
        latitude = forCalendarjob["latitude"].stringValue
        longitude = forCalendarjob["longitude"].stringValue
        distance = Double(forCalendarjob["distance"].floatValue)
        zipcode = forCalendarjob["zipcode"].intValue
        postTime = forCalendarjob["createdAt"].stringValue
        days = forCalendarjob["days"].stringValue
        jobCreatedAt = forCalendarjob["jobCreatedAt"].stringValue
        jobAppliedOn = forCalendarjob["jobAppliedOn"].stringValue
        jobTypeString = forCalendarjob["jobTypeString"].stringValue
        noOfJobs = forCalendarjob["noOfJobs"].intValue
        jobDate = forCalendarjob["jobDate"].stringValue
        tempjobDate = forCalendarjob["tempDates"].stringValue
        currentDate = forCalendarjob["currentDate"].stringValue
    }
}

class TempJobDate {
    var jobDate = ""
    var recruiterJobId = ""

    init(tempJobDate: JSON) {
        jobDate = tempJobDate["jobDate"].stringValue
        recruiterJobId = tempJobDate["recruiterJobId"].stringValue
    }
}
