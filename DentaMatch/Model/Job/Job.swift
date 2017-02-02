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
        self.jobTypeDates = [job["jobTypeDates"].stringValue]
        self.jobTypeString = job["jobTypeString"].stringValue
    }
}
