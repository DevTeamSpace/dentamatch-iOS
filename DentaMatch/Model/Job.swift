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
    var zipcode = 000000
    var latitude = ""
    var longitude = ""
    var distance = 0.0
    var postTime = ""
    var days = ""
    
    override init() {
        
    }
    
    init(job:JSON) {
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
    }
}
