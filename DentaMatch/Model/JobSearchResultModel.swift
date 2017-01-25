//
//  JobSearchResultModel.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 23/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import SwiftyJSON

class JobSearchResultModel: NSObject {

    var jobId = 0
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
    
    override init() {
        
    }
    
    init(jobDetail:JSON) {
        self.jobId = jobDetail["id"].intValue
        self.jobType = jobDetail["jobtitle_name"].intValue
        self.isMonday = jobDetail["isMonday"].intValue
        self.isTuesday = jobDetail["jobtitle_name"].intValue
        self.isWednesday = jobDetail["isTuesday"].intValue
        self.isThursday = jobDetail["isThursday"].intValue
        self.isFriday = jobDetail["isFriday"].intValue
        self.isSaturday = jobDetail["isSaturday"].intValue
        self.isSunday = jobDetail["isSunday"].intValue
        self.jobtitle = jobDetail["jobtitleName"].stringValue
        self.officeName = jobDetail["officeName"].stringValue
        self.address = jobDetail["address"].stringValue
        self.latitude = jobDetail["latitude"].stringValue
        self.longitude = jobDetail["longitude"].stringValue
        self.distance = Double(jobDetail["distance"].floatValue)
        self.zipcode = jobDetail["zipcode"].intValue
        self.postTime = jobDetail["createdAt"].stringValue
    }
}
